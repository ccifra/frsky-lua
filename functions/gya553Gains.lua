-- GYA553 Gyro Gain Calculator
-- Creates three sources for Aileron, Elevator, and Rudder gain channels
-- Each calculates: input * 0.6 + 512 for Heading Hold, input * -0.6 + 512 for Normal

local aileronConfig = {
    source = nil,
    normalMode = 0,  -- 0 = Off, 1 = On, 2 = Switch
    normalSwitch = nil,
    hhMode = 0,
    hhSwitch = nil,
    lastInputValue = nil
}

local elevatorConfig = {
    source = nil,
    normalMode = 0,
    normalSwitch = nil,
    hhMode = 0,
    hhSwitch = nil,
    lastInputValue = nil
}

local rudderConfig = {
    source = nil,
    normalMode = 0,
    normalSwitch = nil,
    hhMode = 0,
    hhSwitch = nil,
    lastInputValue = nil
}

-- Helper function to add configuration fields for a gyro axis
local function addAxisConfig(axisName, config)
    local line = form.addLine(axisName .. " Gain Input")
    form.addSourceField(line, nil,
        function() return config.source end,
        function(value) config.source = value end)
    
    line = form.addLine("Normal Mode")
    form.addChoiceField(line, nil, {{"Off", 0}, {"On", 1}, {"Switch", 2}},
        function() return config.normalMode end,
        function(value) config.normalMode = value end)
    
    line = form.addLine("Normal Switch")
    form.addSourceField(line, nil,
        function() return config.normalSwitch end,
        function(value) config.normalSwitch = value end)
    
    line = form.addLine("Heading Hold Mode")
    form.addChoiceField(line, nil, {{"Off", 0}, {"On", 1}, {"Switch", 2}},
        function() return config.hhMode end,
        function(value) config.hhMode = value end)
    
    line = form.addLine("HH Switch")
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
    config.normalMode = storage.read(prefix .. "NormalMode") or 0
    config.normalSwitch = storage.read(prefix .. "NormalSwitch")
    config.hhMode = storage.read(prefix .. "HHMode") or 0
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
    storage.write(prefix .. "NormalMode", config.normalMode)
    storage.write(prefix .. "NormalSwitch", config.normalSwitch)
    storage.write(prefix .. "HHMode", config.hhMode)
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

-- Helper function to check if a mode is active
-- mode: 0 = Off, 1 = On, 2 = Switch
-- switchSource: the switch source to check if mode is 2
local function isModeActive(mode, switchSource)
    if mode == 1 then
        return true
    elseif mode == 2 then
        return switchSource and switchSource:value() > 0
    end
    return false
end

-- Helper function to calculate gain based on input value and mode settings
local function calculateGain(config)
    local inputValue = config.source:value()
    local sourceName = config.source:name()
    local sourceMax = config.source:maximum()
    local sourceMin = config.source:minimum()

    -- Only log when input value changes
    local shouldLog = (inputValue ~= config.lastInputValue)
    if shouldLog then
        config.lastInputValue = inputValue
    end
    
    if (inputValue < 0) then
        inputValue = 0
    end
    
    -- Try to use rawValue for consistent range across all source types
    print ("inputValue for", sourceName, "is", inputValue, " (min:", sourceMin, "max:", sourceMax, ")")
    local normalizedValue = (inputValue / sourceMax)
    print("Normalized from", inputValue , "to", normalizedValue)
    
    if isModeActive(config.normalMode, config.normalSwitch) then
        local result = -((normalizedValue * 596) + 428)
        return result
    elseif isModeActive(config.hhMode, config.hhSwitch) then
        local result = (normalizedValue * 596) + 428
        return result
    end
    if shouldLog then
        print("calculateGain - No mode active, returning default")
    end
    return (0)
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
        key = "GYAAil",
        name = "GYA Aileron",
        wakeup = wakeupAileron,
        read = readAileron,
        write = writeAileron,
        configure = configureAileron
    })
    
    system.registerSource({
        key = "GYAEle",
        name = "GYA Elevator",
        wakeup = wakeupElevator,
        read = readElevator,
        write = writeElevator,
        configure = configureElevator
    })
    
    system.registerSource({
        key = "GYARud",
        name = "GYA Rudder",
        wakeup = wakeupRudder,
        read = readRudder,
        write = writeRudder,
        configure = configureRudder
    })
end

return {init = init}
