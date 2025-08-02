# Build and Test Scripts

This directory contains scripts for building, testing, and deploying the Custom Music OS.

## Scripts

### Build Scripts
- `build.sh` - Main build script
- `setup_buildroot.sh` - Setup Buildroot environment
- `configure.sh` - Apply custom configuration

### Test Scripts
- `test_qemu.sh` - Test ARM build on x86 with QEMU
- `test_pi.sh` - Test on real Raspberry Pi 5
- `benchmark.sh` - Performance benchmarking

### Deployment Scripts
- `flash_sd.sh` - Flash image to SD card
- `update_overlay.sh` - Update filesystem overlay
- `backup_music.sh` - Backup music library

### Development Scripts
- `debug.sh` - Enable debugging features
- `log_viewer.sh` - View system logs
- `ssh_setup.sh` - Setup SSH access

## Usage

```bash
# Build the system
./scripts/build.sh

# Test with QEMU
./scripts/test_qemu.sh

# Flash to SD card
./scripts/flash_sd.sh /dev/sdX
```

## Requirements

- Linux environment (Ubuntu 20.04+ recommended)
- Buildroot installed
- QEMU for testing
- SD card for deployment

*Scripts will be added as we develop the system...* 