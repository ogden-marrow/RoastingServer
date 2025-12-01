# Visual Studio Setup Guide for RoastingServer

This guide will help you set up Visual Studio to build RoastingServer for Windows, Linux, and Raspberry Pi.

## Prerequisites

### Visual Studio Installation
Install **Visual Studio 2019** or **Visual Studio 2022** with the following workloads:
- **Desktop development with C++**
- **Linux development with C++** (for WSL/Linux builds)

### WSL2 Setup (for Linux/ARM builds)
1. Open PowerShell as Administrator and run:
```powershell
wsl --install
```

2. Restart your computer

3. Set up Ubuntu in WSL:
```powershell
wsl --install -d Ubuntu
```

4. Launch Ubuntu and create a user account

5. Inside WSL, run the setup script:
```bash
cd /mnt/c/Users/YourUsername/source/repos/RoastingServer
./setup-linux.sh
```

## Opening the Project in Visual Studio

### Method 1: Open CMake Project Directly
1. Launch Visual Studio
2. Select **File > Open > CMake...**
3. Navigate to the RoastingServer folder
4. Select `CMakeLists.txt` and click **Open**

### Method 2: Open Folder
1. Launch Visual Studio
2. Select **File > Open > Folder...**
3. Navigate to and select the RoastingServer folder
4. Click **Select Folder**

Visual Studio will automatically detect the CMake project and load all configurations.

## Building for Different Platforms

### Windows Builds

#### Using Configuration Dropdown
1. Click the configuration dropdown (usually shows "x64-Debug")
2. Select your desired configuration:
   - **x64-Debug** - Windows 64-bit Debug build
   - **x64-Release** - Windows 64-bit Release build
   - **x86-Debug** - Windows 32-bit Debug build
   - **x86-Release** - Windows 32-bit Release build
3. Press `Ctrl+Shift+B` or select **Build > Build All**

#### Output Location
Built executables will be in:
```
out/build/[configuration-name]/RoastingServer.exe
```

### Linux Builds (via WSL)

#### First-Time Setup
1. Make sure WSL is installed and configured
2. In Visual Studio, go to **Tools > Options > Cross Platform > Connection Manager**
3. Click **Add** to add a WSL connection
4. Select your WSL distribution
5. Click **Connect**

#### Building
1. Select a WSL configuration from the dropdown:
   - **WSL-GCC-Debug** - Linux Debug build via WSL
   - **WSL-GCC-Release** - Linux Release build via WSL
2. Press `Ctrl+Shift+B` to build

#### Output Location
Built executables will be in:
```
out/build/[configuration-name]/RoastingServer
```

### Raspberry Pi Cross-Compilation (via WSL)

#### Prerequisites
1. Ensure WSL is set up
2. Run the setup script in WSL to install ARM compilers:
```bash
./setup-linux.sh
```

#### Building
1. Select an ARM configuration from the dropdown:
   - **WSL-ARM-Pi-Zero-W-Release** - For Raspberry Pi Zero W (ARMv6)
   - **WSL-ARM-Pi-3-4-Release** - For Raspberry Pi 3/4 32-bit (ARMv7)
   - **WSL-ARM64-Pi-4-Release** - For Raspberry Pi 4 64-bit (ARM64)
2. Press `Ctrl+Shift+B` to build

#### Output Location
Built executables will be in:
```
out/build/[configuration-name]/RoastingServer
```

#### Deploying to Raspberry Pi
After building, you can deploy to your Pi using SCP from WSL:

1. Open WSL terminal in Visual Studio: **View > Terminal**
2. Navigate to the build output:
```bash
cd out/build/WSL-ARM-Pi-Zero-W-Release
```
3. Copy to Raspberry Pi:
```bash
scp RoastingServer pi@raspberrypi.local:~/
```
4. SSH to Pi and run:
```bash
ssh pi@raspberrypi.local
chmod +x ~/RoastingServer
./RoastingServer
```

## IntelliSense Configuration

Visual Studio should automatically configure IntelliSense for all platforms. If IntelliSense isn't working:

