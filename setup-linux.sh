#!/bin/bash
# Setup script for RoastingServer cross-compilation toolchain
# Run this in WSL or Linux to install necessary build tools

set -e

echo "=========================================="
echo "RoastingServer Build Environment Setup"
echo "=========================================="
echo ""

# Detect OS
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VER=$VERSION_ID
else
    echo "Cannot detect OS. Please install dependencies manually."
    exit 1
fi

echo "Detected OS: $OS $VER"
echo ""

# Update package list
echo "Updating package list..."
sudo apt-get update

# Install base build tools
echo ""
echo "Installing base build tools..."
sudo apt-get install -y \
    build-essential \
    cmake \
    ninja-build \
    git

echo "✓ Base build tools installed"

# Ask about ARM cross-compilers
echo ""
read -p "Install ARM cross-compilers for Raspberry Pi? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Installing ARM cross-compilers..."
    
    # ARMv6/ARMv7 (32-bit)
    sudo apt-get install -y \
        gcc-arm-linux-gnueabihf \
        g++-arm-linux-gnueabihf \
        binutils-arm-linux-gnueabihf
    
    echo "✓ ARM 32-bit cross-compiler installed (for Pi Zero W, Pi 3/4)"
    
    # ARM64 (64-bit)
    sudo apt-get install -y \
        gcc-aarch64-linux-gnu \
        g++-aarch64-linux-gnu \
        binutils-aarch64-linux-gnu
    
    echo "✓ ARM 64-bit cross-compiler installed (for Pi 4)"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "You can now build the project:"
echo ""
echo "For native Linux:"
echo "  cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release"
echo "  cmake --build build"
echo ""
echo "For Raspberry Pi Zero W:"
echo "  cmake --preset arm-pi-zero-release"
echo "  cmake --build out/build/arm-pi-zero-release"
echo ""
echo "For Raspberry Pi 3/4 (32-bit):"
echo "  cmake --preset arm-pi3-4-release"
echo "  cmake --build out/build/arm-pi3-4-release"
echo ""
echo "For Raspberry Pi 4 (64-bit):"
echo "  cmake --preset arm64-pi-release"
echo "  cmake --build out/build/arm64-pi-release"
echo ""
