--- Just working on this first sketch for the new 7u setup
-- a sequence for zaps to start

dex = ii.disting
od = ii.er301
txo = ii.txo
txi = ii.txi

local chars = {'+' , '-' , '/' , '#' , '@' , '*' , '^' , ';' , ':' , '%' , '$' , '?'}
local seq_length = 45

-- seq_tester = sequins.new{'+', '-'}

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

function make_sound(char)
    local char_map = {
        ['+'] = 0, ['-'] = 1, ['/'] = 2, ['#'] = 3, ['@'] = 4,
        ['*'] = 5, ['^'] = 6, [';'] = 7, [':'] = 8, ['%'] = 9,
        ['$'] = 10, ['?'] = 11
    }
    local cv_index = char_map[char]
    if cv_index then
        print("Sending CV index:", cv_index)
        ii.txo.tr_pulse(1) -- Trigger TXo output 1
        ii.txo.cv_n(1, cv_index) -- Set CV to the mapped value
    else
        print("Invalid character:", char)
    end
end

local current_index = 0
local counter = 0
local modulo_value = 12
local threshold = 12 -- trying to add a modulo controlled fill here, the plan is to switch banks momentarily when condition is met

-- function fill()
--     counter = counter + 1
--     while 


function seq_freq()
    -- local char = seq_tester() -- step through our sequins defined above

    current_index = current_index + 1 -- Increment index
    if current_index > seq_length then -- Reset if it exceeds the sequence length
        current_index = 1
    end

    local char = seq() -- step through our sequins defined above
    make_sound(char) -- call make_sound with the given index to char as arg
    print("triggering make_sound with input", char, "seq index", current_index)
end


function init()
    input[1]{ mode = 'change', direction = 'rising' }
    input[1]. change = seq_freq
    txo.tr_time(1, 5)
end


        