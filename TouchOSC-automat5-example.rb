# -----------------------------------------------------------------------------#
# CONTROLLING SONIC PI WITH OSC                                                #
# -----------------------------------------------------------------------------#
# SonicPi v3.1 (https://sonic-pi.net/)
# TouchOSC v1.9.10 (https://itunes.apple.com/us/app/touchosc/id288120394)
# TouchOSC Layout: Automat5 (there are 3 sublayouts in Automat5, use the first one)
# composition by dcts and HexagonSix (2019-03-13)

# -----------------------------------------------------------------------------#
# SETUP                                                                        #
# -----------------------------------------------------------------------------#
# $c = controller (globally visible)
# data structure that stores all values recieved from TouchOSC
$c = {
  :A => {:t1 => 0, :t2 => 0, :f => 0, :r => 0},          # green group (A)
  :B => {:t1 => 0, :t2 => 0, :f => 0, :r => 0},          # red group (B)
  :C => {:t1 => 0, :t2 => 0, :f => 0, :r => 0},          # turquoise group (C)
  :D => {:t1 => 0, :t2 => 0, :f => 0, :r => 0},          # yellow group (D)
  :M => {:fM => 0, :f1 => 0, :f2 =>0, :f3=> 0, :f4=> 0}  # grey group (M)
}

def print_controller_values
  # prints all controller values to console (for debugging and setting up)
  # for better visibility disable all protocol logs
  # - go to sonicPi preferences (CTRL+P)
  # - go to Editor
  # - disable all protocol logs
  # - enable automatically scroll protocol
  $c.each do |k, v| # k=key, v=value
    if k!=:M # k is :A, :B, :C or :D
      puts sprintf("#{k}: t1=%d | t2=%d | f=%.3f | r=%.3f ", v[:t1], v[:t2], v[:f], v[:r])
    elsif # k===:M (grey group)
      puts sprintf("#{k}: fM=%.2f | f1=%.2f | f2=%.2f | f3=%.2f | f4=%.2f ", v[:fM], v[:f1], v[:f2], v[:f3], v[:f4])
    end
  end
end

def connect_element(group, element, element_name)
  # important: element_name has to be the specific name that TouchOSC is sending
  # group refers to (:A, :B, :C, :D, :M) od the controller $c.
  # elements refer to toggle-button, fader oder rotary (:t1, :t2, :r, :f, :f2, etc..)
  live_loop element_name.to_sym do
    use_real_time
    x = sync "/osc*/#{element_name}"
    x = x.choose # this line is mandatory to being able to import the value send by TouchOSC
    $c[group][element] = x
    print_controller_values
  end
end

def mapp(val, vStart, vEnd)
  # HELPERFUNCTION to map values recieved from TouchOSC
  # maps a value with range [0, 1] to a new range with [vStart, vEnd].
  # val needs to be between 0 and 1.
  # both way mapping allowed [130, 80] as well as [80, 130]
  return (val * (vEnd - vStart)) + vStart
end

# connect all elements from "Automat5" Layout (only the first screen)
connect_element(:A, :t1, "toggleA_1")
connect_element(:A, :t2, "toggleA_2")
connect_element(:A, :f,  "1/faderA")
connect_element(:A, :r,  "1/rotaryA")
connect_element(:B, :t1, "toggleB_1")
connect_element(:B, :t2, "toggleB_2")
connect_element(:B, :f,  "1/faderB")
connect_element(:B, :r,  "1/rotaryB")
connect_element(:C, :t1, "toggleC_1")
connect_element(:C, :t2, "toggleC_2")
connect_element(:C, :f,  "1/faderC")
connect_element(:C, :r,  "1/rotaryC")
connect_element(:D, :t1, "toggleD_1")
connect_element(:D, :t2, "toggleD_2")
connect_element(:D, :f,  "1/faderD")
connect_element(:D, :r,  "1/rotaryD")
connect_element(:M, :fM, "faderM")
connect_element(:M, :f1, "multifaderM/1")
connect_element(:M, :f2, "multifaderM/2")
connect_element(:M, :f3, "multifaderM/3")
connect_element(:M, :f4, "multifaderM/4")










