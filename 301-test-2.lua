--- Trying to refactor for use with the 301
-- Going kinda funky rn

function init()
    dex = ii.disting
    od = ii.er301
    txo = ii.txo
    txi = ii.txi
    jf = ii.jf

    sequences = {
        beat = create_sequence(math.random(56, 95)), -- Binary sequence (0/1)
        env = create_sequence(math.random(36, 70)), -- Binary sequence (0/1)
        hat = create_sequence(math.random(13, 90)), -- Binary sequence (0/1)
        d_beat = create_sequence(math.random(19, 78)), -- Binary sequence (0/1)
        mod1 = create_mod_sequence(math.random(8, 21)), -- Continuous values
        mod2 = create_mod_sequence(math.random(29, 98)), -- Continuous values
    }

    steps = {
        beat = 1,
        env = 1,
        hat = 1,
        d_beat = 1,
        mod1 = 1,
        mod2 = 1,
    }

    -- TXo configurations
    txo.tr_time(1, 3)
    txo.tr_time(2, 1)
    txo.env_act(1, 1)
    txo.env_att(1, 0)
    txo.env_dec(1, 30)
    txo.cv(1, 5)

    print("Script initialized.")
end

local beat_chars = {1, 0}

-- Create a binary sequence
function create_sequence(length)
    local sequence = {}
    for i = 1, length do
        table.insert(sequence, beat_chars[math.random(1, #beat_chars)])
    end
    return sequence
end

-- Create a modulation sequence with random values between 0 and 500
function create_mod_sequence(length)
    local sequence = {}
    for i = 1, length do
        table.insert(sequence, (math.random(0, 500) * 0.01))
    end
    return sequence
end

-- Generalized function for stepping through sequences and passing values to actions
function step_sequence(sequence_name, action)
    local seq = sequences[sequence_name]
    local current_step = steps[sequence_name]

    local value = seq[current_step] -- Get the current value
    action(value) -- Pass the value to the appropriate action function

    steps[sequence_name] = (current_step % #seq) + 1 -- Advance to the next step
end

-- Define actions per sequence
function beat_action(value)
    if value == 1 then
        txo.tr_pulse(1)
        od.tr_pulse(1)
    end
end

function env_action(value)
    if value == 1 then
        txo.env_trig(1, 1)
    end
end

function hat_action(value)
    if value == 1 then
        od.tr_pulse(2)
        od.cv(2, math.random(0, 100) * 0.1)
    end
end

function mod1_action(value)
    -- For the modulation sequence, use the numeric value directly
    txo.cv(4, value)
    print("mod1_action called with value:", value)
end

local mod2_snh = 0 -- using a variable to run a sample and hold

function mod2_action(value)
    mod2_snh = mod2_snh + 1
    if mod2_snh == 31 then
        txo.cv(3, value)
        print("mod2_action called with value:", value)
    elseif mod2_snh > 31 then
        mod2_snh = 0
    end
end

function d_beat_action(value)
    if value == 1 then
        txo.tr_pulse(2)
    end
end

-- Metro setup
m = metro.init()

m.event = function()
    step_sequence("beat", beat_action)
    step_sequence("env", env_action)
    step_sequence("hat", hat_action)
    step_sequence("mod1", mod1_action)
    step_sequence("mod2", mod2_action)
    step_sequence("d_beat", d_beat_action)
    print("Metro tick")
end

m.time = 0.1
m.count = -1

function start()
    m:start()
end

function stop()
    m:stop()
end
