#!/bin/bash

# Custom Music OS - Build Script
# This script builds the Music OS for different platforms

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🎵 Building Custom Music OS...${NC}"

# Check if we're in the right directory
if [ ! -d "buildroot" ]; then
    echo -e "${RED}❌ Error: buildroot directory not found${NC}"
    echo "Please run setup_buildroot.sh first"
    exit 1
fi

# Get target from command line
TARGET=${1:-"x86_64"}
BUILD_DIR="buildroot"

echo -e "${BLUE}📋 Building for target: ${TARGET}${NC}"

# Change to buildroot directory
cd "$BUILD_DIR"

# Clean previous build
echo -e "${BLUE}🧹 Cleaning previous build...${NC}"
make clean

# Apply configuration
echo -e "${BLUE}⚙️  Applying ${TARGET} configuration...${NC}"
make "${TARGET}_defconfig"

# Build
echo -e "${BLUE}🔨 Starting build...${NC}"
echo "This may take 30-60 minutes depending on your system..."

# Build with parallel jobs
make -j$(nproc)

# Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build completed successfully!${NC}"
    
    # Show output files
    echo -e "${BLUE}📁 Build outputs:${NC}"
    ls -lh output/images/
    
    # Create deployment script
    echo -e "${BLUE}📝 Creating deployment instructions...${NC}"
    cat > deploy_instructions.txt << EOF
Custom Music OS - Deployment Instructions

Build completed for: ${TARGET}
Output files are in: output/images/

To deploy:

1. For SD card (Raspberry Pi):
   sudo dd if=output/images/sdcard.img of=/dev/sdX bs=4M status=progress

2. For USB stick:
   sudo dd if=output/images/sdcard.img of=/dev/sdX bs=4M status=progress

3. For QEMU testing:
   qemu-system-x86_64 -kernel output/images/bzImage -initrd output/images/rootfs.cpio.gz -append "console=ttyS0" -nographic

Replace /dev/sdX with your actual device (be careful!)

EOF
    
    echo -e "${GREEN}📄 Deployment instructions saved to deploy_instructions.txt${NC}"
    
else
    echo -e "${RED}❌ Build failed!${NC}"
    echo "Check the build logs for errors"
    exit 1
fi

echo -e "${GREEN}🎉 Build process completed!${NC}" 