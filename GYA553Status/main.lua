-- GYA553 Gyro Status Widget
-- Displays the status of a GYA553 Gyro by monitoring gain channels

local function create()
    -- Initialize widget with default values
    local widget = {
        aileronSource = nil,
        elevatorSource = nil,
        rudderSource = nil,
        aileronValue = 0,
        elevatorValue = 0,
        rudderValue = 0,
        autoRecoverySource = nil,
        autoRecoveryValue = 0,
        -- Default mode colors
        normalColor = lcd.RGB(100, 200, 100),      -- Green
        offColor = lcd.RGB(150, 150, 150),         -- Gray
        headingHoldColor = lcd.RGB(100, 150, 255), -- Blue
        -- View mode
        compactView = false  -- Default to full view
    }
    return widget
end

local function configure(widget)
    -- Configuration menu for selecting gain channels
    
    -- Aileron Gain Channel
    local line = form.addLine("Aileron Gain")
    form.addSourceField(line, nil, 
        function() return widget.aileronSource end, 
        function(value) widget.aileronSource = value end)
    
    -- Elevator Gain Channel
    line = form.addLine("Elevator Gain")
    form.addSourceField(line, nil, 
        function() return widget.elevatorSource end, 
        function(value) widget.elevatorSource = value end)
    
    -- Rudder Gain Channel
    line = form.addLine("Rudder Gain")
    form.addSourceField(line, nil, 
        function() return widget.rudderSource end, 
        function(value) widget.rudderSource = value end)
    
    -- Auto Recovery Channel
    line = form.addLine("Auto Recovery")
    form.addSourceField(line, nil, 
        function() return widget.autoRecoverySource end, 
        function(value) widget.autoRecoverySource = value end)
    
    -- Color Configuration
    line = form.addLine("Normal Color")
    form.addColorField(line, nil,
        function() return widget.normalColor end,
        function(value) widget.normalColor = value end)
    
    line = form.addLine("Off Color")
    form.addColorField(line, nil,
        function() return widget.offColor end,
        function(value) widget.offColor = value end)
    
    line = form.addLine("Heading Hold Color")
    form.addColorField(line, nil,
        function() return widget.headingHoldColor end,
        function(value) widget.headingHoldColor = value end)
    
    -- View Mode
    line = form.addLine("Compact View")
    form.addBooleanField(line, nil,
        function() return widget.compactView end,
        function(value) widget.compactView = value end)
end

local function getMode(value)
    -- Determine mode based on channel value
    -- Ethos values range from -1024 to 1024
    if value <= -428 then
        return "Normal"
    elseif value >= 428 then
        return "Heading Hold"
    else
        return "Off"
    end
end

local function calculateGain(value)
    local gainPercent = (math.abs(value) - 428) / 596
    if (gainPercent < 0) then
        return nil
    end
    return math.floor(gainPercent * 100)
end

local function getModeColor(mode, widget)
    -- Return color based on mode from widget configuration
    if mode == "Normal" then
        return widget.normalColor
    elseif mode == "Heading Hold" then
        return widget.headingHoldColor
    else
        return widget.offColor
    end
end

local function paintCompactView(widget, textColor)
    -- Compact view - simplified display
    local y = 5
    local lineHeight = 26
    local col1 = 5
    local col2 = 45
    local col3 = 175
    
    -- Compact rows - just axis label, mode, and gain
    if widget.aileronSource ~= nil then
        local mode = getMode(widget.aileronValue)
        local modeColor = getModeColor(mode, widget)
        
        lcd.color(textColor)
        lcd.drawText(col1, y, "A:", 0)
        lcd.color(modeColor)
        lcd.drawFilledRectangle(col2 - 2, y - 2, 120, 18)
        lcd.color(lcd.RGB(255, 255, 255))
        lcd.drawText(col2, y, mode, FONT_S + FONT_S)
        lcd.color(textColor)
        
        local gain = calculateGain(widget.aileronValue)
        if gain ~= nil then
            lcd.drawNumber(col3, y, gain, 0)
            lcd.drawText(col3 + 20, y, "%", 0)
        end
        y = y + lineHeight
    end
    
    if widget.elevatorSource ~= nil then
        local mode = getMode(widget.elevatorValue)
        local modeColor = getModeColor(mode, widget)
        
        lcd.color(textColor)
        lcd.drawText(col1, y, "E:", 0)
        lcd.color(modeColor)
        lcd.drawFilledRectangle(col2 - 2, y - 2, 120, 18)
        lcd.color(lcd.RGB(255, 255, 255))
        lcd.drawText(col2, y, mode, FONT_S + FONT_S)
        lcd.color(textColor)
        
        local gain = calculateGain(widget.elevatorValue)
        if gain ~= nil then
            lcd.drawNumber(col3, y, gain, 0)
            lcd.drawText(col3 + 20, y, "%", 0)
        end
        y = y + lineHeight
    end
    
    if widget.rudderSource ~= nil then
        local mode = getMode(widget.rudderValue)
        local modeColor = getModeColor(mode, widget)
        
        lcd.color(textColor)
        lcd.drawText(col1, y, "R:", 0)
        lcd.color(modeColor)
        lcd.drawFilledRectangle(col2 - 2, y - 2, 120, 18)
        lcd.color(lcd.RGB(255, 255, 255))
        lcd.drawText(col2, y, mode, FONT_S + FONT_S)
        lcd.color(textColor)
        
        local gain = calculateGain(widget.rudderValue)
        if gain ~= nil then
            lcd.drawNumber(col3, y, gain, 0)
            lcd.drawText(col3 + 20, y, "%", 0)
        end
        y = y + lineHeight
    end
    
    -- Auto Recovery (compact)
    y = y + 3
    lcd.color(textColor)
    local autoRecoveryStatus = "Off"
    if widget.autoRecoverySource ~= nil and widget.autoRecoveryValue > 512 then
        autoRecoveryStatus = "On"
    end
    lcd.drawText(col1, y, "AR: " .. autoRecoveryStatus, 0)
