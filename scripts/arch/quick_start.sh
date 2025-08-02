#!/bin/bash

# 🎵 Arch Linux Music OS - Quick Start Guide
# This script provides platform-specific setup instructions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Show platform selection menu
show_platform_menu() {
    echo ""
    echo "🎵 Arch Linux Music OS - Platform Selection"
    echo "=========================================="
    echo ""
    echo "Choose your target platform:"
    echo ""
    echo "1) x86 PC (Intel/AMD desktop/laptop)"
    echo "2) Raspberry Pi 4/5 (ARM64)"
    echo "3) Raspberry Pi 3 (ARM32)"
    echo "4) Virtual Machine (for testing)"
    echo "5) Generic ARM64 device"
    echo "6) Show all instructions"
    echo ""
    echo "Enter your choice (1-6): "
    read -r choice
}

# x86 PC setup
setup_x86() {
    log "Setting up for x86 PC..."
    
    echo ""
    echo "📋 x86 PC Setup Instructions"
    echo "============================"
    echo ""
    echo "1. Download Arch Linux ISO:"
    echo "   https://archlinux.org/download/"
    echo ""
    echo "2. Create bootable USB:"
    echo "   # On Linux:"
    echo "   sudo dd if=archlinux-*.iso of=/dev/sdX bs=4M status=progress"
    echo "   # On Windows: Use Rufus or similar tool"
    echo ""
    echo "3. Boot from USB and install Arch:"
    echo "   # Use archinstall for automated setup:"
    echo "   archinstall"
    echo ""
    echo "4. After installation, run the setup script:"
    echo "   sudo ./scripts/arch_setup.sh"
    echo ""
    echo "5. Reboot and enjoy your music OS!"
    echo ""
}

# Raspberry Pi setup
setup_raspberry_pi() {
    log "Setting up for Raspberry Pi..."
    
    echo ""
    echo "📋 Raspberry Pi Setup Instructions"
    echo "================================="
    echo ""
    echo "1. Download Arch Linux ARM:"
    echo "   https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4"
    echo ""
    echo "2. Flash to SD card:"
    echo "   sudo dd if=ArchLinuxARM-rpi-4-aarch64-latest.tar.gz of=/dev/sdX bs=4M status=progress"
    echo ""
    echo "3. Boot Pi and expand filesystem:"
    echo "   sudo pacman -Syu"
    echo "   sudo pacman -S base-devel git"
    echo ""
    echo "4. Clone this repository:"
    echo "   git clone https://github.com/your-repo/music-os.git"
    echo "   cd music-os"
    echo ""
    echo "5. Run the setup script:"
    echo "   sudo ./scripts/arch_setup.sh"
    echo ""
    echo "6. Reboot and enjoy!"
    echo ""
}

# Virtual Machine setup
setup_vm() {
    log "Setting up for Virtual Machine..."
    
    echo ""
    echo "📋 Virtual Machine Setup Instructions"
    echo "===================================="
    echo ""
    echo "1. Download Arch Linux ISO:"
    echo "   https://archlinux.org/download/"
    echo ""
    echo "2. Create new VM in your hypervisor:"
    echo "   - VMware Workstation/Player"
    echo "   - VirtualBox"
    echo "   - QEMU/KVM"
    echo ""
    echo "3. VM Settings:"
    echo "   - RAM: 2GB minimum, 4GB recommended"
    echo "   - CPU: 2 cores minimum"
    echo "   - Storage: 20GB minimum"
    echo "   - Network: Bridged or NAT"
    echo ""
    echo "4. Boot from ISO and install:"
    echo "   archinstall"
    echo ""
    echo "5. Run setup script:"
    echo "   sudo ./scripts/arch_setup.sh"
    echo ""
    echo "6. Install VMware Tools (if using VMware):"
    echo "   sudo pacman -S open-vm-tools"
    echo "   sudo systemctl enable vmtoolsd"
    echo ""
}

# Generic ARM64 setup
setup_generic_arm64() {
    log "Setting up for Generic ARM64..."
    
    echo ""
    echo "📋 Generic ARM64 Setup Instructions"
    echo "==================================="
    echo ""
    echo "1. Download Arch Linux ARM for your device:"
    echo "   https://archlinuxarm.org/platforms"
    echo ""
    echo "2. Follow device-specific instructions"
    echo ""
    echo "3. Install base system and development tools:"
    echo "   sudo pacman -Syu"
    echo "   sudo pacman -S base-devel git"
    echo ""
    echo "4. Clone and setup:"
    echo "   git clone https://github.com/your-repo/music-os.git"
    echo "   cd music-os"
    echo "   sudo ./scripts/arch_setup.sh"
    echo ""
}

