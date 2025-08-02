#!/bin/bash

# Music OS Installation Script for Raspberry Pi
# This script sets up a complete music-focused OS

set -e

echo "🎵 Music OS Installation Script"
echo "================================"

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run this script as root (use sudo)"
    exit 1
fi

# Update system
echo "📦 Updating system packages..."
apt update && apt upgrade -y

# Install required packages
echo "📦 Installing required packages..."
apt install -y \
    mpd \
    mpc \
    python3 \
    python3-pip \
    python3-tk \
    python3-pil \
    python3-pil.imagetk \
    python3-mutagen \
    python3-eyed3 \
    python3-requests \
    python3-pygame \
    git \
    wget \
    curl \
    alsa-utils \
    pulseaudio \
    pulseaudio-utils

# Install Python packages
echo "🐍 Installing Python packages..."
# Handle externally managed environment
if pip3 --version | grep -q "externally-managed"; then
    echo "📦 Using system packages where available..."
    # Install system packages first
    apt install -y \
        python3-mutagen \
        python3-pil \
        python3-pil.imagetk \
        python3-requests \
        python3-pygame
    
    # Install remaining packages with --break-system-packages (safe for our use case)
    pip3 install --break-system-packages \
        eyed3
else
    pip3 install \
        mutagen \
        eyed3 \
        pillow \
        requests \
        pygame
fi

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p /home/pi/Music
mkdir -p /home/pi/MusicUI
mkdir -p /home/pi/MusicUI/assets
mkdir -p /etc/mpd
mkdir -p /var/lib/mpd/music
mkdir -p /var/lib/mpd/playlists

# Set permissions
chown -R pi:pi /home/pi/Music
chown -R pi:pi /home/pi/MusicUI
chown -R mpd:mpd /var/lib/mpd

# Configure MPD
echo "🎵 Configuring MPD..."
cat > /etc/mpd.conf << 'EOF'
# MPD Configuration for Music OS
music_directory "/home/pi/Music"
playlist_directory "/var/lib/mpd/playlists"
db_file "/var/lib/mpd/mpd.db"
log_file "/var/log/mpd/mpd.log"
pid_file "/var/run/mpd/mpd.pid"
state_file "/var/lib/mpd/mpdstate"
sticker_file "/var/lib/mpd/sticker.sql"

# Audio Output Configuration
audio_output {
    type "alsa"
    name "ALSA Output"
    device "hw:0,0"
    mixer_type "hardware"
    mixer_device "hw:0"
    mixer_control "PCM"
}

# HDMI Audio Output
audio_output {
    type "alsa"
    name "HDMI Audio"
    device "hw:0,1"
    mixer_type "hardware"
    mixer_device "hw:0"
    mixer_control "PCM"
}

# USB DAC Support
audio_output {
    type "alsa"
    name "USB DAC"
    device "hw:1,0"
    mixer_type "hardware"
    mixer_device "hw:1"
    mixer_control "PCM"
}

# Network settings
bind_to_address "127.0.0.1"
port "6600"

# Permissions
user "mpd"
group "audio"

# General settings
auto_update "yes"
follow_inside_symlinks "yes"
EOF

# Create systemd service for music player
echo "🔧 Creating systemd service..."
cat > /etc/systemd/system/musicplayer.service << 'EOF'
[Unit]
Description=Music OS Player
After=network.target mpd.service
Wants=mpd.service

[Service]
Type=simple
User=pi
Group=pi
WorkingDirectory=/home/pi/MusicUI
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/pi/.Xauthority
ExecStart=/usr/bin/python3 /home/pi/MusicUI/music_player.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Enable services
echo "🔧 Enabling services..."
systemctl enable mpd
systemctl enable musicplayer.service

# Configure autologin
echo "🔧 Configuring autologin..."
if ! grep -q "autologin-user=pi" /etc/systemd/system/getty@tty1.service.d/autologin.conf 2>/dev/null; then
    mkdir -p /etc/systemd/system/getty@tty1.service.d
    cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin pi --noclear %I $TERM
EOF
fi

# Configure auto-start X server
echo "🔧 Configuring X server autostart..."
cat > /home/pi/.bash_profile << 'EOF'
if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
    startx
fi
EOF

# Configure X server to start music player
cat > /home/pi/.xinitrc << 'EOF'
#!/bin/bash
# Start music player in fullscreen
python3 /home/pi/MusicUI/music_player.py
EOF

chmod +x /home/pi/.xinitrc
chown pi:pi /home/pi/.bash_profile /home/pi/.xinitrc

# Create sample music file for testing
echo "🎵 Creating sample music file..."
cat > /home/pi/Music/README.txt << 'EOF'
Music OS - Music Directory

Place your music files (.mp3, .flac, .wav) in this directory.
The music player will automatically scan and add them to the library.

Supported formats:
- MP3 (.mp3)
- FLAC (.flac) 
- WAV (.wav)

The player will automatically detect album art and metadata.
EOF

# Set up audio permissions
echo "🔊 Configuring audio permissions..."
usermod -a -G audio pi
usermod -a -G audio mpd

# Configure ALSA for better audio
cat > /etc/asound.conf << 'EOF'
pcm.!default {
    type plug
    slave.pcm "hw:0,0"
}

ctl.!default {
    type hw
    card 0
}
EOF

echo "✅ Installation complete!"
echo ""
echo "🎵 Next steps:"
echo "1. Copy your music files to /home/pi/Music"
echo "2. Reboot the system: sudo reboot"
echo "3. The music player will start automatically"
echo ""
echo "📱 Controls:"
echo "- Space: Play/Pause"
echo "- Left/Right arrows: Previous/Next track"
echo "- Up/Down arrows: Volume control"
echo "- Ctrl+C: Exit (for development)" 