# -----------------------------------------------------------------------------#
# MUSIC code starts here...                                                    #
# -----------------------------------------------------------------------------#
# SET DEFAULT VALUES
t = sample_duration :bass_dnb_f
$c[:C][:r]  = 0.21 # -> results in ph_val = 4

# -----------------------------------------------------------------------------#
# (:A) GREEN GROUP
# (:t1) toggle_1
live_loop :bassdrum do
  on = ($c[:A][:t1]===1)
  x = $c[:A][:r]
  sleeptime = x>0.66 ? t/2 : x>0.33 ? t : t*2
  2.times do
    sample :bd_mehackit, amp: 4 if on
    sample :bd_haus, amp: 4, cutoff: 100 if on
    sleep sleeptime
  end
end
# (:t2) toggle_2
live_loop :snare do
  on = ($c[:A][:t2]===1)
  with_fx :gverb, damp: 1, spread: 0.5 do
    with_fx :compressor do
      sleep t
      sample :sn_generic, amp: 4, release: 0.2, hpf: 100 if on
      sleep t
    end
  end
end

# -----------------------------------------------------------------------------#
# (:B) RED GROUP
# (:t1) toggle_1
live_loop :hihats do
  on = ($c[:B][:t1]===1)
  x = $c[:B][:r]
  sleeptime = x>0.66 ? t/8 : x>0.33 ? t/4 : t/2
  2.times do
    sample :drum_cymbal_closed, amp: rrand(0.5, 1.2)+$c[:B][:f] if on
    sleep sleeptime
  end
end
# (:t2) toggle_2
live_loop :bass do
  on = ($c[:B][:t2]===1)
  vol = mapp($c[:B][:f], 4, 8)
  sample :bass_dnb_f, cutoff: 80.step(130,10).ring.tick, amp: vol if on
  sleep t*2
end

# -----------------------------------------------------------------------------#
# (:C) TURQUOISE GROUP
# (:t1) toggle_1
live_loop :melody_generated do
  use_synth :saw
  with_fx :echo do
    sleep t/2
    play scale(:f2, :minor, num_octaves: 4).choose,
      release: rrand(0.25, 0.5),
      attack:  0.5,
      amp:     1,
      cutoff:  30.step(40,5).tick if $c[:C][:t1]===1
    sleep [t, t*2, t*1.5].choose
  end
end
# (:t2) toggle_2
live_loop :spheric_beeping do
  use_synth :dsaw
  on     = ($c[:C][:t2]===1)
  vol    = mapp($c[:C][:f], 0.3, 0.8)
  x = $c[:C][:r]
  ph_val = x>0.8 ? 8 : x>0.6 ? 6 : x>0.4 ? 5 : x>0.2 ? 4 : 3
  with_fx :echo, phase: t/ph_val, mix: 1 do
    with_fx :gverb, mix: 0.3 do
      play :f4, release: 0.1, pan: -0.8, amp: vol, cutoff: rrand(80,120) if on
      play :f4+7, release: 0.1, pan: 0.8, amp: vol, cutoff: rrand(80,120) if on
      sleep t
    end
  end
end

# -----------------------------------------------------------------------------#
# (:D) YELLOW GROUP
# (:t1) toggle_1
live_loop :D_t1 do
  use_real_time
  x = sync "/osc*/toggleD_1"
  x = x.choose
  sample :glitch_robot1, amp: mapp($c[:D][:f], 3, 4)
end
# (:t2) toggle_2
live_loop :D_t2 do
  use_real_time
  x = sync "/osc*/toggleD_2"
  x = x.choose
  with_fx :band_eq, freq: 10, db: 1 do
    with_fx :bitcrusher, bits: 2 do
      play_pattern_timed scale(:f7, :aeolian), 0.1,
        release: 0.2, amp: mapp($c[:D][:f], 0.5, 1.5)
    end
  end
end


