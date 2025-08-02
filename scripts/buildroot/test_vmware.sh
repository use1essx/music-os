#!/bin/bash

# Custom Music OS - VMware Testing Script
# This script helps prepare and test the Music OS in VMware

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🎵 Preparing Custom Music OS for VMware testing...${NC}"

# Check if we're in the right directory
if [ ! -d "buildroot" ]; then
    echo -e "${RED}❌ Error: buildroot directory not found${NC}"
    echo "Please run setup_buildroot.sh first"
    exit 1
fi

# Build for x86 (VMware compatible)
echo -e "${BLUE}🔨 Building x86 version for VMware...${NC}"
cd buildroot

# Clean previous build
make clean

# Apply x86 configuration
make x86_64_defconfig

# Build
echo -e "${BLUE}⏳ Building (this may take 30-60 minutes)...${NC}"
make -j$(nproc)

# Check if build was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Build completed successfully!${NC}"
    
    # Create VMware-specific files
    echo -e "${BLUE}📝 Creating VMware configuration...${NC}"
    
    # Create .vmx file for VMware
    cat > music-os.vmx << EOF
.encoding = "windows-1252"
config.version = "8"
virtualHW.version = "19"
numvcpus = "2"
memsize = "1024"
scsi0.present = "TRUE"
scsi0.virtualDev = "lsisas1068"
scsi0:0.present = "TRUE"
scsi0:0.fileName = "music-os.vmdk"
ide1:0.present = "TRUE"
ide1:0.fileName = "auto detect"
ide1:0.deviceType = "cdrom-raw"
floppy0.present = "FALSE"
ethernet0.present = "TRUE"
ethernet0.virtualDev = "e1000"
ethernet0.networkName = "VM Network"
ethernet0.addressType = "generated"
sound.present = "TRUE"
sound.virtualDev = "hdaudio"
sound.fileName = "-1"
sound.autodetect = "TRUE"
displayName = "Custom Music OS"
guestOS = "other26xlinux"
nvram = "music-os.nvram"
virtualHW.productCompatibility = "hosted"
powerType.powerOff = "soft"
powerType.powerOn = "soft"
powerType.suspend = "soft"
powerType.reset = "soft"
extendedConfigFile = "music-os.vmxf"
ethernet0.generatedAddress = "00:0c:29:00:00:00"
ethernet0.generatedAddressOffset = "0"
uuid.location = "564d0000 0000 0000 0000 000000000000"
uuid.bios = "564d0000 0000 0000 0000 000000000000"
cleanShutdown = "TRUE"
replay.supported = "FALSE"
replay.filename = ""
scsi0:0.redo = ""
pciBridge0.present = "TRUE"
pciBridge4.present = "TRUE"
pciBridge4.virtualDev = "pcieRootPort"
pciBridge4.functions = "8"
pciBridge5.present = "TRUE"
pciBridge5.virtualDev = "pcieRootPort"
pciBridge5.functions = "8"
pciBridge6.present = "TRUE"
pciBridge6.virtualDev = "pcieRootPort"
pciBridge6.functions = "8"
pciBridge7.present = "TRUE"
pciBridge7.virtualDev = "pcieRootPort"
pciBridge7.functions = "8"
vmci0.present = "TRUE"
hpet0.present = "TRUE"
usb_xhci.present = "TRUE"
ehci.present = "TRUE"
ehci.pciSlotNumber = "34"
svga.present = "TRUE"
svga.vramSize = "268435456"
svga.guestBackedPrimaryAware = "TRUE"
vga.present = "TRUE"
firmware = "efi"
keyboardAndMouseProfile = "vmware"
smc.present = "TRUE"
smc.version = "0"
board-id = "440BX Desktop Reference Platform"
hw.model.reflectHost = "TRUE"
hw.model = "VMware, Inc. VMware Virtual Platform"
smc.present = "TRUE"
EOF

    echo -e "${GREEN}✅ VMware configuration created${NC}"
    
    # Create instructions
    cat > vmware_instructions.txt << EOF
Custom Music OS - VMware Testing Instructions

Build completed successfully!

To test in VMware:

1. Create a new VM in VMware:
   - OS: Other Linux 64-bit
   - Memory: 1024 MB
   - CPU: 2 cores
   - Hard disk: 8 GB

2. Copy the VM files:
   - music-os.vmx (VMware configuration)
   - music-os.vmdk (Virtual disk)

3. Boot the VM:
   - The system will boot directly to the music player
   - No login required
   - Press Escape to exit fullscreen

4. Testing features:
   - Music playback (add files to /home/useless/Music/)
   - Volume control
   - Playlist management
   - SSH access (if network configured)

5. Performance testing:
   - Boot time measurement
   - Memory usage monitoring
   - Audio latency testing

Troubleshooting:
- If GUI doesn't start: Check VMware Tools installation
- If audio doesn't work: Enable sound in VM settings
- If network doesn't work: Configure VM network adapter

EOF
    
    echo -e "${GREEN}📄 VMware instructions saved to vmware_instructions.txt${NC}"
    
else
    echo -e "${RED}❌ Build failed!${NC}"
    echo "Check the build logs for errors"
    exit 1
fi

echo -e "${GREEN}🎉 VMware testing setup completed!${NC}"
echo -e "${BLUE}📋 Next steps:${NC}"
echo "1. Create a new VM in VMware"
echo "2. Use the generated .vmx file"
echo "3. Boot and test the Music OS"
echo ""
echo -e "${YELLOW}💡 Tip: Use 'vmware_instructions.txt' for detailed setup${NC}" 