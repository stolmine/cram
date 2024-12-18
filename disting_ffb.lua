--- sequencing the filter bank on DEX
-- do your thing chat
-- call param_mappings = generate_param_mappings() in druid to randomize filterbank param sequence
-- call start() and stop() to run the sequence
-- todo: add trigger input for randomization and cv control over filter type

function init()
    dex = ii.disting
    od = ii.er301
    dex.parameter(8, 50) -- set resonance at default
    dex.parameter(9, -40) -- set dry gain to negative infinity
    dex.parameter(10, -10) -- set wet gain to -10db
    dex.parameter(7, 1) -- set filter mode to BPF

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

function populate_sequins(chars, count)
    local seq_table = {}
    for i = 1, count do
        local char = chars[math.random(#chars)] -- Use raw characters
        table.insert(seq_table, char)
    end
    return sequins.new(seq_table)
end


-- example usage

local chars = {'+', '-', '/', '^'}
local seq_length = 19

function generate_param_mappings()
    local chars = {'+', '-', '/', '^'}
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

-- create a new sequins programmatically

seq = populate_sequins(chars, seq_length)

print("generated sequins:", table.concat(seq, ", "))

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
        local char = seq()
        print("Processing char:", char)
        handle_parameters(char) -- call the param handling function
    end

    m.time = 0.15
    m.count = -1
    m:start()      -- Start the metro
    m:stop()       -- and stop it

-- global stop and start functions for our metros
function start()
    m:start()
    -- m2:start()
end

function stop()
    m:stop()
    -- m2:stop()
end