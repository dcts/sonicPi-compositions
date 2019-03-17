# Sonic Pi Test Composition WITH OSC
# by dcts

# Instructions
# - install sonic pi (https://sonic-pi.net/)
# - install TouchOSC on your phone (https://itunes.apple.com/ch/app/touchosc/id288120394?mt=8)
# - open sonicPi and go to preferences -> I/O -> activate OSC Server and activate recieving OSC
# - open touchOSC and go to settings -> paste IP adress and Port
# - IMPORTANT: be sure that phone and computer are connected to the same wifi network
# - in touch OSC use the Layout "Automat5"
# - compile (ALT + R) -> only the hihat should be played
# - press buttons to control global parameters on your phone

# GLOBAL CONTROL PARAMETERS -------------
# Drums
$playHihat      = 1
$playBD         = 0
$playDrumInd    = 0
# melody
$playProphet    = 0
$playTranceBass = 0
$playPiano      = 0


live_loop :t1 do
  use_real_time
  $playHihat = sync "/osc*/toggleA_1"
  $playHihat = $playHihat.choose
end
live_loop :t2 do
  use_real_time
  $playBD = sync "/osc*/toggleA_2"
  $playBD = $playBD.choose
end
live_loop :t3 do
  use_real_time
  $playDrumInd = sync "/osc*/toggleB_1"
  $playDrumInd = $playDrumInd.choose
end
live_loop :t4 do
  use_real_time
  $playProphet = sync "/osc*/toggleB_2"
  $playProphet = $playProphet.choose
end
live_loop :t5 do
  use_real_time
  $playTranceBass = sync "/osc*/toggleC_1"
  $playTranceBass = $playTranceBass.choose
end
live_loop :t6 do
  use_real_time
  $playPiano = sync "/osc*/oggleC_2"
  $playPiano = $playPiano.choose
end


# BEGIN LOOPS ---------------------------
live_loop :prophet do
  use_synth :prophet
  play :c2, release: 10 if $playProphet===1
  play :c1, release: 10 if $playProphet===1
  sleep 4
end

live_loop :bd do
  sample :loop_industrial, beat_stretch: 1 if $playDrumInd===1
  2.times do
    sample :bd_haus, amp: 4, cutoff: 80 if $playBD===1
    sleep 0.5
  end
end

live_loop :hihats do
  sample :drum_cymbal_closed, amp: 1 if $playHihat===1
  sleep 0.125
  7.times do
    sample :drum_cymbal_closed, amp: rrand(0.3, 0.8) if $playHihat===1
    sleep 0.125
  end
end

live_loop :trance_bass do
  ##| sample :bass_trance_c, beat_stretch: 2, cutoff: rrand(70, 130)
  sample :bass_hit_c, amp: 2, cutoff: rrand(70, 130) if $playTranceBass===1
  sleep 0.25
end

live_loop :melody do
  with_fx :echo, phase: 0.375, decay: 4 do
    with_fx :gverb, release: 10 do
      if $playPiano>0
        use_synth :piano
        play :c5, amp: 0.6
        sleep 16*0.125
        play :c5-2, amp: 0.6, pan: -1 if $playPiano>2
        sleep 7*0.125
        play :c5+1, amp: 0.6, pan: 1 if $playPiano>1
        sleep 9*0.125
      else
        sleep 32*0.125
      end
    end
  end
end
