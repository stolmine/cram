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
    od.tr_time(1, 500)

    local num = 21 -- set all gate params to 1 so we actually process audio when the script loads
    while num <= 28 do
        dex.parameter(num, 1)
        num = num + 1
    end

    print("test, all gates initialized")

    output[1].action = pulse() -- set output[1] to act as a generic pulse, we call this later via output[1]()
    output[2].action = pulse() -- ditto for output[2]
    output[3].action = pulse() -- and output 3
    output[4].action = pulse()

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


function sleep(n)
    os.execute("sleep " .. tonumber(n))
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

function send_gates(char) -- trying to send gates to txo, works manually but not when calling as function inside metro
    if char == '+' then
        txo.tr_pulse(1)
    elseif char == '-' then
        txo.tr_pulse(2)
    elseif char == '/' then
        txo.tr_pulse(3)
    elseif char == '$' then
        txo.tr_pulse(4)
    end
end

function additive(char) -- adding in harmonic elements from the 301
    print("additive function triggered with char:", char)
    if char == '^' then
        -- od.cv(1, 0)
        -- sleep(0.01)
        od.tr_pulse(1)
        print("additive trig")
    elseif char == '+' then
        od.tr_pulse(1)
    elseif char == '$' then
        od.tr_pulse(1)
    end
end

function od_param(char) -- adding in harmonic elements from the 301
    print("od_param function triggered with char:", char)
    if char == '+' then
        od.cv(1, 0)
        od.cv(2, 0)
        od.tr_time(1, 100)
    elseif char == '-' then
        od.cv_slew(1, 500)
        od.cv(1, 0.58333)
        od.cv(2, 2.5)
        od.tr_time(1, 500)
    elseif char == '/' then
        od.cv_slew(1, 0)
        od.cv(1, -0.5)
        od.cv(2, 4.5)
        od.tr_time(250)
    elseif char == '$' then
        od.cv(1, 1)
        od.cv(2, 6)
        od.tr_time(1, 600)
    elseif char == '^' then
        pd.cv(1, -1)
        od.cv(2, 0)
    end
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

-- metros

m = metro.init()

    -- main seq
    m.event = function()
        local char = seq()
        print("Debug: seq current value:", char)
        print("Processing char from seq:", char, "Type:", type(char))
        if char == nil then
            print("Error: char is nil. seq may not be returning valid values.")
            return
        end
        handle_parameters(char)
        output[1]()
    end

    m.time = 0.15 -- og 0.15
    m.count = -1
    m:start()      -- Start the metro
    m:stop()       -- and stop it'

m2 = metro.init()

    -- cdouble time hat triggers
    m2.event = function()
        output[2]()
    end

    m2.time = 0.075 -- og 0.075
    m2.count = -1
    m2:start()      -- Start the metro
    m2:stop()       -- and stop it

m3 = metro.init()

    -- gates to txo
    m3.event = function()
        local char = seq()
        send_gates(char)
    end

    m3.time = 0.45
    m3.count = -1
    m3:start()      -- Start the metro
    m3:stop()       -- and stop it

m4 = metro.init()

    m4.event = function()
        local char = seq()
        print("m4 triggered with seq value:", char)
        additive(char)
    end

    m4.time = 0.15
    m4.count = -1
    m4:start()
    m4:stop()

m5 = metro.init()

    m5.event = function()
        local char = seq()
        print("m5 triggered with seq value:", char)
        od_param(char)
    end

    m5.time = 0.15
    m5.count = -1
    m5:start()
    m5:stop()

-- global stop and start functions for our metros
function start()
    m:start()
    m2:start()
    m3:start() 
    m4:start()
    m5:start()
end

function stop()
    m:stop()
    m2:stop()
    m3:stop()
    m4:stop()
    m5:stop()
end