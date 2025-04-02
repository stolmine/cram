-- Crow script for sampling, inversion, and random voltage generation

function init()
    input[1].mode('change', 1.0, 0.1, 'rising') -- Detect rising edge on input 1 (trigger)
    input[1].change = process_trigger
end

function process_trigger()
    local sampled_voltage = input[2].volts -- Sample input 2 voltage
    local inverted_voltage = -sampled_voltage -- Invert voltage
    local random_step = math.random() * 10 - 5 -- Generate stepped random voltage (-5 to +5)
    local random_slew = math.random() * 10 - 5 -- Generate new random voltage for slewing
    
    output[1].volts = sampled_voltage -- Output 1: Sampled voltage
    output[2].volts = inverted_voltage -- Output 2: Inverted voltage
    output[3].volts = random_step -- Output 3: Stepped random voltage
    output[4].slew = math.random() * 0.5 + 0.1 -- Randomize slew time per trigger
    output[4].volts = random_slew -- Output 4: Slewed random voltage
end
