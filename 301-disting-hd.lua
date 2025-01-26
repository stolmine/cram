-- Template to speed up starting
function init()
    dex = ii.disting
    od = ii.er301
    txo = ii.txo
    txi = ii.txi
    jf = ii.jf
    -- Plus whatever else!

    sequences = {
        beat = create_sequence(math.random(56, 89)),
        env = create_sequence(math.random(36, 70)),
        hat = create_sequence(math.random(45, 90)),
        real_hat = create_sequence(math.random(23, 104)),
        osc2_pitch = create_sequence(math.random(17, 83)),
    }

    durations = {
        beat = create_durations(math.random(56, 89)),
        env = create_durations(math.random(36, 70)),
        hat = create_durations(math.random(45, 90)),
        real_hat = create_durations(math.random(23, 104)),
        osc2_pitch = create_durations(math.random(17, 83)),
    }

    steps = {
        beat = 1,
        env = 1,
        hat = 1,
        real_hat = 1,
        osc2_pitch = 1,
    }

    -- TXo configurations
    txo.tr_time(1, 3)
    txo.tr_time(2, 1)
    txo.env_act(1, 1)
    txo.env_att(1, 0)
    txo.env_dec(1, 30)
    txo.cv(1, 5)

    -- Start the metro
    metro_base_time = 0.75 -- Base duration for the metro (16th note)
    m = metro.init(handle_step, metro_base_time, -1)
    m:start()
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

-- Generalized function to create random durations for steps
function create_durations(length)
    local durations = {}
    for i = 1, length do
        table.insert(durations, math.random(1, 4) * 0.125) -- Random durations as multiples of 16th notes
    end
    return durations
end

-- Generalized function to step through a sequence with durations
function step_sequence(sequence_name, action)
    local seq = sequences[sequence_name]
    local dur = durations[sequence_name]
    local current_step = steps[sequence_name]

    -- Perform the action if the current step matches the sequence value
    if seq[current_step] == 1 then
        action(1)
    elseif seq[current_step] == 0 then
        action(0)
    end

    -- Advance to the next step
    steps[sequence_name] = (current_step % #seq) + 1

    -- Return the duration of the current step
    return dur[current_step]
end

-- Define actions for each sequence
function beat_action(value)
    if value == 1 then
        txo.tr_pulse(1)
        od.tr_pulse(1)
    end
end

function env_action(value)
    if value == 1 then
        txo.env_trig(1, 1)
        od.tr_pulse(2)
        od.cv(1, (math.random(0,100) * 0.1))
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
        txo.tr_time(2, math.random(1, 3))
        txo.tr_pulse(2)
        od.tr_pulse(3)
        od.cv(2, math.random(0,100) * 0.1)
    end
end

function osc2_pitch_action(value)
    if value == 1 then
        txo.cv(3, 2)
    else
        txo.cv(3, 0)
    end
end

-- Handle metro step events
function handle_step()
    local durations = {}

    -- Call each sequence and collect its duration
    table.insert(durations, step_sequence("beat", beat_action))
    table.insert(durations, step_sequence("env", env_action))
    table.insert(durations, step_sequence("hat", hat_action))
    table.insert(durations, step_sequence("real_hat", real_hat_action))
    table.insert(durations, step_sequence("osc2_pitch", osc2_pitch_action))

    -- Set the next metro time to the smallest duration (shortest step)
    local min_duration = math.min(table.unpack(durations))
    m.time = min_duration
    od.tr_pulse(4)
end

-- Start and stop the metro
function start()
    m:start()
end

function stop()
    m:stop()
end
