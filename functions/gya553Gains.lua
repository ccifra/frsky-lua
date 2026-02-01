-- GYA553 Gyro Gain Calculator
-- Creates three sources for Aileron, Elevator, and Rudder gain channels
-- Each calculates: input * 0.6 + 50 for Heading Hold, input * -0.6 + 50 for Normal

local aileronSource = nil
local elevatorSource = nil
local rudderSource = nil

local aileronNormalType = 0  -- 0 = Boolean, 1 = Switch
local aileronNormalMode = nil
local aileronNormalSwitch = nil
local aileronHHType = 0
local aileronHHMode = nil
local aileronHHSwitch = nil

local elevatorNormalType = 0
local elevatorNormalMode = nil
local elevatorNormalSwitch = nil
local elevatorHHType = 0
local elevatorHHMode = nil
local elevatorHHSwitch = nil

local rudderNormalType = 0
local rudderNormalMode = nil
local rudderNormalSwitch = nil
local rudderHHType = 0
local rudderHHMode = nil
local rudderHHSwitch = nil

local function configureAileron()
    local line = form.addLine("Aileron Gain Input")
    form.addSourceField(line, nil,
        function() return aileronSource end,
        function(value) aileronSource = value end)
    
    line = form.addLine("Normal Mode Type")
    form.addChoiceField(line, nil, {{"Boolean", 0}, {"Switch", 1}},
        function() return aileronNormalType end,
        function(value) aileronNormalType = value end)
    
    line = form.addLine("Normal Mode Bool")
    form.addBooleanField(line, nil,
        function() return aileronNormalMode end,
        function(value) aileronNormalMode = value end)
    
    line = form.addLine("Normal Mode Switch")
    form.addSourceField(line, nil,
        function() return aileronNormalSwitch end,
        function(value) aileronNormalSwitch = value end)
    
    line = form.addLine("HH Mode Type")
    form.addChoiceField(line, nil, {{"Boolean", 0}, {"Switch", 1}},
        function() return aileronHHType end,
        function(value) aileronHHType = value end)
    
    line = form.addLine("HH Mode Bool")
    form.addBooleanField(line, nil,
        function() return aileronHHMode end,
        function(value) aileronHHMode = value end)
    
    line = form.addLine("HH Mode Switch")
    form.addSourceField(line, nil,
        function() return aileronHHSwitch end,
        function(value) aileronHHSwitch = value end)
end

local function configureElevator()
    local line = form.addLine("Elevator Gain Input")
    form.addSourceField(line, nil,
        function() return elevatorSource end,
        function(value) elevatorSource = value end)
    
    line = form.addLine("Normal Mode Type")
    form.addChoiceField(line, nil, {{"Boolean", 0}, {"Switch", 1}},
        function() return elevatorNormalType end,
        function(value) elevatorNormalType = value end)
    
    line = form.addLine("Normal Mode Bool")
    form.addBooleanField(line, nil,
        function() return elevatorNormalMode end,
        function(value) elevatorNormalMode = value end)
    
    line = form.addLine("Normal Mode Switch")
    form.addSourceField(line, nil,
        function() return elevatorNormalSwitch end,
        function(value) elevatorNormalSwitch = value end)
    
    line = form.addLine("HH Mode Type")
    form.addChoiceField(line, nil, {{"Boolean", 0}, {"Switch", 1}},
        function() return elevatorHHType end,
        function(value) elevatorHHType = value end)
    
    line = form.addLine("HH Mode Bool")
    form.addBooleanField(line, nil,
        function() return elevatorHHMode end,
        function(value) elevatorHHMode = value end)
    
    line = form.addLine("HH Mode Switch")
    form.addSourceField(line, nil,
        function() return elevatorHHSwitch end,
        function(value) elevatorHHSwitch = value end)
end

local function configureRudder()
    local line = form.addLine("Rudder Gain Input")
    form.addSourceField(line, nil,
        function() return rudderSource end,
        function(value) rudderSource = value end)
    
    line = form.addLine("Normal Mode Type")
    form.addChoiceField(line, nil, {{"Boolean", 0}, {"Switch", 1}},
        function() return rudderNormalType end,
        function(value) rudderNormalType = value end)
    
    line = form.addLine("Normal Mode Bool")
    form.addBooleanField(line, nil,
        function() return rudderNormalMode end,
        function(value) rudderNormalMode = value end)
    
    line = form.addLine("Normal Mode Switch")
    form.addSourceField(line, nil,
        function() return rudderNormalSwitch end,
        function(value) rudderNormalSwitch = value end)
    
    line = form.addLine("HH Mode Type")
    form.addChoiceField(line, nil, {{"Boolean", 0}, {"Switch", 1}},
        function() return rudderHHType end,
        function(value) rudderHHType = value end)
    
    line = form.addLine("HH Mode Bool")
    form.addBooleanField(line, nil,
        function() return rudderHHMode end,
        function(value) rudderHHMode = value end)
    
    line = form.addLine("HH Mode Switch")
    form.addSourceField(line, nil,
        function() return rudderHHSwitch end,
        function(value) rudderHHSwitch = value end)
