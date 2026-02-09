# FRSky Ethos Lua Scripts

Collection of Lua scripts for FRSky Ethos radio systems, including widgets and function scripts for gyro control and monitoring.

## Directory Structure

```
frsky-lua/
├── gya553/              # Futaba GYA553 Gyro support
│   ├── gya553-gains/    # Source scripts for gain calculation
│   │   └── main.lua
│   ├── gya553-status/   # Widget for status display
│   │   └── main.lua
│   ├── deploy.sh        # Deployment script
│   └── README.md        # Detailed GYA553 documentation
└── README.md            # This file
```

## Components

### [gya553/](gya553/) - Futaba GYA553 Gyro Support

Scripts for controlling and monitoring the Futaba GYA553 gyro system. Includes:
- **Gain Sources** - Custom sources that calculate gain values based on a variable input
- **Status Widget** - Real-time display of gyro mode and gain percentages

See the [gya553/README.md](gya553/README.md) for detailed setup and configuration instructions.

## Requirements

- Systems with FRSky Ethos v1.6.3 or later
- I test on an X20 series radio (X20PROAW)

## License

MIT License - see [LICENSE](LICENSE) file for details

## Author

Christopher Cifra

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
