-- Crow script for sampling, inversion, and random voltage generation

function init()
    input[1].mode('change', 1.0, 0.1, 'rising') -- Detect rising edge on input 1 (trigger)
    input[1].change = process_trigger
    print("Initialized Crow script.")
end

function process_trigger()
    local sampled_voltage = input[2].volts -- Sample input 2 voltage
    local inverted_voltage = -sampled_voltage -- Invert voltage
    local random_step = math.random() * 10 - 5 -- Generate stepped random voltage (-5 to +5)
    local random_slew = math.random() * 10 - 5 -- Generate new random voltage for slewing
    local slew_time = math.random() * 6 -- Randomize slew time between 0 and 6 seconds
    
    print("Trigger received!")
    print("Sampled Voltage (Input 2):", sampled_voltage)
    print("Inverted Voltage (Output 2):", inverted_voltage)
    print("Stepped Random Voltage (Output 3):", random_step)
    print("Slewed Random Voltage (Output 4):", random_slew, "(Slew Time:", slew_time, ")")
    
    output[1].volts = sampled_voltage -- Output 1: Sampled voltage
    output[2].volts = inverted_voltage -- Output 2: Inverted voltage
    output[3].volts = random_step -- Output 3: Stepped random voltage
    output[4].slew = slew_time -- Apply random slew time
    output[4].volts = random_slew -- Output 4: Slewed random voltage
end
