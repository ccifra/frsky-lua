# FRSky Ethos Lua Scripts

Collection of Lua scripts for FRSky Ethos radio systems, including widgets and function scripts for gyro control and monitoring.

## Components

### GYA553 Status Widget
A telemetry widget that displays real-time status of the FRSky GYA553 gyro system.

**Features:**
- Live channel monitoring for aileron, elevator, and rudder
- Mode detection (Off, Normal, Heading Hold)
- Visual color coding for different modes
- Auto recovery monitoring
- Compact and full view modes
- Dark mode support
- Configurable colors

**Installation:**
1. Copy `GYA553Status/` directory to your radio's `/scripts/` folder
2. Add the widget to your screen layout

### GYA553 Gain Calculator
Function scripts that register custom sources for calculating gyro gain values.

**Features:**
- Three independent sources: GYA Aileron, GYA Elevator, GYA Rudder
- Configurable input source (typically a Global Variable or channel)
- Dual mode control options:
  - Boolean mode: Simple checkbox to activate
  - Switch mode: Assign a switch source
- Separate control for Normal mode and Heading Hold mode
- Automatic gain calculation:
  - Normal mode: `(input * -0.6) + 50`
  - Heading Hold mode: `(input * 0.6) + 50`
  - Off mode: `50`

**Installation:**
1. Copy `functions/gya553Gains.lua` to your radio's `/scripts/` folder
2. Configure each source with:
   - Gain input source
   - Mode type selection (Boolean or Switch)
   - Mode activation method
3. Use the registered sources in your mixer

**Usage:**
The calculated gain values can be used directly in mixer inputs for controlling the GYA553 gyro gain channels.

## Development

### Directory Structure
```
frsky-lua/
├── GYA553Status/        # Status widget
│   ├── main.lua         # Widget implementation
│   └── deploy.sh        # Deployment script
└── functions/           # Function scripts
    ├── gya553Gains.lua  # Gain calculator
    └── deploy.sh        # Deployment script
```

### Requirements
- FRSky Ethos v1.6.3 or later
- X20 series radio (tested on X20PROAW)

### Deployment Scripts
Each component includes a `deploy.sh` script for easy deployment to the Ethos Suite simulator:
```bash
cd GYA553Status  # or functions
./deploy.sh
```

## License

MIT License - see [LICENSE](LICENSE) file for details

## Author

Christopher Cifra

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
