# 🎵 Arch Linux Music OS

A **minimal, dedicated music operating system** built on Arch Linux that boots directly into a fullscreen music player UI. Perfect for creating a dedicated music appliance that feels like a professional music device rather than a computer.

## 🎯 Vision

This is a **dedicated music appliance** — not a Linux desktop. It boots directly into a beautiful, fullscreen music player interface with no desktop environment, designed for simplicity, beauty, and performance.

## ✨ Features

- **🚀 Fast boot** (< 10 seconds)
- **🎵 Local music playback** (MP3, FLAC, WAV, M4A, AAC, OGG)
- **📺 YouTube streaming & download** via yt-dlp + mpv
- **🎧 Spotify Connect** support
- **📶 Wi-Fi auto-connect** with SSH access
- **👆 Touchscreen & keyboard** input support
- **💾 Low memory usage** (< 512MB RAM)
- **🎛️ Low latency audio** (< 50ms)

## 🖥️ Supported Platforms

### **Primary Targets**
- **x86 PCs** - Intel/AMD desktops and laptops
- **Raspberry Pi 4/5** - ARM64, optimized for Pi hardware
- **Virtual Machines** - For testing and development

### **Secondary Targets**
- **Raspberry Pi 3** - ARM32, older Pi models
- **Generic ARM64** - Other ARM boards (Rock64, NanoPi, etc.)

## 🚀 Quick Start

### 1. Choose Your Platform

```bash
# Run the quick start guide
./scripts/quick_start.sh
```

### 2. Install Arch Linux

#### For x86 PCs:
1. Download [Arch Linux ISO](https://archlinux.org/download/)
2. Create bootable USB
3. Boot and run `archinstall` for automated setup
4. Clone this repository and run setup script

#### For Raspberry Pi:
1. Download [Arch Linux ARM](https://archlinuxarm.org/)
2. Flash to SD card
3. Boot Pi and expand filesystem
4. Clone repository and run setup script

### 3. Run Setup Script

```bash
# Run as root
sudo ./scripts/arch_setup.sh
```

### 4. Reboot and Enjoy!

The system will boot directly into the music player interface.

## 📁 Project Structure

```
arch-music-os/
├── scripts/              # Setup and utility scripts
│   ├── arch_setup.sh     # Main setup script
│   ├── quick_start.sh    # Platform selection guide
│   ├── dev_setup.sh      # Development environment
│   └── test_system.sh    # System testing
├── config/               # Configuration files
│   ├── music_os.conf     # Main configuration
│   └── mpd.conf          # MPD configuration
├── apps/                 # Music player application
│   └── music_app.py      # Main GUI application
├── services/             # Systemd services
├── docs/                 # Documentation
└── README_ARCH.md        # This file
```

## 🎨 UI Design

The music player features a modern, minimal interface:

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

## 📦 Package Selection

### **Core System** (Minimal)
- `base` - Basic system
- `linux` - Kernel
- `networkmanager` - Network management
- `openssh` - Remote access

### **Audio Stack**
- `mpd` - Music server backend
- `mpv` - Video/audio player
- `ffmpeg` - Codec support
- `alsa-utils` - Audio control
- `yt-dlp` - YouTube downloader

### **GUI Framework**
- `python` - Main language
- `python-pillow` - Image processing
- `python-requests` - Network requests
- `tkinter` - GUI (built into Python)

### **Optional Features**
- `librespot` - Spotify Connect
- `python-mutagen` - Audio metadata
- `htop` - System monitoring

## ⚙️ Performance Optimization

### **Boot Time** (< 10s)
- Minimal kernel modules
- Parallel service startup
- Essential services only
- systemd-boot for faster boot

### **Memory Usage** (< 512MB)
- No desktop environment
- Minimal package selection
- Efficient GUI rendering
- Memory leak prevention

### **Audio Latency** (< 50ms)
- ALSA direct access
- Low-latency kernel configuration
- MPD optimization
- Hardware acceleration

## 🔧 Configuration

The system is highly configurable through `config/music_os.conf`:

```ini
[System]
hostname = music-os
music_user = music
music_directory = /home/music/Music

[Audio]
audio_backend = alsa
mpd_host = 127.0.0.1
mpd_port = 6600

[GUI]
gui_framework = tkinter
fullscreen = true
background_color = #1a1a1a
```

## 🧪 Testing

### **System Testing**
```bash
# Test all components
./scripts/test_system.sh
```

### **Development Testing**
```bash
# Set up development environment
./scripts/dev_setup.sh
```

### **Performance Testing**
```bash
# Test boot time
systemd-analyze time

# Test memory usage
htop

# Test audio latency
jackd --latency
```

## 🚫 What's NOT Included

- **No desktop environment** (GNOME, KDE, etc.)
- **No web browser** (except for YouTube streaming)
- **No package manager GUI** (pacman only)
- **No unnecessary services** or bloat
- **No development tools** in production builds

## 🔒 Security Features

- **Firewall enabled** by default
- **SSH access** for remote management
- **Minimal attack surface**
- **Read-only root filesystem** (optional)
- **Regular security updates**

## 📊 Performance Targets

| Goal              | Target                        | Measurement Method |
|-------------------|-------------------------------|-------------------|
| Boot Time         | < 10s                         | systemd-analyze   |
| RAM Usage         | < 512MB                       | htop /proc/meminfo|
| Audio Latency     | < 50ms                        | jackd --latency   |
| GUI Performance   | Smooth & responsive           | Visual inspection  |
| Wi-Fi             | Autoconnect + SSH enabled     | Network test      |

## 🛠️ Development

### **Adding Features**
1. Modify `music_app.py` for GUI changes
2. Update `config/music_os.conf` for settings
3. Add packages to `scripts/arch_setup.sh`
4. Test with `./scripts/test_system.sh`

### **Customizing the Interface**
The GUI is built with Python Tkinter and is easily customizable:
- Colors and themes in `config/music_os.conf`
- Layout in `apps/music_app.py`
- Additional features can be added modularly

### **Platform-Specific Optimizations**
- **x86**: Intel/AMD graphics, USB audio
- **Raspberry Pi**: Broadcom GPU, Pi-specific audio
- **ARM64**: Minimal dependencies, universal support

## 📚 Documentation

- **[ARCH_SETUP.md](ARCH_SETUP.md)** - Detailed setup guide
- **[docs/](docs/)** - Additional documentation
- **[config/music_os.conf](config/music_os.conf)** - Configuration reference

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🆚 Comparison: Arch vs Buildroot

| Feature | Arch Linux | Buildroot |
|---------|------------|-----------|
| **Package Management** | pacman (easy) | Manual compilation |
| **Hardware Support** | Excellent | Limited |
| **Development** | Easy | Complex |
| **Size** | ~2GB | ~500MB |
| **Flexibility** | High | Low |
| **Boot Time** | ~10s | ~5s |
| **Maintenance** | Easy | Complex |

## 🎯 Why Arch Linux?

- **Easier development** and debugging
- **Better hardware support** and driver availability
- **More flexible customization** options
- **Better community support** and documentation
- **Still achieves minimal footprint** with careful package selection
- **Easier updates** and maintenance

## 🚀 Next Steps

1. **Choose your platform** (x86, Raspberry Pi, VM)
2. **Follow the quick start guide**
3. **Run the setup script**
4. **Add your music files**
5. **Customize the interface**
6. **Enjoy your dedicated music OS!**

---

**Status**: 🚧 In Development

*This project transforms Arch Linux into a dedicated music appliance that feels like a professional music device rather than a computer running music software.* 