--- a disting patch for macro osc 2
-- test this shit out

function init()
    DEX = ii.disting
    OD = ii.er301
end

 seq = sequins.new{'+' , '-' , '#' , ';' , ' ' , '/' , '#' , ' ' , '+' , ']' , '+' , ';' , '-', '/' , '-' , '#'}
--  static_seq = sequins.new{2.5, 3.0, 0, -3, 1.89, 3.5, 4.0, 4.5, -3, -4.5, 2, -1.35, 2.95} -- Static voltages (og record this!)

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

-- Define the metro
m = metro.init()

    -- Configure the metro's event
    m.event = function()
        local char = ERseq()
        ERtrig(char)
        print("char:", char) -- Debug output
    end

    -- Set metro parameters and start
    m.time = 0.20 -- Set the interval (0.5 seconds here)
    m.count = -1   -- Infinite repeats
    m:start()      -- Start the metro
    m:stop()       -- and stop it

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