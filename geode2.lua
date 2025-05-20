--- trying out geode through crow
-- test more of this shit out

function init()
    od = ii.er301
    txo = ii.txo
    jf = ii.jf
    jf.mode(1)
    jf.quantize(16)

    setup_char_map()
end

function quant(num)
    jf.quantize(num)
end

local chars = {'+' , '-' , '*' , '&' , '^' , '%' , '$' , '#'}
local seq_length = 21
local char_map = {}

function setup_char_map()
    for _, char in ipairs(chars) do
        if char == '$' then
            char_map[char] = "trigger"
        elseif char == '#' then
            char_map[char] = "ignore"
        else
            char_map[char] = {
                note = math.random(0, 16),
                velocity = math.random(0, 16)
            }
        end
    end

    -- Debug: print mappings
    print("Character to note/velocity mapping:")
    for k, v in pairs(char_map) do
        if type(v) == "table" then
            print(k, "->", "note:", v.note, "velocity:", v.velocity)
        else
            print(k, "->", v)
        end
    end
end

function populate_sequins(chars, count)
    local seq_table = {}
    for i = 1, count do
        local char = chars[math.random(#chars)]
        table.insert(seq_table, char)
    end
    return sequins.new(seq_table)
end

seq = populate_sequins(chars, seq_length)

function make_sound(char)
    local mapped = char_map[char]
    if mapped == "ignore" then
        return
    elseif mapped == "trigger" then
        jf.trigger(1, 1)
        txo.cv(1,2.5)
    elseif type(mapped) == "table" then
        jf.play_note(mapped.note, mapped.velocity)
        txo.cv(1,0)
    end
end

m = metro.init()
m.event = function()
    jf.tick(16)
    local char = seq()
    make_sound(char)
end

m.time = 0.125
m.count = -1
m:stop()

function start()
    m:start()
end

function stop()
    m:stop()
end
