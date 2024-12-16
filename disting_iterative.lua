-- Configurable rate (in seconds) for checking the voltage
local check_interval = 0.05 -- Check every n seconds

function init()
    ii.disting.algorithm(21)     -- Set algorithm to Macro Oscillator 2
    print("Algorithm set to SD multisample")

    -- Start a coroutine for continuous checking
    clock.run(check_voltage_loop)
end

function check_voltage_loop()
    while true do
        local volts = input[1].volts -- Read input voltage
        print("Input voltage: " .. volts) -- Debugging output

        if volts > 1 then
            print("^ Voltage crossed the 1V threshold! Exiting loop.")
            break -- Exit the loop when the threshold is crossed
        else
            print("Voltage less than 1V, testing commands")

            -- Test ii commands
            ii.disting.voice_on(0, 8000)
            ii.disting.voice_pitch(0, 0)
            ii.disting.voice_off(0)
            print("voice_on, voice_pitch, voice_off")

            clock.sleep(0.5) -- Pause for 2 seconds between command groups

            -- ii.disting.voice_on(1, 5000)
            -- ii.disting.voice_pitch(1, -1)
            -- ii.disting.voice_off(1)
            -- print("voice_on, voice_pitch, voice_off")

            -- ii.disting.note_pitch(1, -2)
            -- ii.disting.note_velocity(1, 6000)
            -- ii.disting.note_off(1)

            -- print("note_pitch, note_velocity, note_off")


            -- clock.sleep(0.5) -- Pause for 2 seconds between command groups

        end

        -- Wait before checking the voltage again
        clock.sleep(check_interval)
    end
end
