# RoastingServer

A cross-platform C++ application with support for Windows, Linux, and Raspberry Pi platforms.

## Supported Platforms

- **Windows**: x86, x64
- **Linux**: x64, WSL
- **Raspberry Pi**:
  - Pi Zero W (ARMv6)
  - Pi 3/4 32-bit (ARMv7)
  - Pi 4 64-bit (ARM64/AArch64)

## Prerequisites

### Windows (Visual Studio)
- Visual Studio 2019 or later with:
  - Desktop development with C++
  - CMake tools for Windows
  - Linux development with C++ (for WSL/Linux builds)
- Optional: WSL2 for Linux builds

### Linux/WSL (for cross-compilation)
```bash
# Install build tools
sudo apt-get update
sudo apt-get install -y cmake ninja-build g++

# Install ARM cross-compilers (for Raspberry Pi builds)
sudo apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf  # For ARMv6/ARMv7
sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu      # For ARM64
```

### Raspberry Pi (native build)
```bash
sudo apt-get update
sudo apt-get install -y cmake g++ ninja-build
```

## Building in Visual Studio

### Windows Build
1. Open Visual Studio
2. Select **File > Open > CMake** and open `CMakeLists.txt`
3. In the configuration dropdown, select:
   - `x64-debug` or `x64-release` for 64-bit builds
   - `x86-debug` or `x86-release` for 32-bit builds
4. Build with **Build > Build All** or press `Ctrl+Shift+B`

### Linux Build (via WSL)
1. Install WSL2 and a Linux distribution (Ubuntu recommended)
2. In Visual Studio, select **File > Open > CMake**
3. In the configuration dropdown, select:
   - `wsl-debug` or `wsl-release`
   - `linux-debug` or `linux-release` (for remote Linux)
4. Visual Studio will automatically sync to WSL and build

### Raspberry Pi Cross-Compilation (from WSL/Linux)
1. Open the project in Visual Studio
2. Ensure WSL has the ARM cross-compilers installed
3. Select one of the ARM configurations:
   - `arm-pi-zero-debug` / `arm-pi-zero-release` - For Pi Zero W
   - `arm-pi3-4-debug` / `arm-pi3-4-release` - For Pi 3/4 32-bit
   - `arm64-pi-debug` / `arm64-pi-release` - For Pi 4 64-bit
4. Build with **Build > Build All**

The compiled binary will be in the `out/build/[configuration-name]/` directory.

## Manual Building (Command Line)

### Windows
```cmd
# Configure
cmake --preset x64-release

# Build
cmake --build out/build/x64-release
```

### Linux/WSL
```bash
# Configure for native Linux
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release

# Build
cmake --build build

# Run
./build/RoastingServer
```

### Cross-compile for Raspberry Pi (from Linux/WSL)
```bash
# For Pi Zero W (ARMv6)
cmake --preset arm-pi-zero-release
cmake --build out/build/arm-pi-zero-release

# For Pi 3/4 32-bit (ARMv7)
cmake --preset arm-pi3-4-release
cmake --build out/build/arm-pi3-4-release

# For Pi 4 64-bit (ARM64)
cmake --preset arm64-pi-release
cmake --build out/build/arm64-pi-release
```

### Deploy to Raspberry Pi
```bash
# Transfer the binary
scp out/build/arm-pi-zero-release/RoastingServer pi@raspberrypi.local:~/

# SSH to Pi and run
ssh pi@raspberrypi.local
chmod +x ~/RoastingServer
./RoastingServer
```

## GitHub Actions CI/CD

This project includes automated builds for all platforms via GitHub Actions.

### Automatic Builds
Every push to `main` or `develop` branches triggers builds for:
- Windows (x86 & x64, Debug & Release)
- Linux x64 (Debug & Release)
- Raspberry Pi (Zero W, 3/4 32-bit, 4 64-bit)

### Creating a Release
To create a release with pre-built binaries:
```bash
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

GitHub Actions will automatically build all platforms and create a release with downloadable binaries.

### Downloading Build Artifacts
1. Go to the **Actions** tab in your GitHub repository
2. Click on the latest workflow run
3. Scroll down to **Artifacts** section
4. Download the platform-specific build you need

## Visual Studio Tips

### Viewing All Configurations
- Go to **Tools > Options > CMake > General**
- Enable "Show advanced CMake settings"
- All presets will be visible in the configuration dropdown

### Remote Linux Debugging
1. Set up SSH keys to your remote Linux machine or WSL
2. In Visual Studio, go to **Tools > Options > Cross Platform > Connection Manager**
3. Add a new connection to your Linux system
4. Select a Linux configuration and debug normally

### Switching Between Configurations Quickly
- Use the configuration dropdown in the toolbar
- Or use **Ctrl+Shift+Alt+C** to open configuration settings

## Troubleshooting

### "ARM compiler not found" error
Ensure you've installed the cross-compilers:
```bash
sudo apt-get install gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf
sudo apt-get install gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
```

### Visual Studio doesn't show ARM configurations
ARM presets are only available when running on Linux (WSL or remote). Make sure you're using a Linux configuration or WSL.

### WSL builds fail
Ensure CMake and Ninja are installed in WSL:
```bash
sudo apt-get install cmake ninja-build
```

## Project Structure
```
RoastingServer/
├── .github/
│   └── workflows/
│       └── build.yml          # GitHub Actions CI/CD
├── cmake/
│   ├── toolchain-armv6.cmake  # Pi Zero W toolchain
│   ├── toolchain-armv7.cmake  # Pi 3/4 32-bit toolchain
│   └── toolchain-aarch64.cmake # Pi 4 64-bit toolchain
├── CMakeLists.txt             # Main CMake configuration
├── CMakePresets.json          # CMake presets for all platforms
├── RoastingServer.cpp         # Main source file
└── RoastingServer.h           # Header file
```

## License
[Add your license here]
