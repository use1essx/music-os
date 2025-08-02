# 🎵 Music OS

A **dedicated music operating system** that boots directly into a fullscreen music player UI.

## ✨ Features

- **🚀 Fast boot** (< 10 seconds)
- **🎵 Local music playback** (MP3, FLAC, WAV, M4A, AAC, OGG)
- **📺 YouTube streaming & download** via yt-dlp + mpv
- **🎧 Spotify Connect** support
- **📶 Wi-Fi auto-connect** with SSH access
- **👆 Touchscreen & keyboard** input support
- **💾 Low memory usage** (< 512MB RAM)
- **🎧 Low latency audio** (< 50ms)

## 🚀 Getting Started

This project provides two paths: a modern Arch Linux-based system (recommended) and a legacy Buildroot system.

### 1. Arch Linux (Recommended)

For the best experience, use the Arch Linux setup scripts.

```bash
# Run the quick start script to begin
./scripts/arch/quick_start.sh
```

### 2. Buildroot (Legacy)

For advanced users who need a minimal, embedded system.

```bash
# Run the setup script for Buildroot
./scripts/buildroot/setup.sh
```

## ⚙️ Configuration

### Wi-Fi

To connect to a wireless network, edit the `wpa_supplicant.conf` file:

1.  Open `config/arch/wpa_supplicant.conf`.
2.  Replace `YourSSID` and `YourPassword` with your network's credentials.

This file will be copied to the target system to enable auto-connecting to your Wi-Fi network on boot.

## 🐍 The Music Player Application

The user interface is a Python application located at `apps/music_player/music_app.py`.

- **Framework**: Tkinter
- **Function**: Provides the fullscreen graphical interface for the OS.

To modify the UI, you can edit this file directly.

## 🚀 Automatic Startup

The music player is launched automatically on boot by a systemd service.

- **Launcher Script**: `scripts/arch/music_launcher.sh`
  - This script sets up the environment and starts the Python application.
- **Service File**: `config/systemd/music-player.service`
  - This file tells the systemd init system to run the launcher script after the graphical environment has loaded.

## 📁 Project Structure

```
musiceOS/
├── README.md                    # This file
├── apps/
│   └── music_player/
│       └── music_app.py         # The main Python GUI application
├── config/
│   ├── arch/
│   │   ├── mpd.conf
│   │   ├── music_os.conf
│   │   └── wpa_supplicant.conf  # Wi-Fi configuration template
│   └── systemd/
│       └── music-player.service # Systemd service for autostart
├── docs/                        # Detailed documentation
├── legacy/                      # Legacy Buildroot files
└── scripts/
    ├── arch/
    │   ├── music_launcher.sh    # Script to start the GUI
    │   └── setup.sh             # Main setup script
    └── buildroot/
```

## 📚 Detailed Documentation

For more in-depth information, please refer to the documents in the `docs/` directory.

- **[docs/QUICK_START.md](docs/QUICK_START.md)** - Quick start guide
- **[docs/ARCH_SETUP.md](docs/ARCH_SETUP.md)** - Detailed Arch Linux setup

---

**Status**: 🚀 In Development