end

local function readAileron()
    aileronSource = storage.read("aileronSource")
    aileronNormalType = storage.read("aileronNormalType") or 0
    aileronNormalMode = storage.read("aileronNormalMode")
    aileronNormalSwitch = storage.read("aileronNormalSwitch")
    aileronHHType = storage.read("aileronHHType") or 0
    aileronHHMode = storage.read("aileronHHMode")
    aileronHHSwitch = storage.read("aileronHHSwitch")
end

local function readElevator()
    elevatorSource = storage.read("elevatorSource")
    elevatorNormalType = storage.read("elevatorNormalType") or 0
    elevatorNormalMode = storage.read("elevatorNormalMode")
    elevatorNormalSwitch = storage.read("elevatorNormalSwitch")
    elevatorHHType = storage.read("elevatorHHType") or 0
    elevatorHHMode = storage.read("elevatorHHMode")
    elevatorHHSwitch = storage.read("elevatorHHSwitch")
end

local function readRudder()
    rudderSource = storage.read("rudderSource")
    rudderNormalType = storage.read("rudderNormalType") or 0
    rudderNormalMode = storage.read("rudderNormalMode")
    rudderNormalSwitch = storage.read("rudderNormalSwitch")
    rudderHHType = storage.read("rudderHHType") or 0
    rudderHHMode = storage.read("rudderHHMode")
    rudderHHSwitch = storage.read("rudderHHSwitch")
end

local function writeAileron()
    storage.write("aileronSource", aileronSource)
    storage.write("aileronNormalType", aileronNormalType)
    storage.write("aileronNormalMode", aileronNormalMode)
    storage.write("aileronNormalSwitch", aileronNormalSwitch)
    storage.write("aileronHHType", aileronHHType)
    storage.write("aileronHHMode", aileronHHMode)
    storage.write("aileronHHSwitch", aileronHHSwitch)
end

local function writeElevator()
    storage.write("elevatorSource", elevatorSource)
    storage.write("elevatorNormalType", elevatorNormalType)
    storage.write("elevatorNormalMode", elevatorNormalMode)
    storage.write("elevatorNormalSwitch", elevatorNormalSwitch)
    storage.write("elevatorHHType", elevatorHHType)
    storage.write("elevatorHHMode", elevatorHHMode)
    storage.write("elevatorHHSwitch", elevatorHHSwitch)
end

local function writeRudder()
    storage.write("rudderSource", rudderSource)
    storage.write("rudderNormalType", rudderNormalType)
    storage.write("rudderNormalMode", rudderNormalMode)
    storage.write("rudderNormalSwitch", rudderNormalSwitch)
    storage.write("rudderHHType", rudderHHType)
    storage.write("rudderHHMode", rudderHHMode)
    storage.write("rudderHHSwitch", rudderHHSwitch)
end

local function wakeupAileron(source)
    if aileronSource then
        local value = aileronSource:value()
        local result = 50
        
        local normalActive = false
        local hhActive = false
        
        if aileronNormalType == 0 then
            normalActive = aileronNormalMode == true
        else
            normalActive = aileronNormalSwitch and aileronNormalSwitch:value() > 0
        end
        
        if aileronHHType == 0 then
            hhActive = aileronHHMode == true
        else
            hhActive = aileronHHSwitch and aileronHHSwitch:value() > 0
        end
        
        if normalActive then
            result = (value * -0.6) + 50
        elseif hhActive then
            result = (value * 0.6) + 50
        end
        
        source:value(result)
    else
        source:value(50)
    end
end

local function wakeupElevator(source)
    if elevatorSource then
        local value = elevatorSource:value()
        local result = 50
        
        local normalActive = false
        local hhActive = false
        
        if elevatorNormalType == 0 then
            normalActive = elevatorNormalMode == true
        else
            normalActive = elevatorNormalSwitch and elevatorNormalSwitch:value() > 0
        end
        
        if elevatorHHType == 0 then
            hhActive = elevatorHHMode == true
        else
            hhActive = elevatorHHSwitch and elevatorHHSwitch:value() > 0
        end
        
        if normalActive then
            result = (value * -0.6) + 50
        elseif hhActive then
            result = (value * 0.6) + 50
        end
        
        source:value(result)
    else
        source:value(50)
    end
end

local function wakeupRudder(source)
    if rudderSource then
        local value = rudderSource:value()
        local result = 50
        
        local normalActive = false
        local hhActive = false
        
        if rudderNormalType == 0 then
            normalActive = rudderNormalMode == true
        else
            normalActive = rudderNormalSwitch and rudderNormalSwitch:value() > 0
        end
        
        if rudderHHType == 0 then
            hhActive = rudderHHMode == true
        else
            hhActive = rudderHHSwitch and rudderHHSwitch:value() > 0
        end
        
        if normalActive then
            result = (value * -0.6) + 50
        elseif hhActive then
            result = (value * 0.6) + 50
        end
        
        source:value(result)
    else
        source:value(50)
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
