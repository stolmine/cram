--- sample and hold
-- in1: sampling clock
-- out1: random sample

function init()
    input[1].mode('change',1.0,0.1,'rising')
end

function count_event(count)
    --do something cool :0
    ii.jf.trigger( 6, 1)
end

mycounter = metro.init{ event = count_event
, time = 0.1
, count = -1 -- nb: -1 is endless
}

mycounter:start()
mycounter:stop()

s = sequins

seq = s{1,2,3}
_ = seq()

