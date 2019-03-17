
##| live_loop :et do
##|   use_synth :piano
##|   play scale(:d2, :minor).pick, release: 0.5,  amp: 1.2, cutoff: rrand(50, 130)
##|   sleep (sample_duration :loop_safari)/32
##| end


t = sample_duration :bass_dnb_f
##| play_pattern_timed scale(:c3, :major), 0.125, release: 0.1
live_loop :test do
  with_fx :ixi_techno do
    use_synth :piano
    play scale(:f3, :aeolian).choose, release: 0.5, amp: 4
    sleep t/4
  end
end

live_loop :bass do
  sample :bass_dnb_f, rpitch: 0, cutoff: 80.step(130, 10).tick, amp: 5
  sleep t*2
end

live_loop :prophet do
  use_synth :dsaw
  with_fx :echo, phase: t/4 do
    ##| with_fx :gverb, mix: 1 do
    play :f4, release: 0.1, amp: 2, cutoff: 80.step(130, 10).tick
    sleep t/2
    ##| end
  end
end

live_loop :hihats do
  with_fx :hpf do
    sample :drum_cymbal_closed, amp: rrand(0.5, 1.4), hpf: 0
    sleep t/8
  end
end

live_loop :melody_generated do
  use_synth :mod_saw
  play scale(:f4, :aeolian, num_octaves: 1).choose, release: rrand(0.5, 1), amp: 2, cutoff: 90.step(110,5).tick
  sleep [t, t*2, t*1.5].choose
end

live_loop :bd do
  sample :bd_mehackit, amp: 4
  sample :bd_haus, amp: 4, cutoff: 100
  sleep t
end

live_loop :snare do
  with_fx :gverb, damp: 1, spread: 0.5 do
    with_fx :compressor do
      sleep t
      sample :sn_generic, amp: 4, release: 0.2, hpf: 100
      sleep t
    end
  end
end
