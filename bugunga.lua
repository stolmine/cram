--- a 301 sequencer
-- test this shit out
-- todo: add a counter to our metro which moves between sections (functions) 
-- we'll probably need a bigger case to do much more than we have
-- though sections could be done by mixing

function init()
    OD = ii.er301
    txo = ii.txo
    jf = ii.jf
end

local cycle_counter = 0
local counter = 0
local reverse_time = 0

local chars = {'+' , '!' , '>' , '-' , '/' , '#' , '@' , '*' , '^' , ';' , ':' , '%' , '$' , '?'}
local seq_length = 129

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
for i = 1, seq_length do
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
        ['*'] = 'pulse_3', -- Example for special behavior
        ['@'] = 'jf_pulse',
        ['-'] = 'delay_send',
        ['/'] = 'txo_1_eg',
        ['#'] = 'txo_2_pitch',
        ['!'] = 'pulse_cycle',
        ['>'] = 'reverse',
    }

    -- Check if the character is ignored
    if ignored_chars[char] == true then
        print("Ignoring character:", char)
        return -- Do nothing
    end

    -- not currently implement 301-side!

    if ignored_chars[char] == 'reverse' then
        local reverse_time = math.random(400,700)
        OD.tr_time(10, reverse_time)
        OD.tr_pulse(10)
        OD.tr_pulse(2)
        print("reverse!", char)
        return
    end

    if ignored_chars[char] == 'pulse_cycle' then
        cycle_counter = cycle_counter + 1
        if cycle_counter == 1 then
            OD.tr_pulse(5)
            print("pulsing sc.tr 5. cycle_counter:", cycle_counter)
        elseif cycle_counter == 2 then
            OD.tr_pulse(6)
            print("pulsing sc.tr 6. cycle_counter:", cycle_counter)
        elseif cycle_counter == 3 then
            OD.tr_pulse(7)
            print("pulsing sc.tr 7. cycle_counter:", cycle_counter)
            -- cycle_counter = 0
        elseif cycle_counter == 4 then
            OD.tr_pulse(8)
            print("pulsing sc.tr 8. cycle_counter:", cycle_counter)
            cycle_counter = 0
            return
        end
    end

    if ignored_chars[char] == 'txo_1_eg' then
        print("triggering txo EG 1:", char)
        txo.env_act(1, 1)
        txo.env_att(1, 700)
        txo.env_dec(1, 20)
        txo.env_trig(1,1)
        txo.cv(2,0.375)
        OD.cv(8,0.75)
        return
    end

    if ignored_chars[char] == 'delay_send' then
        print("sending drum to delay:", char)
        OD.tr_pulse(4)
        txo.cv(2,0)
        txo.env_att(1,700)
        txo.env_dec(1, 20)
        OD.cv(8,0.583)
        return
    end

    -- Handle special behavior
    if ignored_chars[char] == 'pulse_3' then
        print("pulsing sc.tr 3:", char)
        OD.tr_pulse(3) -- Example: Trigger a different output
        txo.cv(2,0.15)
        OD.cv(8,0.167)
        return
    end

    if ignored_chars[char] == 'jf_pulse' then
        print("reset all JF channels", char)
        jf.trigger(0,1)
        OD.tr_pulse(2)
        txo.env_att(1,500)
        txo.env_dec(1,50)
        OD.cv(8,0)
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

local fill_cv = 0
local delay_toss = 0

function update_counter()
    counter = counter + 1
    fill_cv = (math.random(-100,300)/100)
    if counter > 68 then
        OD.cv(9, fill_cv)
        OD.tr_pulse(2)
        delay_toss = math.random(0,1)
        if delay_toss == 1 then
            OD.tr_pulse(4)
            print("fill sent to delay!")
        end
        print("Fill!", fill_cv)
    else
        print("Still counting:", counter)
        OD.cv(9, 0)
    end
    if counter == 84 then
        counter = 0
        print("counter reset!")
    end
end

-- Define the metro
m = metro.init()

    -- Configure the metro's event
    m.event = function()
        update_counter()
        local char = seq()
        make_sound(char)
        print("char:", char) -- Debug output
    end

    -- Set metro parameters and start
    m.time = 0.125 -- Set the interval (0.5 seconds here)
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