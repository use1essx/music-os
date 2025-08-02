#!/bin/bash

# 🐧 Arch Linux Setup Script for Custom Music OS
# This script sets up Arch Linux to build our Custom Music OS

set -e  # Exit on any error

echo "🎵 Setting up Arch Linux for Custom Music OS Build..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Check if we're on Arch Linux
if ! grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
    print_warning "This script is designed for Arch Linux"
    print_warning "You're running: $(cat /etc/os-release | grep PRETTY_NAME)"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

print_status "Updating system packages..."
sudo pacman -Syu --noconfirm

print_status "Installing essential build tools..."
sudo pacman -S --noconfirm base-devel git wget

print_status "Installing Buildroot dependencies..."
sudo pacman -S --noconfirm ncurses

print_status "Installing Python and GUI dependencies..."
sudo pacman -S --noconfirm python python-pip python-pillow python-mutagen

print_status "Installing audio/video tools..."
sudo pacman -S --noconfirm mpv ffmpeg yt-dlp

print_status "Installing development tools..."
sudo pacman -S --noconfirm gcc make cmake

print_status "Installing optional GUI for testing..."
sudo pacman -S --noconfirm xorg-server xorg-xinit openbox

print_status "Setting up build environment..."

# Create build directory
mkdir -p ~/build
cd ~/build

# Download Buildroot if not already present
if [ ! -d "buildroot-2024.02" ]; then
    print_status "Downloading Buildroot..."
    wget https://buildroot.org/downloads/buildroot-2024.02.tar.gz
    tar -xzf buildroot-2024.02.tar.gz
    rm buildroot-2024.02.tar.gz
fi

cd buildroot-2024.02

# Clone our project if not present
if [ ! -d "../music-os" ]; then
    print_status "Cloning music-os project..."
    cd ..
    git clone https://github.com/use1essx/music-os.git
    cd buildroot-2024.02
fi

# Copy our configurations
print_status "Setting up configurations..."
cp ../music-os/configs/*_defconfig configs/ 2>/dev/null || print_warning "No defconfig files found"
cp -r ../music-os/overlay/* overlay/ 2>/dev/null || print_warning "No overlay files found"
cp ../music-os/scripts/* scripts/ 2>/dev/null || print_warning "No script files found"

print_success "Arch Linux setup complete!"

echo
echo "🎵 Next steps:"
echo "1. Build for x86 (testing):"
echo "   cd ~/build/buildroot-2024.02"
echo "   make x86_64_defconfig"
echo "   make -j\$(nproc)"
echo
echo "2. Build for Raspberry Pi 5:"
echo "   make raspberrypi5_defconfig"
echo "   make -j\$(nproc)"
echo
echo "3. Test in QEMU:"
echo "   qemu-system-x86_64 -kernel output/images/bzImage -initrd output/images/rootfs.cpio.gz -append \"console=ttyS0\" -nographic"
echo
echo "📖 For more details, see: docs/ARCH_SETUP.md"
echo
print_success "Ready to build your Custom Music OS! 🎵✨" 