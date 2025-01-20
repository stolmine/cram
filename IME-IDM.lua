--- template to speed up starting
-- you know how it go

function init()
    dex = ii.disting
    od = ii.er301
    txo = ii.txo
    txi = ii.txi
    jf = ii.jf
    txo.env_act(1,1)
    txo.env_att(1,0)
    txo.env_dec(1,30)
    txo.cv(1,5)
    -- plus whatever else!
end

local pattern = {1,1,3,1,0,3,3,0,1,2,3,1,3,0,1,1,3,2,0,1,2,0,3}
local step = 1



function step1()
    txo.env_dec(1,30)
    txo.env_trig(1,1)
    txo.cv(2,0)
    txo.cv(3,0)
end 

function step2()
    txo.cv(2,0.5)
    txo.env_dec(1, 100)
    txo.env_trig(1,1)
    txo.env_att(1,0)
    txo.tr_pulse(3)
end

function step3()
    txo.cv(2,0)
    txo.env_att(1,50)
    txo.tr_pulse(1)
    txo.tr_pulse(2)
end

function advance()
    if pattern[step] == 1 then
        step1()
    elseif pattern[step] == 0 then
        step2()
    elseif pattern[step] == 2 then
        step3()
    elseif pattern[step] == 3 then
        txo.cv(3,5)
    end
    step = (step % #pattern) + 1
end

function make_sound()
    -- do something
end

-- metro setup

local fill_counter = 0

m = metro.init()

    m.event = function()
        advance()
        fill_counter = fill_counter + 1
        if fill_counter > 67 then
            m.time = 0.15
            txo.cv(2,1)
        end
        if fill_counter > 100 then
            fill_counter = 0
            m.time = 0.1
        end
    end

    m.time = 0.10
    m.count = -1
    m:start()
    m:stop()

function start()
    m:start()
end

function stop()
    m:stop()
end