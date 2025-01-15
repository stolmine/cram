--- a 301 sequencer
-- test this shit out

function init()
    OD = ii.er301
    txo = ii.txo
    jf = ii.jf
end

local chars = {'+' , '-' , '/' , '#' , '@' , '*' , '^' , ';' , ':' , '%' , '$' , '?'}
local seq_length = 45

function populate_sequins(chars, count)
    local seq_table = {}
    for i = 1, count do
        local char = chars[math.random(#chars)]
        print("Adding char to seq_table:", char) -- Debug print
        table.insert(seq_table, char)
    end
    print("Final seq_table:", table.concat(seq_table, ", ")) -- Debug inside function
    return sequins.new(seq_table)
end

-- create a new sequins programmatically

seq = populate_sequins(chars, seq_length)

print("generated sequins:", table.concat(seq, ", "))

print("Debug: Cycling through seq:")
for i = 1, #chars do
    print(seq())
end

-- here we need to produce our function which assigns values to our chars

function make_sound(char)
    -- Table to store assigned values for characters
    local char_map = {}

    -- Characters to ignore or assign special behavior
    local ignored_chars = {
        ['#'] = true, -- Ignore this character (do nothing)
        ['%'] = true,
        ['*'] = 'special', -- Example for special behavior
    }

    -- Check if the character is ignored
    if ignored_chars[char] == true then
        print("Ignoring character:", char)
        return -- Do nothing
    end

    -- Handle special behavior
    if ignored_chars[char] == 'special' then
        print("Special behavior for character:", char)
        OD.tr_pulse(3) -- Example: Trigger a different output
        return
    end

    -- If the character doesn't already have a value assigned, assign a random float
    if not char_map[char] then
        char_map[char] = math.random(-500, 500) / 100 -- Generates a random number between -5 and 5 with two decimal places
    end

    -- Retrieve the value and proceed
    local cv_value = char_map[char]
    if cv_value then
        print("Sending CV value:", cv_value)
        OD.tr_pulse(2) -- Trigger TXo output 2
        OD.cv(2, cv_value) -- Set CV to the mapped value
    else
        print("Invalid character:", char)
    end
end



-- Define the metro
m = metro.init()

    -- Configure the metro's event
    m.event = function()
        local char = seq()
        make_sound(char)
        print("char:", char) -- Debug output
    end

    -- Set metro parameters and start
    m.time = 0.20 -- Set the interval (0.5 seconds here)
    m.count = -1   -- Infinite repeats
    m:start()      -- Start the metro
    m:stop()       -- and stop it

-- global stop and start functions for our metros
function start()
    m:start()
end

function stop()
    m:stop()
end