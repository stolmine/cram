--- a disting patch for macro osc 2
-- test this shit out

function init()
    ii.disting.algorithm(21)     -- Set algorithm to Macro Oscillator 2
    ii.disting.load_preset(5)
    print("Algorithm set to Macro Osc 2, preset 5 'i2c'")
    DEX = ii.disting
    OD = ii.er301
end

 seq = sequins.new{'+' , '-' , '#' , ';' , ' ' , '/' , '#' , ' ' , '+' , ']' , '+' , ';' , '-', '/' , '-' , '#'}
 seq2 = sequins.new{'-' ,'' , '.' , '+' , '' , '+' , '+' , '/', ';'}
 ERseq = sequins.new{'&' , '&' , ERseqnest , '&' , '&' , '&' , '&' , '^' , '&' , '*' , '&' }
 ERseqnest = sequins.new{'^' , '&' , '*' , '&' , '&' , '^'}
 ERratchet = sequins.new{ ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , ' ' , '&' }
 static_seq = sequins.new{2.5, 3.0, 0, -3, 1.89, 3.5, 4.0, 4.5, -3, -4.5, 2, -1.35, 2.95} -- Static voltages
--  static_seq = sequins.new{2.5, 3.0, 0, -3, 1.89, 3.5, 4.0, 4.5, -3, -4.5, 2, -1.35, 2.95} -- Static voltages (og record this!)

function make_sound(char)
    if char == '+' then 
        DEX.parameter( 7 , 2 )
        DEX.parameter( 16, 124 )
        DEX.parameter( 10 , 109 )
        DEX.voice_on(0, 8000)
        DEX.voice_pitch(0, 0)
        DEX.voice_off(0)
        print("voice_on, voice_pitch, voice_off")
    elseif char == '-' then
        DEX.parameter( 7 , 7 )
        DEX.parameter( 10 , 45 )
        DEX.voice_on(0, 8000)
        DEX.voice_pitch(0, 0.25)
        DEX.voice_off(0)
        print("voice_on, voice_pitch, voice_off")
    elseif char == '/' then
        DEX.parameter( 7 , 4 )
        DEX.parameter( 16 , 64 )
        DEX.parameter( 10 , 34)
        DEX.voice_on(0, 5000)
        DEX.voice_pitch(0, 0.58333)
        DEX.voice_off(0)
        print("voice_on, voice_pitch, voice_off")
    elseif char == ';' then
        DEX.parameter( 7, 5 )
        DEX.parameter( 11 , 13 )
        DEX.parameter( 16 , 12 )
        DEX.parameter( 10, 0 )
        DEX.voice_on(0, 9000)
        DEX.voice_pitch(0, 0.75)
        DEX.voice_off(0)
        print("is this that click?")
    elseif char == ']' then
        DEX.parameter( 11, 40 )
        DEX.parameter( 10 , 25 )
        DEX.parameter( 16 , 30 )
        DEX.parameter( 7 , 11 )
        DEX.voice_on(0, 5000)
        DEX.voice_pitch(0, 0.41667)
        DEX.voice_off(0)
    elseif char == '#' then
        DEX.parameter( 11, 23 )
        DEX.parameter( 10 , 23 )
        DEX.parameter( 16 , 23 )
    end
end

function ERtrig(char)
    if char == '&' then 
        if static_seq:peek() then
            local static_value = static_seq()  -- Get a static voltage from the sequence
            OD.cv(2, static_value)       -- Send static voltage to ER-301 on channel 2
            OD.tr_pulse(2, 1)             -- Trigger pulse
        end             
    elseif char == '^' then
        OD.cv_slew(3, 0)
        OD.cv(3, 0)
    elseif char == '*' then
        OD.cv_slew(3, 150)
        OD.cv(3, -5)
    end
end

function Ratch(char)
    --do something
    if char == '&' then
        if static_seq:peek() then
            local static_value = static_seq()  -- Get a static voltage from the sequence
            OD.cv(2, static_value)       -- Send static voltage to ER-301 on channel 2
            OD.tr_pulse(2, 1)             -- Trigger pulse
        end            
    end
end

-- Define the metro
m = metro.init()

    -- Configure the metro's event
    m.event = function()
        local char = seq()  -- Step through the sequence
        make_sound(char)    -- Call the function to trigger sound
        local char = ERseq()
        ERtrig(char)
        print("char:", char) -- Debug output
    end

    -- Set metro parameters and start
    m.time = 0.20 -- Set the interval (0.5 seconds here)
    m.count = -1   -- Infinite repeats
    m:start()      -- Start the metro
    m:stop()       -- and stop it

-- second metro
m2 = metro.init()

    --configure second metro's event
    m2.event = function()
        local char = ERratchet() -- defining a local variable as our sequins, calling a sequins automatically assigns the next step as char. This is somewhat like PR.NEXT in TT
        Ratch(char)
        print("Second Metro char:", char)
        local char = make_sound()
        make_sound(char)
        print("make_sound subdiv")
    end

    -- Set second metro parameters and start
    m2.time = 0.15 -- Set the interval (0.5 seconds here)
    m2.count = -1   -- Infinite repeats
    m2:start()      -- Start the metro
    m2:stop()       -- and stop it

-- global stop and start functions for our metros
function start()
    m:start()
    m2:start()
end

function stop()
    m:stop()
    m2:stop()
end