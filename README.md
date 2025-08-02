# 🎵 Custom Music OS

A **fully custom, standalone Music Operating System** built with Buildroot for **multiple platforms** including Raspberry Pi, x86 PCs, and other ARM devices.

## 🎯 Vision

This is a **dedicated music appliance** — not a Linux desktop. It boots directly into a fullscreen music player UI with no desktop environment, designed for simplicity, beauty, and performance.

## 🚀 Features

- **Direct boot to music UI** (no desktop, no login)
- **Local music playback** (MP3, FLAC, WAV, M4A, AAC, OGG)
- **YouTube streaming & download** via yt-dlp + mpv
- **Spotify Connect** support (optional)
- **Wi-Fi auto-connect** with SSH access
- **Touchscreen & keyboard** input support
- **Fast boot** (< 10s) and **low latency** (< 50ms)

## 🖥️ Supported Platforms

### **Primary Targets**
- **Raspberry Pi 4/5** - ARM64, optimized for Pi hardware
- **x86 PCs** - Intel/AMD, for development and testing
- **Generic ARM64** - Other ARM boards (Rock64, NanoPi, etc.)

### **Secondary Targets**
- **Raspberry Pi 3** - ARM32, older Pi models
- **ARM32 devices** - Various single-board computers
- **Virtual machines** - For testing and development

## 📁 Project Structure

```
custom-music-os/
├── buildroot/           # Buildroot configuration
├── overlay/             # Custom filesystem overlay
├── configs/             # Build configurations
├── scripts/             # Build and test scripts
├── docs/               # Documentation
└── README.md           # This file
```

## 🛠️ Build Requirements

- **Linux environment** (Ubuntu 20.04+ recommended)
- **Buildroot** (latest stable)
- **QEMU** for testing ARM builds on x86
- **VMware** for x86 testing (recommended)
- **SD card** for embedded device testing

## 📋 Quick Start

### For VMware Testing (Recommended)
```bash
# Setup and build for VMware
./scripts/setup_buildroot.sh
./scripts/test_vmware.sh

# Open the generated .vmx file in VMware
```

### For Other Platforms
1. **Choose your target platform**
2. **Clone and setup Buildroot**
3. **Configure for your hardware**
4. **Build the OS image**
5. **Flash to storage device**
6. **Boot and enjoy!**

*See `docs/VMWARE_TESTING.md` for detailed VMware instructions*

## 🎨 UI Design

```
+------------------------------------------------------+
| 🎵 Now Playing: [Song Title - Artist]               |
|                                                      |
|                    [Album Art]                       |
|                                                      |
|  ⏮️  ⏯️  ⏭️                          🔈 █████──       |
+------------------------------------------------------+
| [ Local Music ] [ YouTube ] [ Spotify ] [ Settings ] |
+------------------------------------------------------+
```

## 🎯 Performance Targets

| Goal              | Target                        |
|-------------------|-------------------------------|
| Boot Time         | < 10s                         |
| RAM Usage         | < 256MB                       |
| Image Size        | < 2GB                         |
| Audio Latency     | < 50ms                        |
| GUI Performance   | Smooth & responsive           |

## 🔧 Technical Stack

- **OS**: Custom Linux built with Buildroot
- **Audio**: MPD + ALSA (no PulseAudio)
- **GUI**: Python + Tkinter/PyQt5
- **Network**: wpa_supplicant + dropbear SSH
- **Video**: mpv + yt-dlp for YouTube

## 📝 License

MIT License - see LICENSE file for details.

---

**Status**: 🚧 In Development

*This project is actively being developed. The goal is to create a professional-grade embedded music appliance that feels like a dedicated music device rather than a computer running music software.* 