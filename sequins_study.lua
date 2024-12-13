--- sequins play
-- fuckin about

function init()
    ii.disting.algorithm(21)
end

seq2 = sequins.new{'-' , ' ', ' ' , '/', '|' , '.' , '-' , '/' , '+', ' ', ' ', '|', ' ', '.', '/'}
seq = sequins.new{'+' , ' ' , seq2 ,  '.' , '+' , '|' , '-'} -- A simple major scale pattern (in semitones)
static_seq = sequins.new{2.5, 3.0, 3.5, 4.0, 4.5, -3, -4.5, 2, -1.35, 2.95} -- Static voltages


function make_sound(char)
    if     char == '+' then 
        ii.jf.trigger( 6, 1 )
        ii.disting.voice_on( 1, 100 )
        ii.disting.parameter( 7 , 6 )
    elseif char == '|' then 
        ii.jf.trigger( 4, 1 )
        ii.disting.parameter( 7, 7 )
    elseif char == '.' then 
        ii.jf.trigger( 3, 1 )
        ii.disting.parameter( 7, 3 )
    elseif char == '/' then 
        static_value = static_seq()
        output[1].volts = static_seq()
        ii.disting.voice_on( 1, 100 )
    elseif char == '-' then 
        if static_seq:peek() then
            local static_value = static_seq()  -- Get a static voltage from the sequence
            ii.er301.cv(2, static_value)       -- Send static voltage to ER-301 on channel 2
            ii.er301.tr_pulse(2, 1)              -- Trigger pulse
        end
    end -- note that spaces are ignored!
  end

-- Define the metro
m = metro.init()

-- Configure the metro's event
m.event = function()
    local char = seq()  -- Step through the sequence
    make_sound(char)    -- Call the function to trigger sound
    print("char:", char, "static voltage:", static_value) -- Debug output
end

-- Set metro parameters and start
m.time = 0.025 -- Set the interval (0.5 seconds here)
m.count = -1   -- Infinite repeats
m:start()      -- Start the metro
m:stop()       -- and stop it
