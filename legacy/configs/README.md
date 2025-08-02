# Build Configurations

This directory contains Buildroot configuration files for different targets and scenarios.

## Configurations

### **Primary Targets**
- `raspberrypi5_defconfig` - Raspberry Pi 5 (ARM64)
- `raspberrypi4_defconfig` - Raspberry Pi 4 (ARM64)
- `x86_64_defconfig` - x86 PC (Intel/AMD)
- `generic_arm64_defconfig` - Generic ARM64 boards

### **Secondary Targets**
- `raspberrypi3_defconfig` - Raspberry Pi 3 (ARM32)
- `generic_arm32_defconfig` - Generic ARM32 boards
- `qemu_x86_defconfig` - QEMU x86 for testing
- `qemu_arm_defconfig` - QEMU ARM for testing

### **Custom Music OS Configs**
- `custom_music_os_pi5_defconfig` - Music OS for Pi 5
- `custom_music_os_x86_defconfig` - Music OS for x86
- `custom_music_os_generic_defconfig` - Music OS for generic ARM64

## Usage

```bash
# Build for Raspberry Pi 5
make raspberrypi5_defconfig
make

# Build for x86 PC
make x86_64_defconfig
make

# Build for generic ARM64
make generic_arm64_defconfig
make

# Test with QEMU
make qemu_x86_defconfig
make
```

## Platform-Specific Optimizations

### **Raspberry Pi**
- Broadcom GPU drivers
- Pi-specific audio drivers
- Optimized for Pi hardware

### **x86 PC**
- Intel/AMD graphics support
- USB audio device support
- Desktop-like performance

### **Generic ARM64**
- Minimal hardware dependencies
- Universal ARM64 support
- Compatible with most ARM boards

## Configuration Details

Each configuration includes:
- Kernel configuration
- Package selection
- Boot configuration
- Filesystem layout
- Custom patches

*Configuration files will be added as we develop...* 