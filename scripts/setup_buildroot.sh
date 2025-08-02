#!/bin/bash

# Custom Music OS - Buildroot Setup Script
# This script downloads and configures Buildroot for our Music OS

set -e  # Exit on any error

echo "🎵 Setting up Buildroot for Custom Music OS..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the right directory
if [ ! -f "README.md" ] || [ ! -d "configs" ]; then
    echo -e "${RED}❌ Error: Please run this script from the project root directory${NC}"
    exit 1
fi

# Check system requirements
echo -e "${BLUE}🔍 Checking system requirements...${NC}"

# Check for required packages
REQUIRED_PACKAGES="build-essential git wget cpio unzip rsync bc libncurses5-dev libssl-dev libc6-dev bison flex libelf-dev libdwarf-dev"

echo "Installing required packages..."
sudo apt-get update
sudo apt-get install -y $REQUIRED_PACKAGES

# Check available disk space (need at least 10GB)
AVAILABLE_SPACE=$(df . | awk 'NR==2 {print $4}')
if [ $AVAILABLE_SPACE -lt 10485760 ]; then  # 10GB in KB
    echo -e "${YELLOW}⚠️  Warning: Less than 10GB available space${NC}"
    echo "Buildroot needs significant disk space for building"
fi

# Download Buildroot
echo -e "${BLUE}📥 Downloading Buildroot...${NC}"
BUILDROOT_VERSION="2024.02"
BUILDROOT_DIR="buildroot-${BUILDROOT_VERSION}"

if [ ! -d "$BUILDROOT_DIR" ]; then
    wget -O buildroot.tar.gz "https://buildroot.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.gz"
    tar -xzf buildroot.tar.gz
    rm buildroot.tar.gz
    echo -e "${GREEN}✅ Buildroot downloaded successfully${NC}"
else
    echo -e "${YELLOW}⚠️  Buildroot directory already exists${NC}"
fi

# Copy our custom configurations
echo -e "${BLUE}📋 Copying custom configurations...${NC}"
cp -r configs/* "$BUILDROOT_DIR/configs/"
echo -e "${GREEN}✅ Configurations copied${NC}"

# Copy overlay files
echo -e "${BLUE}📁 Setting up filesystem overlay...${NC}"
mkdir -p "$BUILDROOT_DIR/board/custom/music-os/overlay"
cp -r overlay/* "$BUILDROOT_DIR/board/custom/music-os/overlay/"
echo -e "${GREEN}✅ Overlay files copied${NC}"

# Copy build scripts
echo -e "${BLUE}🔧 Setting up build scripts...${NC}"
mkdir -p "$BUILDROOT_DIR/board/custom/music-os/scripts"
cp scripts/* "$BUILDROOT_DIR/board/custom/music-os/scripts/"
chmod +x "$BUILDROOT_DIR/board/custom/music-os/scripts/"*
echo -e "${GREEN}✅ Build scripts copied${NC}"

# Create symlink for easy access
if [ ! -L "buildroot" ]; then
    ln -sf "$BUILDROOT_DIR" buildroot
    echo -e "${GREEN}✅ Created buildroot symlink${NC}"
fi

echo -e "${GREEN}🎉 Buildroot setup complete!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo "1. cd buildroot"
echo "2. make x86_64_defconfig  # For x86 development"
echo "3. make menuconfig         # Customize if needed"
echo "4. make                    # Start building"
echo ""
echo -e "${YELLOW}💡 Tip: Use 'make help' to see all available targets${NC}" 