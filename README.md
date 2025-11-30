# RoastingServer

A .NET 8 web API server with example endpoints and interactive web interface.

## Features

- ASP.NET Core 8.0 Web API
- Swagger/OpenAPI documentation
- Interactive web dashboard
- Multi-platform support (Linux x64, ARM, ARM64, ARMv6)
- Weather forecast demo API

## Supported Platforms

| Platform | Architecture | Example Devices |
|----------|-------------|-----------------|
| `linux-x64` | x86_64 | Standard Linux PCs, servers, VPS |
| `linux-arm` | ARMv7 32-bit | Raspberry Pi 2/3/4 (32-bit OS) |
| `linux-arm64` | ARMv8 64-bit | Raspberry Pi 3/4/5 (64-bit OS) |
| `linux-armel` | ARMv6 | Raspberry Pi Zero W, Pi 1 |

## Quick Start

### Installation

1. **Download the release for your platform** from the [Releases page](https://github.com/ogden-marrow/RoastingServer/releases)

2. **Extract the archive:**
   ```bash
   tar -xzf RoastingServer-linux-*.tar.gz
   ```

3. **Make the binary executable:**
   ```bash
   chmod +x RoastingServer
   ```

4. **Run the server:**
   ```bash
   ./RoastingServer
   ```

5. **Access the server:**
   - Web Interface: http://localhost:5043
   - Swagger API Docs: http://localhost:5043/swagger
   - Weather API: http://localhost:5043/weatherforecast

### Determining Your Platform

If you're unsure which version to download:

```bash
# Check your architecture
uname -m

# Detailed CPU info
lscpu
```

**Results guide:**
- `x86_64` or `amd64` → Use `linux-x64`
- `armv7l` → Use `linux-arm`
- `aarch64` or `arm64` → Use `linux-arm64`
- `armv6l` → Use `linux-armel`

## Running as a System Service

To run RoastingServer automatically on boot using systemd:

### 1. Create service file

```bash
sudo nano /etc/systemd/system/roasting-server.service
```

### 2. Add service configuration

```ini
[Unit]
Description=Roasting Server
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/home/deploy/RoastingServer
ExecStart=/home/deploy/RoastingServer/RoastingServer
Restart=on-failure
RestartSec=10
KillMode=process

# Optional: Resource limits for low-memory devices
MemoryMax=256M
CPUQuota=50%

[Install]
WantedBy=multi-user.target
```

**Note:** Adjust `User`, `WorkingDirectory`, and `ExecStart` paths to match your installation.

### 3. Enable and start the service

```bash
# Reload systemd to read the new service file
sudo systemctl daemon-reload

# Enable the service to start on boot
sudo systemctl enable roasting-server

# Start the service now
sudo systemctl start roasting-server

# Check the service status
sudo systemctl status roasting-server
```

### 4. Manage the service

```bash
# Stop the service
sudo systemctl stop roasting-server

# Restart the service
sudo systemctl restart roasting-server

# View logs
sudo journalctl -u roasting-server -f

# View recent logs
sudo journalctl -u roasting-server -n 50
```

## Development

### Prerequisites

- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- Git

### Clone and build

```bash
git clone https://github.com/ogden-marrow/RoastingServer.git
cd RoastingServer
dotnet restore
dotnet build
```

### Run locally

```bash
dotnet run
```

The server will start at http://localhost:5043

### Run tests

```bash
dotnet test
```

## API Endpoints

### Weather Forecast
- **GET** `/weatherforecast`
- Returns a 5-day weather forecast with random data
- Example: http://localhost:5043/weatherforecast

### Swagger Documentation
- **GET** `/swagger`
- Interactive API documentation
- Example: http://localhost:5043/swagger

## Configuration

### Port Configuration

To change the default port (5043), edit `Properties/launchSettings.json` or set the `ASPNETCORE_URLS` environment variable:

```bash
export ASPNETCORE_URLS="http://localhost:8080"
./RoastingServer
```

Or when using systemd, add to the service file:

```ini
[Service]
Environment="ASPNETCORE_URLS=http://localhost:8080"
```

### Logging

Logging can be configured in `appsettings.json`:

```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```

## Building from Source

### Single-file executable

```bash
dotnet publish \
  --configuration Release \
  --runtime linux-x64 \
  --self-contained true \
  -p:PublishSingleFile=true \
  -p:PublishTrimmed=true \
  --output ./publish
```

Replace `linux-x64` with your target platform:
- `linux-x64` - Standard Linux
- `linux-arm` - ARMv7 (Raspberry Pi 2/3/4)
- `linux-arm64` - ARMv8 (Raspberry Pi 3/4/5 64-bit)
- `linux-armel` - ARMv6 (Raspberry Pi Zero W, Pi 1)

## Troubleshooting

### "Illegal instruction" error

This typically means you downloaded the wrong architecture. Use `lscpu` to check your CPU architecture and download the correct version.

For Raspberry Pi Zero W specifically, you need the `linux-armel` version.

### Port already in use

If port 5043 is already in use:

```bash
# Find what's using the port
sudo lsof -i :5043

# Or use a different port
export ASPNETCORE_URLS="http://localhost:8080"
./RoastingServer
```

### Permission denied

Make sure the binary is executable:

```bash
chmod +x RoastingServer
```

### Low memory devices (Raspberry Pi Zero W)

For devices with limited memory, consider:

1. Limit memory in systemd (shown in service file example above)
2. Reduce logging verbosity
3. Monitor with: `systemctl status roasting-server`

## Project Structure

```
RoastingServer/
├── Controllers/
│   └── WeatherForecastController.cs  # API endpoints
├── Properties/
│   └── launchSettings.json            # Development settings
├── wwwroot/
│   └── Index.html                     # Web interface
├── Program.cs                         # Application entry point
├── WeatherForecast.cs                 # Data model
├── appsettings.json                   # App configuration
└── RoastingServer.csproj              # Project file
```

## License

MIT License - see LICENSE.txt for details

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

For issues and questions, please use the [GitHub Issues](https://github.com/ogden-marrow/RoastingServer/issues) page.