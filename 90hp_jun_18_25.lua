--- getting back into it
-- sequencing, that's all

function init()
    txo = ii.txo
    txi = ii.txi
    dex = ii.disting
    od = ii.er301
    jf = ii.jf

sequences = {
    main_voice = create_sequence(math.random(17,43))
}

steps = {
    main_voice = 1
}
end

local beat_chars = {1,0}

-- generalized function to create a random sequence, used in init
function create_sequence(length)
    local sequence = {}
    for i = 1, length do
        table.insert(sequence, beat_chars[math.random(1, #beat_chars)])
    end
    return sequence
end

-- generalized function to step through a sequence, used in metro
function step_sequence(sequence_name, action)
    local seq = sequences[sequence_name]
    local current_step = steps[sequence_name]

    if seq[current_step] == 1 then
        action(1) -- perform the action if the current step is 1
    elseif seq[current_step] == 0 then
        action(0) -- optionally handle a 0
    end

    steps[sequence_name] = (current_step % #seq) + 1 -- increment step
end

-- define actions for each sequence, called by step_sequence
function main_action(value)
    if value == 1 then
        txo.tr_pulse(1)
    end
end

-- Metro setup
m = metro.init()

m.event = function()
    step_sequence("main_voice", main_action)
end

m.time = 0.1
m.count = -1

function start()
    m:start()
end

function stop()
    m:stop()
end
