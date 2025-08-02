# Filesystem Overlay

This directory contains the custom filesystem overlay that will be applied to the Buildroot-generated root filesystem.

## Structure

```
overlay/
├── etc/                    # System configuration files
│   ├── systemd/           # systemd services
│   ├── mpd/              # MPD configuration
│   └── network/          # Network configuration
├── home/useless/         # User home directory
│   ├── Music/           # Music library
│   └── MusicUI/         # Music player application
├── usr/bin/             # Custom scripts and binaries
└── var/log/             # Log files
```

## Key Files

- `etc/systemd/system/musicplayer.service` - Autostart music player
- `home/useless/MusicUI/music_app.py` - Main GUI application
- `usr/bin/music_launcher.sh` - Boot script
- `etc/mpd.conf` - MPD configuration
- `etc/wpa_supplicant.conf` - Wi-Fi configuration

## Overlay Process

1. Buildroot generates base filesystem
2. Our overlay is applied on top
3. Custom files replace/override defaults
4. Final image is created

*Files will be added as we develop the system...* 