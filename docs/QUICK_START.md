# 🚀 Quick Start Guide

This guide will help you build and test the Custom Music OS.

## 📋 Prerequisites

- **Linux environment** (Ubuntu 20.04+ recommended)
- **At least 10GB free disk space**
- **Internet connection** for downloading Buildroot
- **SD card** (for Raspberry Pi deployment)

## 🔧 Setup

### 1. Clone and Setup

```bash
# Clone the repository
git clone <your-repo-url>
cd custom-music-os

# Make scripts executable
chmod +x scripts/*.sh

# Setup Buildroot environment
./scripts/setup_buildroot.sh
```

### 2. Build for Development (x86)

```bash
# Build for x86 PC (faster for development)
./scripts/build.sh x86_64
```

### 3. Build for Raspberry Pi 5

```bash
# Build for Raspberry Pi 5
./scripts/build.sh raspberrypi5
```

## 🧪 Testing

### QEMU Testing (x86)

```bash
# Test x86 build with QEMU
cd buildroot
qemu-system-x86_64 -kernel output/images/bzImage \
    -initrd output/images/rootfs.cpio.gz \
    -append "console=ttyS0" -nographic
```

### Real Hardware Testing

```bash
# Flash to SD card (BE CAREFUL!)
sudo dd if=buildroot/output/images/sdcard.img of=/dev/sdX bs=4M status=progress

# Insert SD card into Raspberry Pi and boot
```

## 🎵 Using the Music OS

### First Boot

1. **Boot the system** - It will start directly into the music player
2. **Add music** - Copy your music files to `/home/useless/Music/`
3. **Control playback** - Use the GUI buttons or keyboard shortcuts

### Controls

- **⏯️ Play/Pause** - Spacebar or click button
- **⏮️ Previous** - Left arrow or click button  
- **⏭️ Next** - Right arrow or click button
- **🔈 Volume** - Drag slider or use volume keys
- **🖱️ Select song** - Double-click on song in list
- **🚪 Exit** - Press Escape key

### Adding Music

```bash
# SSH into the system
ssh useless@<ip-address>

# Copy music files
scp /path/to/music/*.mp3 useless@<ip-address>:/home/useless/Music/

# Update MPD database
mpc update
```

## 🔧 Troubleshooting

### Build Issues

```bash
# Clean build
cd buildroot
make clean

# Rebuild
make x86_64_defconfig
make -j$(nproc)
```

### Audio Issues

```bash
# Check audio devices
aplay -l

# Test audio
speaker-test -t wav

# Check MPD status
systemctl status mpd
```

### GUI Issues

```bash
# Check display
echo $DISPLAY

# Test X server
xeyes

# Restart music player
systemctl restart musicplayer
```

## 📊 Performance Targets

| Metric | Target | Current |
|--------|--------|---------|
| Boot Time | < 10s | TBD |
| RAM Usage | < 256MB | TBD |
| Image Size | < 2GB | TBD |
| Audio Latency | < 50ms | TBD |

## 🆘 Getting Help

- **Check logs**: `journalctl -u musicplayer`
- **SSH access**: `ssh useless@<ip-address>`
- **Emergency console**: Ctrl+Alt+F2 during boot

## 🎯 Next Steps

1. **Test on real hardware**
2. **Add your music library**
3. **Customize the interface**
4. **Add more features**

---

**Happy listening!** 🎵✨ 