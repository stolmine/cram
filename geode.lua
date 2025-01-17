--- trying out geode through crow
-- test more of this shit out

function init()
    od = ii.er301
    txo = ii.txo
    jf = ii.jf
    jf.mode(1)
    jf.quantize(16)
end

function quant(num)
    jf.quantize(num)
end

local chars = {'+' , '-' , '*' , '&' , '^' , '%' , '$' , '#'}
local seq_length = 57

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

function make_sound(char)
    local char_map = {}

    local ignored_chars = {
        ['#'] = true,
    }

    if ignored_chars[char] == true then
        return -- do nothing
    end

    if char == '+' then
        jf.play_note(9,2)
    elseif char == '-' then
        jf.play_note(11,3)
    elseif char == '*' then
        jf.play_note(3,3)
    elseif char == '&' then
        jf.play_note(1, 4)
    elseif char == '^' then
        jf.play_note(2, 7)
    elseif char == '%' then
        jf.play_note(7,5)
    elseif char == '$' then
        jf.trigger(0,1)
    end
-- do something
end

m = metro.init()

    m.event = function()
        jf.tick(16)
        local char = seq()
        make_sound(char)
    end

    m.time = 0.125
    m.count = -1
    m:start()
    m:stop()

function start()
    m:start()
end

function stop()
    m:stop()
end