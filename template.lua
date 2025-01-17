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

function make_sound()
    -- do something
end

-- metro setup

m = metro.init()

    m.event = function()
        local char = seq()
        make_sound(char)
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