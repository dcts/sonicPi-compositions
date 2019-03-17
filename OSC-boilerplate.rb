# TouchOSC
# you can insert your own samples (line 18-29)

def setButton(button, mySample, doublePress=0)
  live_loop button.to_sym do
    use_real_time
    x = sync "/osc*/2/#{button}"
    x = x.choose
    sample mySample if doublePress===1
    sample mySample if doublePress===0 && x===1
  end
end

setButton("push1",  :mehackit_phone1)
setButton("push2",  :bd_mehackit)
setButton("push3",  :bd_haus)
setButton("push4",  :drum_cymbal_closed)
setButton("push5",  :bd_mehackit)
setButton("push6",  :bd_mehackit)
setButton("push7",  :bd_mehackit)
setButton("push8",  :bd_mehackit)
setButton("push9",  :bd_mehackit)
setButton("push10", :bd_mehackit)
setButton("push11", :bd_mehackit)
setButton("push12", :bd_mehackit)
setButton("push13", :bd_mehackit)
setButton("push14", :bd_mehackit)
setButton("push15", :bd_mehackit)
setButton("push16", :bd_mehackit)
