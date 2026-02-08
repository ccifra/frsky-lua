# Futaba GYA553 Gyro Support

This directory contains Lua scripts for controlling and monitoring the Futaba GYA553 gyro system with FRSky Ethos radios.

## Overview

The GYA553 gyro requires specific gain channel values to control:
- **Mode** - Off, Normal, or Heading Hold
- **Gain Percentage** - 0-100% sensitivity

These scripts provide:
1. **Gain Sources** (`gya553-gains/`) - Calculate the correct gain channel values based on a variable input
2. **Status Widget** (`gya553-status/`) - Display current gyro mode and gain percentages on your radio screen

## Setup Guide

### Step 1: Create a Global Variable for Gain Control

Before using the sources, create a Variable (Vars) in your model to control the gain rate:

1. Go to **Model Setup** → **GVARs**
2. Create a new variable (e.g., "Gyro Gain"), You can create a gain per axis or use a single gain for all axes.
3. Set the range to 0-100%
4. Set the gain to use, 50% is a good starting point
4. Optionally assign actions to increment and decrement the gain in flight

This variable will be the input to the gain sources, allowing you to adjust gyro sensitivity on the fly.

### Step 2: Install the Gain Sources

Copy the `gya553-gains/` directory to your radio's `/scripts/` folder. This registers three custom sources that you can use in your mixer:

- **GYA553 Ail Gain** - Aileron gain channel value
- **GYA553 Ele Gain** - Elevator gain channel value  
- **GYA553 Rud Gain** - Rudder gain channel value

### Step 3: Enable and Configure Each Source

Each source must be enabled in the Lua section of Model Setup before it can be used:

1. Go to **Model Setup** → **Lua**
2. Find the **GYA553 Gains** script in the list
3. You'll see three sources available to enable:
   - **GYA553 Ail Gain** - Aileron gain channel value
   - **GYA553 Ele Gain** - Elevator gain channel value
   - **GYA553 Rud Gain** - Rudder gain channel value
4. Enable each source you want to use by checking the checkbox
5. Tap on each enabled source to configure its settings

#### Source Configuration Options

| Option | Description |
|--------|-------------|
| **Gain Input** | The source for gain percentage. Use the Var that you added or a pot, slider, or any other source. The value is normalized from the source's min/max range. |
| **Mode** | Controls which gyro mode is active: |
| | • **Off** - Gyro disabled (outputs 0) |
| | • **Normal** - Standard rate gyro mode |
| | • **Heading Hold** - Heading lock mode |
| | • **Switched** - Mode determined by switch positions |
| **Normal Switch** | (Switched mode only) Select a switch position source (e.g., SA↑, SB-). When this switch is active (>0), Normal mode is used. |
| **Heading Hold Switch** | (Switched mode only) Select a switch position source. When active, Heading Hold mode is used. If both switches are off, the gyro is disabled. |

#### Gain Calculation

The sources automatically calculate the correct output value for the GYA553:
- **Normal mode**: Negative output signal
- **Heading Hold mode**: Positive output signal
- **Off mode**: Zero output

### Step 4: Add Sources to Your Mixer

1. Go to **Model Setup** → **Mixes**
2. For each gyro gain channel (typically CH5, CH6, CH7 for Ail/Ele/Rud):
3. Add the corresponding GYA553 source as the input

### Step 5: Install the Status Widget

Copy the `gya553-status/` directory to your radio's `/scripts/` folder to add the status widget.

### Step 6: Add Widget to Your Screen

1. Go to **Display** → **Main Views**
2. Add a new widget and select **GYA553 Status**
3. Configure the widget options

#### Widget Configuration Options

| Option | Description |
|--------|-------------|
| **Aileron Gain** | Source to monitor for aileron gain channel value |
| **Elevator Gain** | Source to monitor for elevator gain channel value |
| **Rudder Gain** | Source to monitor for rudder gain channel value |
| **Auto Recovery** | Source for auto recovery status (optional) |
| **Normal Color** | Color for Normal mode indicator (default: green) |
| **Off Color** | Color for Off mode indicator (default: gray) |
| **Heading Hold Color** | Color for Heading Hold mode indicator (default: blue) |
| **Compact View** | Toggle between full and compact display modes |

#### Widget Display

The widget shows for each configured axis:
- **Mode** - Current mode with color-coded background
- **Gain %** - Current gain percentage (0-100%)
- **Auto Recovery** - On/Off status if configured

The widget automatically adapts to dark/light themes.

## Directory Structure

```
gya553/
├── gya553-gains/
│   └── main.lua      # Registers GYA553 gain sources
├── gya553-status/
│   └── main.lua      # GYA553 status widget
├── deploy.sh         # Deployment script for Ethos simulator
└── README.md         # This file
```

## Deployment

Use the included deployment script to copy files to the Ethos Suite simulator:

```bash
./deploy.sh
```

## Example Configuration

Here's a typical setup for a helicopter with GYA553:

1. **Global Variable**: Create "Gyro Gain" GV controlled by a slider
2. **Gain Sources**: Configure all three axes with:
   - Gain Input: Gyro Gain GV
   - Mode: Switched
   - Normal Switch: SA↓
   - Heading Hold Switch: SA↑
3. **Mixer**: 
   - CH5 = GYA553 Ail Gain
   - CH6 = GYA553 Ele Gain
   - CH7 = GYA553 Rud Gain
4. **Widget**: Add to main screen, configure sources to match mixer channels

This gives you:
- SA up = Heading Hold mode
- SA middle = Gyro off
- SA down = Normal mode
- Slider = Adjusts gain percentage in any mode
