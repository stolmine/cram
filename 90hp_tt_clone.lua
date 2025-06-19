--- template to speed up starting
-- you know how it go

function init()
    dex = ii.disting
    od = ii.er301
    txo = ii.txo
    txi = ii.txi
    jf = ii.jf
    -- plus whatever else!
end

seq = sequins.new{'+' , '+' , '^' , '+' , '$' , '/' , '*' , '+' , '/' , '*' , '$' , '^' , '+' , '*' , '*' , '*' , '/'}
parSeq = sequins.new{'+' , '+' , '^' , '*' , '/' , '/'}

function make_sound(char)
    if char == '+' then
        txo.tr_pulse(1)
    elseif char == '/' then
        txo.tr_pulse(2)
    elseif char == '*' then
        txo.tr_pulse(3)
    elseif char == '$' then
        txo.tr_pulse(4)
    elseif char == '^' then
        jf.tr
    end
end

m = metro.init()

    m.event = function()
        local char = seq()
        make_sound(char)
        print("make sound")
    end

    m.time = 0.125
    m.count = -1
    m:start()
    m:stop()

function start()
    m:start()
end

function stop()
    m:stop()
end