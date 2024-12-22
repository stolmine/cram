--- sequencing the filter bank on DEX
-- do your thing chat
-- call param_mappings = generate_param_mappings() in druid to randomize filterbank param sequence
-- call start() and stop() to run the sequence
-- todo: add trigger input for randomization and cv control over filter type

function init()
    dex = ii.disting
    od = ii.er301
    txo = ii.txo
    txi = ii.txi
    dex.algorithm(9)
    dex.parameter(8, 50) -- set resonance at default
    dex.parameter(9, -40) -- set dry gain to negative infinity
    dex.parameter(10, -10) -- set wet gain to -10db
    dex.parameter(7, 1) -- set filter mode to BPF

    local num = 21 -- set all gate params to 1 so we actually process audio when the script loads
    while num <= 28 do
        dex.parameter(num, 1)
        num = num + 1
    end

    print("test, all gates initialized")

    output[1].action = pulse() -- set output[1] to act as a generic pulse, we call this later via output[1]()
    output[2].action = pulse() -- ditto for output[2]
    output[3].action = pulse() -- and output 3

    -- Generate parameter mappings dynamically, call this in repl to do it live!
    param_mappings = generate_param_mappings()

    -- Debug: Print generated mappings (optional)
    for char, params in pairs(param_mappings) do
        print("Character:", char)
        for param, value in pairs(params) do
            print("Param:", param, "Value:", value)
        end
    end
end

-- example usage

local chars = {'+', '-', '/', '^', '&', '$', '#'}
local seq_length = 19

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

function generate_param_mappings()
    local chars = {'+', '-', '/', '^', '&', '$', '#'}
    local param_mappings = {}

    for _, char in ipairs(chars) do
        param_mappings[char] = {}
        for i = 8, 8 do
            param_mappings[char][i] = math.random(5, 50)
        end
        for i = 13, 20 do
            param_mappings[char][i] = math.random(10, 115)
        end
        for i = 29, 36 do
            param_mappings[char][i] = math.random(-40, -12)
        end
    end
    return param_mappings
end

function handle_parameters(char)
    if param_mappings[char] then
        for param, value in pairs(param_mappings[char]) do
            ii.disting.parameter(param, value)
        end
    else
        print("No parameter mapping found for:", char)
    end
end

function send_gates(char)
    print("send_gates received:", char, "Type:", type(char))
    print("--------------------------------------------")
    
    -- Remove any unwanted whitespace or formatting issues
    char = char:gsub("%s", "")
    
    -- Match the character and trigger gates
    if char == '+' then
        print("Sending pulse to TXo output 1")
        txo.tr_pulse(1)
    elseif char == '$' then
        print("Sending pulse to TXo output 2")
        txo.tr_pulse(2)
    elseif char == '/' then
        print("Sending pulse to TXo output 3")
        txo.tr_pulse(3)
    elseif char == '-' then
        print("char undefined:", char)
    elseif char == '^' then
        print("char undefined:", char)
    elseif char == '&' then
        print("char undefined:", char)
    elseif char == '#' then
        print("char undefined:", char)
    else
        print("No matching gate condition for char:", char)
    end
    print("--------------------------------------------")
end


-- Function to handle parameters
function handle_parameters(char)
    local mappings = param_mappings[char]
    if mappings then
        for param, value in pairs(mappings) do
            ii.disting.parameter(param, value)
        end
    else
        print("No parameter mapping found for:", char)
    end
end

-- metros

m = metro.init()

    -- configure metros to call our relevant functions per tick
    m.event = function()
        print("Debug: seq current value:", seq())
        local char = seq()
        print("Processing char from seq:", char, "Type:", type(char))
        if char == nil then
            print("Error: char is nil. seq may not be returning valid values.")
            return
        end
        handle_parameters(char)
        send_gates(char)
        output[1]()
    end

    m.time = 0.15
    m.count = -1
    m:start()      -- Start the metro
    m:stop()       -- and stop it'

m2 = metro.init()

    -- configure metros to call our relevant functions per tick
    m2.event = function()
        output[2]()
    end

    m2.time = 0.075
    m2.count = -1
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