# LIVE CODING EXAMPLE
# coded @ HeK (Live Coding Hackathon)
# 17.3.2019
# by HexagonSix and DCTS



##| live_loop :et do
##|   use_synth :piano
##|   play scale(:d2, :minor).pick, release: 0.5,  amp: 1.2, cutoff: rrand(50, 130)
##|   sleep (sample_duration :loop_safari)/32
##| end

t = sample_duration :bass_dnb_f
##| with_fx :band_eq, freq: 10, db: 1 do
##|   with_fx :bitcrusher, bits: 2 do
##|     play_pattern_timed scale(:f7, :aeolian), 0.1, release: 0.2
##|   end
##| end

##| live_loop :random_melody do
##|   with_fx :ixi_techno, mix: 0.1 do
##|     with_fx :flanger do
##|       tp = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.75, 1, -0.25].choose
##|       use_synth :subpulse
##|       sleep t/3
##|       play :f4+tp, attack: 0.5, release: 0.25, amp: 0.1, decay: 0.2
##|       sleep t/3
##|       if (tp == 0)
##|         play :c5+tp, attack: 0.3, release: 0.75, amp: 0.15, decay: 0.1
##|       end
##|       sleep t/3
##|     end
##|   end
##| end

live_loop :bass do
  sample :bass_dnb_f, rpitch: 0, cutoff: 80.step(130, 10).tick, amp: 5
  sleep t*2
end

live_loop :prophet do
  use_synth :dsaw
  with_fx :echo, phase: t/4, mix: 0.2 do
    with_fx :gverb, mix: 0.3 do
      play :f4, release: 0.1, pan: -1, amp: 0.3, cutoff: 80.step(130, 10).tick, pitch: rrand(0, 0.25)
      play :f4, release: 0.1, pan: 1, amp: 0.3, cutoff: 110.step(70, 5).tick
      sleep t/2
    end
  end
end

live_loop :hihats do
  with_fx :hpf do
    sample :drum_cymbal_closed, amp: rrand(0.5, 1.2), hpf: 0
    sleep t/2
  end
end

live_loop :melody_generated do
  use_synth :saw
  with_fx :echo do
    sleep t/2
    play scale(:f2, :minor, num_octaves: 4).choose, \
      release: rrand(0.25, 0.5), attack: 0.5, amp: 1, cutoff: 30.step(40,5).tick
    sleep [t, t*2, t*1.5].choose
  end
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

