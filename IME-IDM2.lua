-- you know how it go
--- template to speed up starting

function init()
    dex = ii.disting
    od = ii.er301
    txo = ii.txo
    txi = ii.txi
    jf = ii.jf
    -- plus whatever else!
    beat_seq = populate_beat()
    env_seq = populate_env()
    hat_seq = populate_hat()
    txo.tr_time(1,3)
    txo.env_act(1,1)
    txo.env_att(1,0)
    txo.env_dec(1,30)
    txo.cv(1,5)
end

local beat_chars = {1,0}
local beat_length = 67
local env_length = 43
local hat_length = 108

local step = 1
local env_step = 1
local hat_step = 1

function populate_beat()
    -- create a random sequence of 1s and 0s at beat_length
    local sequence = {}
    for i = 1, beat_length do
        table.insert(sequence, beat_chars[math.random(1, #beat_chars)])
    end
    return sequence
end

function populate_hat()
    local sequence = {}
    for i = 1, hat_length do
        table.insert(sequence, beat_chars[math.random(1, #beat_chars)])
    end
    return sequence
end

function populate_env()
    local sequence = {}
    for i = 1, env_length do
        table.insert(sequence, beat_chars[math.random(1, #beat_chars)])
    end
    return sequence
end

function env()
    if env_seq[env_step] == 1 then
        txo.env_trig(1,1)
    elseif env_seq[env_step] == 0 then
        --do nothing
    end
    env_step = (env_step % #env_seq) + 1
end

function hat()
    if hat_seq[hat_step] == 1 then
        txo.cv(2,3)
    elseif hat_seq[hat_step] == 0 then
        txo.cv(2,0)
    end
    hat_step = (hat_step % #hat_seq) + 1
end

function beat()
    -- do something
    if beat_seq[step] == 1 then
        txo.tr_pulse(1)
    elseif beat_seq[step] == 0 then
        -- do nothing!
    end
    step = (step % #beat_seq) + 1
end

-- metro setup

m = metro.init()

    m.event = function()
        beat()
        env()
        hat()
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