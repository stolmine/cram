--- disting ex tester
-- test this shit out

function init()
    ii.disting.algorithm(3)     -- Set algorithm to Macro Oscillator 2
    print("Algorithm set to SD multisample")
    ii.disting.parameter(7, 51)
    print("Folder set to soft piano")
    -- ii.er301.cv_slew(3, 600)
end

 seq = sequins.new{'+' , '-' , ' ' , ';' , ' ' , '/' , '#' , ' ' , '+' , ']' , '+' , ';' , '-', '/' , '-' , '#'}
 seq2 = sequins.new{'-' ,'' , '.' , '+' , '' , '+' , '+' , '/', ';'}

 ERseq = sequins.new{'&' , '&' , ERseqnest , '&' , '&' , '&' , '&' , '^' , '&' , '*' , '&' }
 ERseqnest = sequins.new{'^' , '&' , '*' , '&' , '&' , '^'}
 static_seq = sequins.new{2.5, 3.0, 0, -3, 1.89, 3.5, 4.0, 4.5, -3, -4.5, 2, -1.35, 2.95} -- Static voltages

function make_sound(char)
    if char == '+' then 
        ii.disting.voice_pitch(1, 3.58333)
        print("Disting: Sent voice_pitch(1, -10000)")
        ii.disting.voice_on(1, 15000)
        print("Disting: Sent voice_on(1, 32767)")
    elseif char == '-' then
        ii.disting.voice_pitch(2, 2.33333)
        ii.disting.voice_on(2, 20000)
    elseif char == '/' then
        ii.disting.voice_pitch(3, 1.91667)
        ii.disting.voice_on(3, 9500)
    elseif char == ';' then
        ii.disting.voice_pitch(4, 2.75)
        ii.disting.voice_on(3, 17000)
    elseif char == ']' then
        ii.disting.voice_pitch(5, 0.33333)
        ii.disting.voice_on(5, 21000)
        ii.disting.voice_pitch(6, 1.5)
        ii.disting.voice_on(6, 14000)
    elseif char == '#' then
        ii.disting.voice_pitch(7, 1.75)
        ii.disting.voice_on(7, 24000)
        ii.disting.voice_pitch(8, 3.5)
        ii.disting.voice_on(8, 15000)
    end
end

function ERtrig(char)
    if char == '&' then 
        if static_seq:peek() then
            local static_value = static_seq()  -- Get a static voltage from the sequence
            ii.er301.cv(2, static_value)       -- Send static voltage to ER-301 on channel 2
            ii.er301.tr_pulse(2, 1)             -- Trigger pulse
        end             
    elseif char == '^' then
        ii.er301.cv_slew(3, 0)
        ii.er301.cv(3, 0)
    elseif char == '*' then
        ii.er301.cv_slew(3, 150)
        ii.er301.cv(3, -5)
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
m.time = 0.15 -- Set the interval (0.5 seconds here)
m.count = -1   -- Infinite repeats
m:start()      -- Start the metro
m:stop()       -- and stop it