1. Right-click on `CMakeLists.txt` in Solution Explorer
2. Select **CMake Settings for RoastingServer**
3. Ensure the correct configuration is selected
4. Click **Save**

## Debugging

### Windows Debugging
1. Select a Windows configuration (x64-Debug or x86-Debug)
2. Set breakpoints in your code
3. Press `F5` or select **Debug > Start Debugging**

### WSL/Linux Debugging
1. Select a WSL configuration (WSL-GCC-Debug)
2. Set breakpoints in your code
3. Press `F5` or select **Debug > Start Debugging**
4. Visual Studio will automatically deploy and debug via WSL

### Remote Raspberry Pi Debugging (Advanced)
For debugging on actual Raspberry Pi hardware:

1. Install gdbserver on Raspberry Pi:
```bash
sudo apt-get install gdbserver
```

2. In Visual Studio, go to **Debug > Options > Cross Platform**
3. Add a new remote connection to your Raspberry Pi
4. Configure remote debugging settings

## CMake Configuration

### Viewing CMake Output
- Open **View > Output**
- Select **CMake** from the "Show output from:" dropdown
- This shows CMake configuration and build logs

### Modifying CMake Settings
1. Right-click `CMakeLists.txt` in Solution Explorer
2. Select **CMake Settings for RoastingServer**
3. Modify settings as needed
4. Save (changes auto-apply)

### Adding Custom CMake Arguments
In CMake Settings, you can add custom arguments:
```json
"cmakeCommandArgs": "-DCUSTOM_OPTION=ON"
```

## Switching Between Configurations Quickly

### Keyboard Shortcuts
- `Ctrl+Shift+Alt+C` - Open CMake Settings
- `Ctrl+Shift+B` - Build
- `F5` - Start Debugging
- `Ctrl+F5` - Start Without Debugging

### Configuration Toolbar
The configuration dropdown is in the main toolbar. You can quickly switch between:
- Windows builds (x64/x86, Debug/Release)
- WSL builds (Debug/Release)
- ARM cross-compilation builds (Pi Zero W, Pi 3/4, Pi 4 64-bit)

## Troubleshooting

### "CMake generation failed"
1. Check **View > Output > CMake** for error details
2. Ensure all prerequisites are installed
3. Try **Project > Delete Cache and Reconfigure**

### "WSL connection failed"
1. Ensure WSL is running: `wsl --status` in PowerShell
2. Verify WSL connection in **Tools > Options > Cross Platform > Connection Manager**
3. Try removing and re-adding the WSL connection

### "ARM compiler not found"
1. Open WSL terminal
2. Run the setup script again:
```bash
./setup-linux.sh
```
3. Restart Visual Studio

### IntelliSense shows errors but code compiles
1. Right-click project in Solution Explorer
2. Select **Rescan Solution**
3. Or select **Project > Delete Cache and Reconfigure**

### Build output not showing
1. Go to **View > Output**
2. In the dropdown, select **Build**
3. Ensure verbosity is set to at least "Normal" in **Tools > Options > Projects and Solutions > Build and Run**

## Tips for Productive Development

### Multiple Configuration Windows
You can have multiple Visual Studio windows open with different configurations:
1. Open the project
2. Select a configuration
3. Start a new instance: **File > New Instance**
4. Select a different configuration in the new window

### Quick Configuration Switching
Create a custom toolbar button for switching configurations:
1. **Tools > Customize**
2. **Commands** tab
3. Add "CMake Target Architecture" and "CMake Configuration" dropdowns

### Parallel Builds
Speed up builds by increasing parallel jobs:
1. **Tools > Options > Projects and Solutions > Build and Run**
2. Set "maximum number of parallel project builds" to match your CPU cores

### Remote File Editing
When working with WSL/Linux files:
- Files are automatically synced to WSL
- Changes in either Windows or WSL are reflected immediately
- Use **View > Terminal** to access WSL command line

## Next Steps

After setup:
1. Build the project for your target platform
2. Run the executable to verify it works
3. Start developing your application features
4. Set up GitHub Actions for CI/CD (already configured!)

For more details on building and deploying, see the main [README.md](README.md).
