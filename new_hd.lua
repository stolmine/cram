-- Template to speed up starting
function init()
    dex = ii.disting
    od = ii.er301
    txo = ii.txo
    txi = ii.txi
    jf = ii.jf
    -- Plus whatever else!
    
    sequences = {
        beat = create_sequence(math.random(56,89)),
        env = create_sequence(math.random(36,70)),
        hat = create_sequence(math.random(45,90)),
        real_hat = create_sequence(math.random(23,104)),
        osc2_pitch = create_sequence(math.random(17,83)),
        mod_sequence_1 = create_sequence(math.random(20,97)),
    }

    steps = {
        beat = 1,
        env = 1,
        hat = 1,
        real_hat = 1,
        osc2_pitch = 1,
        mod_sequence_1 = 1,
    }

    -- TXo configurations
    txo.tr_time(1, 3)
    txo.tr_time(2, 1)
    txo.env_act(1, 1)
    txo.env_att(1, 0)
    txo.env_dec(1, 30)
    txo.cv(1, 5)

    -- debug sequence generation
    print("mod_sequence_1:", table.concat(sequences["mod_sequence_1"], ", "))

end

local beat_chars = {1, 0}

-- Generalized function to create a random sequence
function create_sequence(length)
    local sequence = {}
    for i = 1, length do
        table.insert(sequence, beat_chars[math.random(1, #beat_chars)])
    end
    return sequence
end

-- Generalized function to step through a sequence
function step_sequence(sequence_name, action)
    local seq = sequences[sequence_name]
    local current_step = steps[sequence_name]

    if seq[current_step] == 1 then
        action(1) -- Perform the action if the current step is 1
    elseif seq[current_step] == 0 then
        action(0) -- Optionally handle step 0
    end

    steps[sequence_name] = (current_step % #seq) + 1 -- Increment step
end

-- Define actions for each sequence
function beat_action(value)
    if value == 1 then
        txo.tr_pulse(1)
    end
end

function env_action(value)
    if value == 1 then
        txo.env_trig(1, 1)
    end
end

function hat_action(value)
    if value == 1 then
        txo.cv(2, 3)
    else
        txo.cv(2, 0)
    end
end

function real_hat_action(value)
    if value == 1 then
        txo.tr_time(2, math.random(1,3))
        txo.tr_pulse(2)
    else
        -- do nothing
    end
end

function osc2_pitch_action(value)
    if value == 1 then
        txo.cv(3, 2)
    else
        txo.cv(3,0)
    end
end

function mod_1_action(value)
    if value == 1 then
        txo.cv(4, math.random(0,500))
        print("sending mod to txo")
    else
        --do nothing
    end
end

-- Metro setup
m = metro.init()

m.event = function()
    step_sequence("beat", beat_action)
    step_sequence("env", env_action)
    step_sequence("hat", hat_action)
    step_sequence("real_hat", real_hat_action)
    step_sequence("osc2_pitch", osc2_pitch_action)
    print("calling mod sequence 1 in metro")
    step_sequence("mod_sequence_1", mod_1_action)
end

m.time = 0.125
m.count = -1

function start()
    m:start()
end

function stop()
    m:stop()
end
