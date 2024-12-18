--- sequencing the filter bank on DEX
-- do your thing chat

function init()
    --do something
    dex = ii.disting
    od = ii.er301
    p = pameter
    dex.algorithm(9)
    dex.parameter(7,1)
end

-- attempting to generate a group of strings to pass to my sequins

-- function populate_sequins(chars, count)
--     local seq_table = {}
--     for i = 1, count do
--         -- add a random character from the given group, enclosed in single quotes
--         local char = "'" .. chars[math.random(#chars)] .. "'"
--         table.insert(seq_table, char)
--     end
--     return sequins.new(seq_table)
-- end

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

-- Define the parameter mappings
local param_mappings = {
    ['+'] = {
        [8] = math.random(35, 89),
        [13] = math.random(10, 115),
        [14] = math.random(10, 115),
        [15] = math.random(10, 115),
        [16] = math.random(10, 115),
        [17] = math.random(10, 115),
        [18] = math.random(10, 115),
        [19] = math.random(10, 115),
        [20] = math.random(10, 115),
        [29] = math.random(-40, 0),
        [30] = math.random(-40, 0),
        [31] = math.random(-40, 0),
        [32] = math.random(-40, 0),
        [33] = math.random(-40, 0),
        [34] = math.random(-40, 0),
        [35] = math.random(-40, 0),
        [36] = math.random(-40, 0)
    },
    ['-'] = {
        [8] = math.random(35, 89),
        [13] = math.random(10, 115),
        [14] = math.random(10, 115),
        [15] = math.random(10, 115),
        [16] = math.random(10, 115),
        [17] = math.random(10, 115),
        [18] = math.random(10, 115),
        [19] = math.random(10, 115),
        [20] = math.random(10, 115),
        [29] = math.random(-40, 0),
        [30] = math.random(-40, 0),
        [31] = math.random(-40, 0),
        [32] = math.random(-40, 0),
        [33] = math.random(-40, 0),
        [34] = math.random(-40, 0),
        [35] = math.random(-40, 0),
        [36] = math.random(-40, 0)
    },
    ['/'] = {
        [8] = math.random(35, 89),
        [13] = math.random(10, 115),
        [14] = math.random(10, 115),
        [15] = math.random(10, 115),
        [16] = math.random(10, 115),
        [17] = math.random(10, 115),
        [18] = math.random(10, 115),
        [19] = math.random(10, 115),
        [20] = math.random(10, 115),
        [29] = math.random(-40, 0),
        [30] = math.random(-40, 0),
        [31] = math.random(-40, 0),
        [32] = math.random(-40, 0),
        [33] = math.random(-40, 0),
        [34] = math.random(-40, 0),
        [35] = math.random(-40, 0),
        [36] = math.random(-40, 0)
    },
    ['^'] = {
        [8] = math.random(35, 89),
        [13] = math.random(10, 115),
        [14] = math.random(10, 115),
        [15] = math.random(10, 115),
        [16] = math.random(10, 115),
        [17] = math.random(10, 115),
        [18] = math.random(10, 115),
        [19] = math.random(10, 115),
        [20] = math.random(10, 115),
        [29] = math.random(-40, 0),
        [30] = math.random(-40, 0),
        [31] = math.random(-40, 0),
        [32] = math.random(-40, 0),
        [33] = math.random(-40, 0),
        [34] = math.random(-40, 0),
        [35] = math.random(-40, 0),
        [36] = math.random(-40, 0)
    }
}


-- function for assigning values to our chars

-- function handle_parameters(char, param_table)
--     if param_table[char] then
--         for param, value in pairs(param_table[char]) do
--             dex.p(param, value)
--         end
--     else
--         print("No parameters defined for:", char)
--     end
-- end

function handle_parameters(char)
    local mappings = param_mappings[char]
    if mappings then
        for param, value in pairs(mappings) do
            dex.parameter(param, value)
        end
    else
        print("No parameter mapping found for:", char)
    end
end

-- creat a new sequins programmatically

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