end

local function paintFullView(widget, textColor, lineColor)
    -- Full view - original detailed display
    local y = 10
    local lineHeight = 59
    local rowHeight = 50
    local textOffset = 10
    local col1 = 10
    local col2 = 60
    local col3 = 180
    local col4 = 180
    
    -- Title
    lcd.color(textColor)
    lcd.drawText(col1, y, "GYA553 Gyro XXX", FONT_BOLD)
    
    -- Debug: Show aileron raw value on screen
    lcd.color(lcd.RGB(255, 0, 0))
    
    y = y + lineHeight
    
    -- Aileron Gain
    if widget.aileronSource ~= nil then
        -- Draw box around row
        lcd.color(lineColor)
        lcd.drawRectangle(col1 - 5, y - 2, 248, rowHeight)
        
        -- Draw vertical grid lines
        lcd.drawLine(col2 - 5, y - 2, col2 - 5, y + rowHeight - 4)
        lcd.drawLine(col3 - 10, y - 2, col3 - 10, y + rowHeight - 4)
        
        lcd.color(textColor)
        lcd.drawText(col2 - 8, y + textOffset, "Ail", RIGHT)
        local mode = getMode(widget.aileronValue)
        
        -- Draw colored background for mode (fill the row)
        local modeColor = getModeColor(mode, widget)
        lcd.color(modeColor)
        lcd.drawFilledRectangle(col2 - 1, y + 1, 106, rowHeight - 6)
        lcd.color(lcd.RGB(255, 255, 255))  -- White text on colored background
        lcd.drawText(col2 + 2, y + textOffset+2, mode, FONT_S)
        lcd.color(textColor)  -- Reset to theme color
        
        local gain = calculateGain(widget.aileronValue)
        if gain ~= nil then
            lcd.drawNumber(col4, y + textOffset, gain, FONT_S)
            lcd.drawText(col4 + 38, y + textOffset, "%", FONT_S)
        end
    else
        lcd.color(textColor)
        lcd.drawText(col1, y + textOffset, "Ail: Not configured", 0)
    end
    y = y + lineHeight
    
    -- Elevator Gain
    if widget.elevatorSource ~= nil then
        -- Draw box around row
        lcd.color(lineColor)
        lcd.drawRectangle(col1 - 5, y - 2, 248, rowHeight)
        
        -- Draw vertical grid lines
        lcd.drawLine(col2 - 5, y - 2, col2 - 5, y + rowHeight - 4)
        lcd.drawLine(col3 - 10, y - 2, col3 - 10, y + rowHeight - 4)
        
        lcd.color(textColor)
        lcd.drawText(col2 - 8, y + textOffset, "Ele", RIGHT)
        local mode = getMode(widget.elevatorValue)
        
        -- Draw colored background for mode (fill the row)
        local modeColor = getModeColor(mode, widget)
        lcd.color(modeColor)
        lcd.drawFilledRectangle(col2 - 1, y + 1, 106, rowHeight - 6)
        lcd.color(lcd.RGB(255, 255, 255))  -- White text on colored background
        lcd.drawText(col2 + 2, y + textOffset, mode, FONT_S)
        lcd.color(textColor)  -- Reset to theme color
        
        local gain = calculateGain(widget.elevatorValue)
        if gain ~= nil then
            lcd.drawNumber(col4, y + textOffset, gain, FONT_S)
            lcd.drawText(col4 + 38, y + textOffset, "%", FONT_S)
        end
    else
        lcd.color(textColor)
        lcd.drawText(col1, y + textOffset, "Ele: Not configured", 0)
    end
    y = y + lineHeight
    
    -- Rudder Gain
    if widget.rudderSource ~= nil then
        -- Draw box around row
        lcd.color(lineColor)
        lcd.drawRectangle(col1 - 5, y - 2, 248, rowHeight)
        
        -- Draw vertical grid lines
        lcd.drawLine(col2 - 5, y - 2, col2 - 5, y + rowHeight - 4)
        lcd.drawLine(col3 - 8, y - 2, col3 - 8, y + rowHeight - 4)
        
        lcd.color(textColor)
        lcd.drawText(col2 - 10, y + textOffset, "Rud", RIGHT)
        local mode = getMode(widget.rudderValue)
        
        -- Draw colored background for mode (fill the row)
        local modeColor = getModeColor(mode, widget)
        lcd.color(modeColor)
        lcd.drawFilledRectangle(col2 - 1, y + 1, 106, rowHeight - 6)
        lcd.color(lcd.RGB(255, 255, 255))  -- White text on colored background
        lcd.drawText(col2 + 2, y + textOffset, mode, FONT_S)
        lcd.color(textColor)  -- Reset to theme color
        
        local gain = calculateGain(widget.rudderValue)
        if gain ~= nil then
            lcd.drawNumber(col4, y + textOffset, gain, FONT_S)
            lcd.drawText(col4 + 38, y + textOffset, "%", FONT_S)
        end
    else
        lcd.color(textColor)
        lcd.drawText(col1, y + textOffset, "Rud: Not configured", 0)
    end
    y = y + lineHeight
    
    -- Auto Recovery Status
    lcd.color(textColor)
    local autoRecoveryStatus = "Off"
    if widget.autoRecoverySource ~= nil then
        if widget.autoRecoveryValue > 512 then
            autoRecoveryStatus = "On"
        end
    end
    lcd.drawText(col1, y + 5, "Auto Recovery: ", 0)
    lcd.drawText(col1 + 165, y + 5, autoRecoveryStatus, FONT_BOLD)
