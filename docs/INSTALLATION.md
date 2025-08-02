# Music OS Installation Guide

This guide will help you install and configure Music OS on your Raspberry Pi 4.

## Prerequisites

- Raspberry Pi 4 (or higher) with 2GB+ RAM
- MicroSD card (16GB+ recommended)
- HDMI display or touchscreen
- Speakers/headphones
- Internet connection for initial setup

## Step 1: Prepare Raspberry Pi OS

1. Download Raspberry Pi OS Lite (64-bit) from the official website
2. Flash the image to your microSD card using Raspberry Pi Imager
3. Boot the Pi and complete initial setup

## Step 2: Install Music OS

1. Clone or download the Music OS files to your Pi
2. Make the installation script executable:
   ```bash
   chmod +x install/setup_music_os.sh
   ```

3. Run the installation script as root:
   ```bash
   sudo ./install/setup_music_os.sh
   ```

The script will:
- Update the system
- Install required packages (MPD, Python, etc.)
- Configure MPD for music playback
- Set up the music player service
- Configure autologin and autostart
- Set up audio permissions

## Step 3: Add Your Music

1. Copy your music files to `/home/pi/Music`
2. Supported formats: MP3, FLAC, WAV
3. The player will automatically scan and add them to the library

## Step 4: Configure Audio (Optional)

### Basic Audio Setup
```bash
sudo ./scripts/audio_setup.sh
```

### Bluetooth Audio (Optional)
```bash
sudo ./scripts/bluetooth_setup.sh
```

### WiFi Setup (Optional)
```bash
sudo ./scripts/wifi_setup.sh
```

## Step 5: Extract Album Art (Optional)

To extract album art from your music files:
```bash
python3 ui/album_art_extractor.py
```

## Step 6: Reboot and Test

1. Reboot the system:
   ```bash
   sudo reboot
   ```

2. The system should boot directly into the music player
3. Test the controls:
   - Space: Play/Pause
   - Left/Right arrows: Previous/Next track
   - Up/Down arrows: Volume control
   - Click wheel buttons for touch control

## Troubleshooting

### Music Player Not Starting
1. Check if MPD is running:
   ```bash
   systemctl status mpd
   ```

2. Check the music player service:
   ```bash
   systemctl status musicplayer.service
   ```

3. View logs:
   ```bash
   journalctl -u musicplayer.service
   ```

### No Audio Output
1. Check audio devices:
   ```bash
   aplay -l
   ```

2. Test audio:
   ```bash
   speaker-test -t wav -c 2 -l 1
   ```

3. Check MPD status:
   ```bash
   mpc status
   ```

### Manual Start
If the player doesn't start automatically:
```bash
python3 /home/pi/MusicUI/music_player.py
```

## Configuration Files

- MPD config: `/etc/mpd.conf`
- Music player service: `/etc/systemd/system/musicplayer.service`
- Audio config: `/etc/asound.conf`

## Directory Structure

```
/home/pi/
├── Music/              # Your music files
├── MusicUI/            # Player application
│   ├── music_player.py
│   └── assets/         # Album art
└── .xinitrc           # Autostart configuration
```

## Manual Commands

### Update Music Library
```bash
mpc update
```

### Control Playback
```bash
mpc play          # Start playback
mpc pause         # Pause
mpc next          # Next track
mpc prev          # Previous track
mpc volume 50     # Set volume to 50%
```

### View Playlist
```bash
mpc playlist
```

## Advanced Configuration

### Change Audio Output
Edit `/etc/mpd.conf` and restart MPD:
```bash
sudo systemctl restart mpd
```

### Customize UI
Edit `/home/pi/MusicUI/music_player.py` to modify the interface.

### Add More Music Formats
Install additional codecs:
```bash
sudo apt install ffmpeg
```

## Support

For issues or questions:
1. Check the logs: `journalctl -u musicplayer.service`
2. Test MPD directly: `mpc status`
3. Verify audio: `aplay -l`

## Future Features

- Bluetooth audio support
- WiFi connectivity management
- Online streaming plugins
- Physical clickwheel integration 