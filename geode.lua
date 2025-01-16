--- trying out geode through crow
-- test more of this shit out

function init()
    od = ii.er301
    txo = ii.txo
    jf = ii.jf
    jf.mode(1)
end

make_sound()
end

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