end

local function paint(widget)
    -- Detect theme and set colors
    local isDarkMode = lcd.darkMode()
    local textColor = isDarkMode and lcd.RGB(255, 255, 255) or lcd.RGB(0, 0, 0)
    local lineColor = isDarkMode and lcd.RGB(200, 200, 200) or lcd.RGB(50, 50, 50)
    
    -- Use configured view mode
    if widget.compactView then
        paintCompactView(widget, textColor)
    else
        paintFullView(widget, textColor, lineColor)
    end
end

local function wakeup(widget)
    -- Update channel values
    if widget.aileronSource ~= nil then
        widget.aileronValue = widget.aileronSource:value()
    end
    
    if widget.elevatorSource ~= nil then
        widget.elevatorValue = widget.elevatorSource:value()
    end
    
    if widget.rudderSource ~= nil then
        widget.rudderValue = widget.rudderSource:value()
    end
    
    if widget.autoRecoverySource ~= nil then
        widget.autoRecoveryValue = widget.autoRecoverySource:value()
    end
    
    -- Request screen refresh
    lcd.invalidate()
end

local function read(widget)
    -- Read stored configuration
    widget.aileronSource = storage.read("aileronSource")
    widget.elevatorSource = storage.read("elevatorSource")
    widget.rudderSource = storage.read("rudderSource")
    widget.autoRecoverySource = storage.read("autoRecoverySource")
    
    -- Read colors (use defaults if not stored)
    local savedNormalColor = storage.read("normalColor")
    if savedNormalColor ~= nil then widget.normalColor = savedNormalColor end
    
    local savedOffColor = storage.read("offColor")
    if savedOffColor ~= nil then widget.offColor = savedOffColor end
    
    local savedHeadingHoldColor = storage.read("headingHoldColor")
    if savedHeadingHoldColor ~= nil then widget.headingHoldColor = savedHeadingHoldColor end
    
    -- Read view mode
    local savedCompactView = storage.read("compactView")
    if savedCompactView ~= nil then widget.compactView = savedCompactView end
    
    return true
end

local function write(widget)
    -- Write configuration to storage
    storage.write("aileronSource", widget.aileronSource)
    storage.write("elevatorSource", widget.elevatorSource)
    storage.write("rudderSource", widget.rudderSource)
    storage.write("autoRecoverySource", widget.autoRecoverySource)
    
    -- Write colors
    storage.write("normalColor", widget.normalColor)
    storage.write("offColor", widget.offColor)
    storage.write("headingHoldColor", widget.headingHoldColor)
    
    -- Write view mode
    storage.write("compactView", widget.compactView)
    
    return true
end

local function init()
    -- System information
    system.registerWidget({
        key = "gya553",
        name = "GYA553 Status",
        create = create,
        configure = configure,
        paint = paint,
        wakeup = wakeup,
        read = read,
        write = write
    })
end

return { init = init }
