# Music OS - Quick Start Guide

## 🚀 Installation

1. **Flash Raspberry Pi OS Lite (64-bit)** to your microSD card
2. **Boot the Pi** and complete initial setup
3. **Download Music OS files** to your Pi
4. **Run the installation script:**
   ```bash
   sudo ./install/setup_music_os.sh
   ```
5. **Copy your music** to `/home/pi/Music`
6. **Reboot:** `sudo reboot`

## 🎵 Features

- **Full-screen music player** with iPod-inspired design
- **Wheel-style controls** for intuitive navigation
- **Album art display** with automatic extraction
- **Multiple audio outputs** (3.5mm, HDMI, USB DAC)
- **Auto-boot** directly into music player
- **Keyboard and touch controls**

## 🎛️ Controls

### Keyboard Controls
- **Space**: Play/Pause
- **Left/Right arrows**: Previous/Next track
- **Up/Down arrows**: Volume up/down
- **Escape**: Exit (for development)

### Touch Controls
- **Center button**: Play/Pause
- **Left/Right buttons**: Previous/Next track
- **Top/Bottom buttons**: Volume up/down

## 📁 File Structure

```
musiceOS/
├── install/
│   └── setup_music_os.sh      # Main installation script
├── config/
│   └── mpd.conf              # MPD configuration
├── ui/
│   ├── music_player.py       # Main GUI application
│   └── album_art_extractor.py # Album art utility
├── scripts/
│   ├── audio_setup.sh        # Audio configuration
│   ├── bluetooth_setup.sh    # Bluetooth setup
│   ├── wifi_setup.sh         # WiFi setup
│   └── autostart.sh          # Autostart configuration
└── docs/
    └── INSTALLATION.md       # Detailed installation guide
```

## 🔧 Optional Setup

### Audio Configuration
```bash
sudo ./scripts/audio_setup.sh
```

### Bluetooth Support
```bash
sudo ./scripts/bluetooth_setup.sh
```

### WiFi Setup
```bash
sudo ./scripts/wifi_setup.sh
```

### Extract Album Art
```bash
python3 ui/album_art_extractor.py
```

## 🐛 Troubleshooting

### Player Not Starting
```bash
systemctl status musicplayer.service
journalctl -u musicplayer.service
```

### No Audio
```bash
aplay -l                    # List audio devices
speaker-test -t wav -c 2    # Test audio
mpc status                  # Check MPD status
```

### Manual Start
```bash
python3 /home/pi/MusicUI/music_player.py
```

## 📱 Supported Formats

- **MP3** (.mp3)
- **FLAC** (.flac)
- **WAV** (.wav)

## 🎯 System Requirements

- Raspberry Pi 4 (or higher)
- 2GB+ RAM
- 16GB+ microSD card
- HDMI display or touchscreen
- Speakers/headphones

## 🔮 Future Features

- Bluetooth audio output
- WiFi connectivity management
- Online streaming plugins (Spotify, YouTube Music)
- Physical clickwheel integration via GPIO
- Plugin system for extensions

## 📞 Support

For issues:
1. Check logs: `journalctl -u musicplayer.service`
2. Test MPD: `mpc status`
3. Verify audio: `aplay -l`

---

**Music OS** - Your Raspberry Pi music companion! 🎵 