# Show all instructions
show_all_instructions() {
    echo ""
    echo "📋 Complete Setup Instructions"
    echo "============================="
    echo ""
    
    setup_x86
    echo ""
    echo "----------------------------------------"
    echo ""
    setup_raspberry_pi
    echo ""
    echo "----------------------------------------"
    echo ""
    setup_vm
    echo ""
    echo "----------------------------------------"
    echo ""
    setup_generic_arm64
}

# Create development environment setup
create_dev_environment() {
    log "Creating development environment setup..."
    
    cat > scripts/dev_setup.sh << 'EOF'
#!/bin/bash
# Development Environment Setup

echo "🔧 Setting up development environment..."

# Install development tools
sudo pacman -S --noconfirm \
    base-devel \
    git \
    vim \
    htop \
    python-pip \
    python-virtualenv

# Install yay (AUR helper)
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

# Install additional development packages
yay -S --noconfirm \
    librespot-bin \
    python-mutagen \
    python-requests

echo "✅ Development environment ready!"
echo ""
echo "Next steps:"
echo "1. Run: sudo ./scripts/arch_setup.sh"
echo "2. Test the music player"
echo "3. Customize the interface"
EOF

    chmod +x scripts/dev_setup.sh
}

# Create testing script
create_test_script() {
    log "Creating testing script..."
    
    cat > scripts/test_system.sh << 'EOF'
#!/bin/bash
# System Testing Script

echo "🧪 Testing Music OS System..."

# Test audio
echo "Testing audio system..."
if command -v aplay &> /dev/null; then
    echo "✅ ALSA found"
else
    echo "❌ ALSA not found"
fi

# Test MPD
echo "Testing MPD..."
if systemctl is-active --quiet mpd; then
    echo "✅ MPD is running"
else
    echo "❌ MPD is not running"
fi

# Test Python
echo "Testing Python..."
if python3 -c "import tkinter; print('✅ Tkinter available')" 2>/dev/null; then
    echo "✅ Python GUI ready"
else
    echo "❌ Python GUI not ready"
fi

# Test network
echo "Testing network..."
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo "✅ Network connectivity"
else
    echo "❌ No network connectivity"
fi

# Test SSH
echo "Testing SSH..."
if systemctl is-active --quiet sshd; then
    echo "✅ SSH server running"
else
    echo "❌ SSH server not running"
fi

echo ""
echo "🎵 System test complete!"
EOF

    chmod +x scripts/test_system.sh
}

# Main function
main() {
    echo ""
    echo "🎵 Arch Linux Music OS - Quick Start"
    echo "==================================="
    echo ""
    echo "This script will help you set up your music OS"
    echo "for your specific platform."
    echo ""
    
    show_platform_menu
    
    case $choice in
        1)
            setup_x86
            ;;
        2|3)
            setup_raspberry_pi
            ;;
        4)
            setup_vm
            ;;
        5)
            setup_generic_arm64
            ;;
        6)
            show_all_instructions
            ;;
        *)
            error "Invalid choice. Please run the script again."
            ;;
    esac
    
    echo ""
    echo "🔧 Additional Setup Options:"
    echo ""
    echo "Create development environment:"
    echo "  ./scripts/dev_setup.sh"
    echo ""
    echo "Test the system:"
    echo "  ./scripts/test_system.sh"
    echo ""
    echo "📚 Documentation:"
    echo "  - README.md - Main documentation"
    echo "  - ARCH_SETUP.md - Detailed setup guide"
    echo "  - docs/ - Additional documentation"
    echo ""
    echo "🎯 Next Steps:"
    echo "1. Follow the platform-specific instructions above"
    echo "2. Run the setup script: sudo ./scripts/arch_setup.sh"
    echo "3. Test the system: ./scripts/test_system.sh"
    echo "4. Add music files to ~/Music directory"
    echo "5. Enjoy your custom music OS!"
    echo ""
}

# Create additional scripts
create_dev_environment
create_test_script

# Run main function
main 