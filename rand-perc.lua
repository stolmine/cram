--- random percussion gen
-- input 1 on crow triggers basic gen
-- input 2 should open a vca to provide kick EG to voice

function init()
    od = ii.er301
    txo = ii.txo
    input[1].mode('change', 1.0, 0.1, 'rising')
    input[1].change = process_trigger
    input[2].mode('change', 1.0, 0.1, 'rising')
    input[2].change = kick_vca
    txo.env_act(1,1)
    txo.env_att(1,0)
    txo.cv(1,5)
end

function process_trigger()
    local random1 = math.floor(math.random() * 501) / 100 -- produce numbers between 0 and 5 with two decimals of float
    local random2 = math.floor(math.random() * 501) / 100
    local random3 = math.floor(math.random() * 501) / 100
    local random4 = math.floor(math.random() * 501) / 100

    output[1].volts = random1
    output[2].volts = random2
    output[3].volts = random3
    output[4].volts = random4

    txo.tr_pulse(1)
end

function kick_vca() -- ideally i'd like to produce a gate the same length as my envelope each time, decay only is fine
    local env_time = math.floor(math.random() * 501) -- produce a raw number between 0 and 500

    txo.tr_time(2,env_time)
    txo.tr_pulse(2)
    txo.env_dec(1,env_time)
    txo.env_trig(1)
end
