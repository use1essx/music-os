# Documentation

This directory contains comprehensive documentation for the Custom Music OS project.

## Documentation Structure

### User Guides
- `INSTALLATION.md` - How to build and install the OS
- `USAGE.md` - How to use the music player
- `TROUBLESHOOTING.md` - Common issues and solutions

### Developer Guides
- `DEVELOPMENT.md` - How to modify and extend the system
- `BUILDROOT_GUIDE.md` - Buildroot-specific documentation
- `TESTING.md` - Testing procedures and guidelines

### Technical Documentation
- `ARCHITECTURE.md` - System architecture overview
- `PERFORMANCE.md` - Performance optimization guide
- `SECURITY.md` - Security considerations

### API Documentation
- `GUI_API.md` - Music player GUI API
- `MPD_API.md` - MPD integration documentation
- `NETWORK_API.md` - Network services API

## Quick Reference

### Build Commands
```bash
# Setup Buildroot
./scripts/setup_buildroot.sh

# Build for Pi 5
make raspberrypi5_defconfig
make

# Test with QEMU
./scripts/test_qemu.sh
```

### Key Files
- `overlay/home/useless/MusicUI/music_app.py` - Main GUI
- `overlay/etc/systemd/system/musicplayer.service` - Autostart
- `configs/custom_music_os_defconfig` - Build config

### Performance Targets
- Boot time: < 10 seconds
- RAM usage: < 256MB
- Audio latency: < 50ms
- Image size: < 2GB

*Documentation will be added as we develop the system...* 