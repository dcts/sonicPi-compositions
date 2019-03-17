# LiveCoding Session @ HeK
# SonicPi Hackathon 16.3.2019
# by ditori1976 and DCTS

sleeptime = (sample_duration :loop_safari)

live_loop :main do
  sample :loop_safari, beat_stretch: 1, amp: 2
  sample :loop_safari, amp: 2
  sleep sample_duration :loop_safari
end

live_loop :bass do
  sample :bd_mehackit
  sample :bd_haus, amp: 4, cutoff: 80
  sleep (sample_duration :loop_safari)/8
end

live_loop :hihats do
  sample :drum_cymbal_closed
  sleep (sample_duration :loop_safari)/32
end

live_loop :melody do
  use_synth :prophet
  play :d1, release: 10
  sleep (sample_duration :loop_safari)
end

live_loop :chords do
  use_synth :piano
  sleep (sample_duration :loop_safari)/4
end

