--- doing zaps with plaits
-- something to consider doing with... zaps

function init()
    ii.disting.algorithm(21) -- macro osc 2
    print("Algorithm set to Macro Osc 2")
    DEX = ii.disting
    OD = ii.er301
end

seq = sequins.new{'+' , '+' , '^' , '+' , '$' , '/' , '*' , '+' , '/' , '*' , '$' , '^' , '+' , '*' , '*' , '*' , '/'}
parSeq = sequins.new{'+' , '+' , '^' , '*' , '/' , '/'}

function make_sound(char)
    if char == '+' then
        DEX.voice_on(0, 8000)
        DEX.voice_pitch(0, -1.83333)
        DEX.voice_off(0)
        DEX.parameter(11, 89)
        DEX.parameter(7, 3)
        -- DEX.algorithm(21)
    elseif char == '/' then
        DEX.voice_on(0, 8000)
        DEX.voice_pitch(0, -1.5)
        DEX.voice_off(0)
        DEX.parameter(7, 2)
        DEX.parameter(10,100)
        DEX.parameter(11,64)
        DEX.load_preset(5)
    elseif char == '*' then
        DEX.voice_on(0, 8000)
        DEX.voice_pitch(0, -1.83333)
        DEX.voice_off(0)
        DEX.parameter(7, 5)
        DEX.parameter(10,64)
    elseif char == '$' then
        DEX.voice_on(0, 8000)
        DEX.voice_pitch(0, -1.5)
        DEX.voice_off(0)
        DEX.parameter(7, 10)
        DEX.parameter(12, 40)
        -- DEX.algorithm(19)
    elseif char == '^' then
        DEX.voice_on(0, 8000)
        DEX.voice_pitch(0, 1)
        DEX.voice_off(0)
        DEX.parameter(7, 6)
        DEX.load_preset(6)   
        DEX.parameter(12, 64)
    end
end

function parShift(char)
    if char == '+' then
        DEX.parameter(14, 64)
        DEX.parameter(15, 23)
        DEX.parameter(17, 34)
        DEX.parameter(16, 124)
    elseif char == '^' then
        DEX.parameter(14, 23)
        DEX.parameter(15, 76)
        DEX.parameter(17, 90)
        DEX.parameter(16, 30)
    elseif char == '*' then
        DEX.parameter(14, 9)
        DEX.parameter(15, 120)
        DEX.parameter(17, 18)
        DEX.parameter(16, 79)
    elseif char == '/' then
        DEX.parameter(14, 56)
        DEX.parameter(15, 28)
        DEX.parameter(17, 81)
        DEX.parameter(16, 97)
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

m2 = metro.init()

    m2.event = function()
        local char = parSeq()
        parShift(char)
        print("change par")
    end

    m2.time = 0.2
    m2.count = -1
    m2:start()
    m2:stop()

function start()
    m:start()
    m2:start()
end

function stop()
    m2:start()
    m2:stop()
end