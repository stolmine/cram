--- sequins play
-- fuckin about
seq2 = sequins.new{'-' , ' ', ' ' , '|' , '.' , '-'}
seq = sequins.new{'+' , ' ' , seq2 ,  '.' , '+' , '|' , '-'} -- A simple major scale pattern (in semitones)


function make_sound(char)
    if     char == '+' then ii.jf.trigger( 6, 1 )
    elseif char == '|' then ii.jf.trigger( 4, 1 )
    elseif char == '.' then ii.jf.trigger( 3, 1 )
    elseif char == '-' then 
        ii.er301.cv( 1, rand ) -- use the updated value for rand
        ii.er301.tr_pulse( 2, 1 )
    end -- note that spaces are ignored!
  end

-- Define the metro
m = metro.init()

-- Configure the metro's event
m.event = function()
    rand = math.random() * 10 - 5
    local char = seq()  -- Step through the sequence
    make_sound(char)    -- Call the function to trigger sound
    print("char:", char, "rand:", rand) -- Debug output
end

-- Set metro parameters and start
m.time = 0.025                          -- Set the interval (0.5 seconds here)
m.count = -1                          -- Infinite repeats
m:start()                             -- Start the metro
m:stop() -- and stop it
