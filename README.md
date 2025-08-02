# Music OS - Raspberry Pi Music Player

A custom music-focused operating system for Raspberry Pi 4+ with iPod-inspired design.

## 🎵 Features

- **Local Music Playback**: Supports MP3, FLAC, WAV files from `/home/pi/Music`
- **Modern UI**: Full-screen music interface with wheel-style controls
- **Auto-boot**: Boots directly into music player without desktop
- **Multiple Audio Outputs**: 3.5mm jack, HDMI audio, USB DAC support
- **Touch/Keyboard Control**: Intuitive controls for both input methods

## 🖥️ System Requirements

- Raspberry Pi 4 (or higher) with 2GB+ RAM
- MicroSD card (16GB+ recommended)
- HDMI display or touchscreen
- Speakers/headphones via 3.5mm jack or HDMI

## 📁 Project Structure

```
musiceOS/
├── install/              # Installation scripts
├── config/              # Configuration files
├── ui/                  # Python GUI application
├── scripts/             # System scripts
└── docs/               # Documentation
```

## 🚀 Quick Start

1. Flash Raspberry Pi OS Lite (64-bit) to your SD card
2. Boot the Pi and run the installation script
3. Copy your music files to `/home/pi/Music`
4. Reboot to start the music player

## 🔧 Installation

Run the installation script:
```bash
sudo ./install/setup_music_os.sh
```

## 🎛️ Controls

- **Play/Pause**: Space bar or center button
- **Next Track**: Right arrow or next button
- **Previous Track**: Left arrow or previous button
- **Volume Up/Down**: Up/Down arrows or volume buttons
- **Exit**: Ctrl+C (for development)

## 📱 Future Features

- Bluetooth audio support
- WiFi connectivity management
- Online streaming plugins (Spotify, YouTube Music)
- Physical clickwheel integration via GPIO 