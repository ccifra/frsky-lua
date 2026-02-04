-- GYA553 Gyro Gain Calculator
-- Creates three sources for Aileron, Elevator, and Rudder gain channels
-- Each calculates: input * 0.6 + 512 for Heading Hold, input * -0.6 + 512 for Normal

local aileronConfig = {
    source = nil,
    mode = 0,  -- 0 = Off, 1 = Normal, 2 = Heading Hold, 3 = Switched
    normalSwitch = nil,
    hhSwitch = nil,
    lastInputValue = nil
}

local elevatorConfig = {
    source = nil,
    mode = 0,
    normalSwitch = nil,
    hhSwitch = nil,
    lastInputValue = nil
}

local rudderConfig = {
    source = nil,
    mode = 0,
    normalSwitch = nil,
    hhSwitch = nil,
    lastInputValue = nil
}

-- Helper function to add configuration fields for a gyro axis
local function addAxisConfig(axisName, config)
    local line = form.addLine(axisName .. " Gain Input")
    form.addSourceField(line, nil,
        function() return config.source end,
        function(value) config.source = value end)
    
    line = form.addLine("Mode")
    form.addChoiceField(line, nil, {{"Off", 0}, {"Normal", 1}, {"Heading Hold", 2}, {"Switched", 3}},
        function() return config.mode end,
        function(value) config.mode = value end)
    
    line = form.addLine("Normal Switch")
    form.addSourceField(line, nil,
        function() return config.normalSwitch end,
        function(value) config.normalSwitch = value end)
    
    line = form.addLine("Heading Hold Switch")
    form.addSourceField(line, nil,
        function() return config.hhSwitch end,
        function(value) config.hhSwitch = value end)
end

local function configureAileron()
    addAxisConfig("Aileron", aileronConfig)
end

local function configureElevator()
    addAxisConfig("Elevator", elevatorConfig)
end

local function configureRudder()
    addAxisConfig("Rudder", rudderConfig)
end

-- Helper function to read config from storage
local function readConfig(prefix, config)
    config.source = storage.read(prefix .. "Source")
    config.mode = storage.read(prefix .. "Mode") or 0
    config.normalSwitch = storage.read(prefix .. "NormalSwitch")
    config.hhSwitch = storage.read(prefix .. "HHSwitch")
end

local function readAileron()
    readConfig("aileron", aileronConfig)
end

local function readElevator()
    readConfig("elevator", elevatorConfig)
end

local function readRudder()
    readConfig("rudder", rudderConfig)
end

-- Helper function to write config to storage
local function writeConfig(prefix, config)
    storage.write(prefix .. "Source", config.source)
    storage.write(prefix .. "Mode", config.mode)
    storage.write(prefix .. "NormalSwitch", config.normalSwitch)
    storage.write(prefix .. "HHSwitch", config.hhSwitch)
end

local function writeAileron()
    writeConfig("aileron", aileronConfig)
end

local function writeElevator()
    writeConfig("elevator", elevatorConfig)
end

local function writeRudder()
    writeConfig("rudder", rudderConfig)
end

-- Helper function to calculate gain based on input value and mode settings
local function calculateGain(config)
    local inputValue = config.source:value()
    local sourceName = config.source:name()
    local sourceMax = config.source:maximum()
    local sourceMin = config.source:minimum()

    if (inputValue < 0) then
        inputValue = 0
    end
    
    -- Normalize input value
    local normalizedValue = (inputValue / sourceMax)
    
    -- Determine active mode
    -- mode: 0 = Off, 1 = Normal, 2 = Heading Hold, 3 = Switched
    local activeMode = config.mode
    
    if config.mode == 3 then
        -- Switched mode - check switch positions to determine actual mode
        -- User can select specific switch positions (e.g., SA↑, SB-, etc.)
        -- These sources are active (>0) when in that position
        local normalActive = false
        local hhActive = false
        
        if config.normalSwitch ~= nil and type(config.normalSwitch) == "userdata" then
            local normalSwitchValue = config.normalSwitch:value()
            normalActive = normalSwitchValue > 0
        end
        
        if config.hhSwitch ~= nil and type(config.hhSwitch) == "userdata" then
            local hhSwitchValue = config.hhSwitch:value()
            hhActive = hhSwitchValue > 0
        end
        
        if normalActive then
            activeMode = 1  -- Normal
        elseif hhActive then
            activeMode = 2  -- Heading Hold
        else
            activeMode = 0  -- Off
        end
    end
    
    -- Calculate result based on active mode
    if activeMode == 1 then
        -- Normal mode
        local result = -((normalizedValue * 596) + 428)
        return result
    elseif activeMode == 2 then
        -- Heading Hold mode
        local result = (normalizedValue * 596) + 428
        return result
    end
    
    -- Off mode
    return 0
end

local function wakeupAileron(source)
    if aileronConfig.source then
        local result = calculateGain(aileronConfig)
        source:value(result)
    else
        source:value(0)
    end
end

local function wakeupElevator(source)
    if elevatorConfig.source then
        local result = calculateGain(elevatorConfig)
        source:value(result)
    else
        source:value(0)
    end
end

local function wakeupRudder(source)
    if rudderConfig.source then
        local result = calculateGain(rudderConfig)
        source:value(result)
    else
        source:value(0)
    end
end

local function init()
    system.registerSource({
        key = "GYA553A",
        name = "GYA553 Ail Gain",
        wakeup = wakeupAileron,
        read = readAileron,
        write = writeAileron,
        configure = configureAileron
    })
    
    system.registerSource({
        key = "GYA553E",
        name = "GYA553 Ele Gain",
        wakeup = wakeupElevator,
        read = readElevator,
        write = writeElevator,
        configure = configureElevator
    })
    
    system.registerSource({
        key = "GYA553R",
        name = "GYA553 Rud Gain",
        wakeup = wakeupRudder,
        read = readRudder,
        write = writeRudder,
        configure = configureRudder
    })
end

return {init = init}
