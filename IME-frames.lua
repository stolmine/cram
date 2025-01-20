--- template to speed up starting
-- you know how it go

function init()
    dex = ii.disting
    od = ii.er301
    txo = ii.txo
    txi = ii.txi
    jf = ii.jf
    -- plus whatever else!
    txo.tr_time(2, 3)
    txo.tr_time(3, 1)
end

output[1].action = pulse(0.05)
output[2].action = pulse(0.05)


function make_sound()
    -- do something
end

-- Define the pattern and a step counter
local pattern = {1, 0, 1, 1, 0, 0, 1, 2, 1, 0, 0, 1, 2}
local pattern2 = {0, 1, 0, 1, 1, 1, 0, 2, 2, 0, 1}
local step = 1
local step2 = 1

-- Function to advance the step sequencer
function advance()
    if pattern[step] == 1 then
        txo.tr_pulse(1) -- Trigger pulse
        txo.cv(1,1)
    elseif pattern[step] == 0 then
        txo.tr_pulse(2) -- trigger on off steps
        txo.cv(1,0)
        output[1]()
    elseif pattern[step] == 2 then
        txo.tr_pulse(3)
    end
    step = (step % #pattern) + 1 -- Move to the next step
end

function advance2()
    if pattern2[step2] == 0 then
        txo.tr_pulse(3)
        txo.cv(2,1)
    elseif pattern[step2] == 1 then
        txo.tr_pulse(2)
        txo.cv(3,2)
        output[2]()
    elseif pattern[step2] == 2 then
        txo.tr_pulse(4)
        txo.cv(2,0)
        txo.cv(3,0)
    end
    step2 = (step2 % #pattern2) + 1
end


-- metro setup

m = metro.init()

    m.event = function()
        -- local char = seq()
        -- make_sound(char)
        advance()
        advance2()
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