# Sonic Pi Test Composition
# by dcts

# Instructions
# - install sonic pi (https://sonic-pi.net/)
# - open programm and copy&past the code
# - compile (ALT + R)
# - change GLOBAL CONTROL PARAMETERS and compile again
# - all parameters can be 0 or 1.
# - aditionally, $playPiano can be 2 or 3 (different melody pattern)

# GLOBAL CONTROL PARAMETERS -------------
# Drums
$playHihat      = 1
$playBD         = 0
$playDrumInd    = 0
# melody
$playProphet    = 0
$playTranceBass = 0
$playPiano      = 0


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

