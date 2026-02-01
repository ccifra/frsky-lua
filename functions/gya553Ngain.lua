-- GYA553 Normal Gain Calculator
-- Converts input to normal gain: input * -0.6 + 50

local gainSource = nil

local function configure()
    -- Configuration UI to select the input source
    local line = form.addLine("Gain Input")
    form.addSourceField(line, nil,
        function() return gainSource end,
        function(value) gainSource = value end)
end

local function read()
    -- Read stored configuration
    gainSource = storage.read("gainSource")
end

local function write()
    -- Write configuration to storage
    storage.write("gainSource", gainSource)
end

local function wakeup(source)
    -- Calculate and set the source value
    if gainSource then
        local gain = gainSource:value()
        
        -- Calculate: input * -0.6 + 50
        local result = (gain * -0.6) + 50
        
        source:value(result)
    else
        -- Default value if no source configured
        source:value(50)
    end
end

local function init()
    -- Register the custom source with all handlers
    system.registerSource({
        key = "NGain",
        name = "Normal Gain",
        wakeup = wakeup,
        read = read,
        write = write,
        configure = configure
    })
end

return {init = init}
