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
# Handle externally managed environment - always use system packages for Raspberry Pi OS
echo "📦 Using system packages for Raspberry Pi OS..."
# All required packages are already installed via apt above
echo "✅ Python packages are already installed via system packages"

# User selection function
select_user() {
    echo ""
    echo "🎵 Music OS - User Selection"
    echo "============================"
    echo "1. Use current user ($(whoami))"
    echo "2. Create a new user"
    echo "3. Use existing user"
    echo ""
    read -p "Choose option (1-3): " choice
    
    case $choice in
        1)
            # Use current user
            if [ "$SUDO_USER" ]; then
                CURRENT_USER="$SUDO_USER"
            else
                CURRENT_USER=$(whoami)
            fi
            echo "✅ Using current user: $CURRENT_USER"
            ;;
        2)
            # Create new user
            read -p "Enter new username: " new_user
            if [ -z "$new_user" ]; then
                echo "❌ Username cannot be empty"
                exit 1
            fi
            
            # Check if user exists
            if id "$new_user" &>/dev/null; then
                echo "❌ User '$new_user' already exists"
                exit 1
            fi
            
            # Create user
            echo "🔧 Creating user: $new_user"
            useradd -m -s /bin/bash "$new_user"
            usermod -aG audio,plugdev "$new_user"
            
            # Set password
            echo "🔐 Setting password for $new_user"
            passwd "$new_user"
            
            CURRENT_USER="$new_user"
            echo "✅ Created and using user: $CURRENT_USER"
            ;;
        3)
            # Use existing user
            read -p "Enter existing username: " existing_user
            if [ -z "$existing_user" ]; then
                echo "❌ Username cannot be empty"
                exit 1
            fi
            
            # Check if user exists
            if ! id "$existing_user" &>/dev/null; then
                echo "❌ User '$existing_user' does not exist"
                exit 1
            fi
            
            CURRENT_USER="$existing_user"
            echo "✅ Using existing user: $CURRENT_USER"
            ;;
        *)
            echo "❌ Invalid choice"
            exit 1
            ;;
    esac
    
    CURRENT_HOME="/home/$CURRENT_USER"
    echo "🏠 User home: $CURRENT_HOME"
}

# Call user selection
select_user

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p "$CURRENT_HOME/Music"
mkdir -p "$CURRENT_HOME/MusicUI"
mkdir -p "$CURRENT_HOME/MusicUI/assets"
mkdir -p /etc/mpd
mkdir -p /var/lib/mpd/music
mkdir -p /var/lib/mpd/playlists

# Set permissions
chown -R "$CURRENT_USER:$CURRENT_USER" "$CURRENT_HOME/Music"
chown -R "$CURRENT_USER:$CURRENT_USER" "$CURRENT_HOME/MusicUI"

# Set mpd permissions (check if mpd group exists)
if getent group mpd > /dev/null 2>&1; then
    chown -R mpd:mpd /var/lib/mpd
else
    echo "⚠️  Warning: mpd group not found, using audio group"
    chown -R mpd:audio /var/lib/mpd
fi

# Configure MPD
echo "🎵 Configuring MPD..."
cat > /etc/mpd.conf << EOF
# MPD Configuration for Music OS
music_directory "$CURRENT_HOME/Music"
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
cat > /etc/systemd/system/musicplayer.service << EOF
[Unit]
Description=Music OS Player
After=network.target mpd.service
Wants=mpd.service

[Service]
Type=simple
User=$CURRENT_USER
Group=$CURRENT_USER
WorkingDirectory=$CURRENT_HOME/MusicUI
Environment=DISPLAY=:0
Environment=XAUTHORITY=$CURRENT_HOME/.Xauthority
ExecStart=/usr/bin/python3 $CURRENT_HOME/MusicUI/music_player.py
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
if ! grep -q "autologin-user=$CURRENT_USER" /etc/systemd/system/getty@tty1.service.d/autologin.conf 2>/dev/null; then
    mkdir -p /etc/systemd/system/getty@tty1.service.d
    cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << EOF
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin $CURRENT_USER --noclear %I $TERM
EOF
fi

# Configure auto-start X server
echo "🔧 Configuring X server autostart..."
cat > "$CURRENT_HOME/.bash_profile" << EOF
if [[ -z \$DISPLAY ]] && [[ \$(tty) = /dev/tty1 ]]; then
    startx
fi
EOF

# Configure X server to start music player
cat > "$CURRENT_HOME/.xinitrc" << EOF
#!/bin/bash
# Start music player in fullscreen
python3 $CURRENT_HOME/MusicUI/music_player.py
EOF

chmod +x "$CURRENT_HOME/.xinitrc"
chown "$CURRENT_USER:$CURRENT_USER" "$CURRENT_HOME/.bash_profile" "$CURRENT_HOME/.xinitrc"

# Create sample music file for testing
echo "🎵 Creating sample music file..."
cat > "$CURRENT_HOME/Music/README.txt" << EOF
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
usermod -a -G audio "$CURRENT_USER"
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
echo "1. Copy your music files to $CURRENT_HOME/Music"
echo "2. Reboot the system: sudo reboot"
echo "3. The music player will start automatically"
echo ""
echo "📱 Controls:"
echo "- Space: Play/Pause"
echo "- Left/Right arrows: Previous/Next track"
echo "- Up/Down arrows: Volume control"
echo "- Ctrl+C: Exit (for development)" 