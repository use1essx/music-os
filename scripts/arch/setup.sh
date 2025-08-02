#!/bin/bash

# 🎵 Arch Linux Music OS Setup Script
# This script sets up a minimal Arch Linux system for music playback

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MUSIC_USER="music"
MUSIC_HOME="/home/$MUSIC_USER"
MUSIC_DIR="$MUSIC_HOME/Music"
APP_DIR="$MUSIC_HOME/MusicUI"

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
    fi
}

# Update system
update_system() {
    log "Updating system packages..."
    pacman -Syu --noconfirm
}

# Install core packages
install_core_packages() {
    log "Installing core system packages..."
    
    # Essential system packages
    pacman -S --noconfirm \
        base base-devel \
        linux linux-firmware \
        grub efibootmgr \
        networkmanager wpa_supplicant \
        openssh \
        git vim htop
}

# Install audio packages
install_audio_packages() {
    log "Installing audio packages..."
    
    pacman -S --noconfirm \
        alsa-utils \
        pulseaudio pulseaudio-alsa \
        mpd \
        mpv \
        ffmpeg \
        yt-dlp
}

# Install Python and GUI packages
install_python_packages() {
    log "Installing Python and GUI packages..."
    
    pacman -S --noconfirm \
        python python-pip \
        python-pillow \
        python-requests \
        python-mutagen \
        tkinter
}

# Install optional packages
install_optional_packages() {
    log "Installing optional packages..."
    
    # Spotify Connect (optional)
    if command -v yay &> /dev/null; then
        yay -S --noconfirm librespot-bin
    else
        warning "yay not found, skipping librespot installation"
        info "Install yay first: https://github.com/Jguer/yay"
    fi
}

# Create music user
create_music_user() {
    log "Creating music user..."
    
    if ! id "$MUSIC_USER" &>/dev/null; then
        useradd -m -s /bin/bash "$MUSIC_USER"
        usermod -aG audio,video "$MUSIC_USER"
        log "User $MUSIC_USER created"
    else
        warning "User $MUSIC_USER already exists"
    fi
}

# Setup directories
setup_directories() {
    log "Setting up directories..."
    
    mkdir -p "$MUSIC_DIR"
    mkdir -p "$APP_DIR"
    mkdir -p "$MUSIC_HOME/.config/mpd"
    mkdir -p "$MUSIC_HOME/.config/pulse"
    
    chown -R "$MUSIC_USER:$MUSIC_USER" "$MUSIC_HOME"
}

# Configure MPD
configure_mpd() {
    log "Configuring MPD..."
    
    cat > "$MUSIC_HOME/.config/mpd/mpd.conf" << EOF
# MPD Configuration for Music OS
music_directory         "$MUSIC_DIR"
playlist_directory      "$MUSIC_HOME/.config/mpd/playlists"
db_file                "$MUSIC_HOME/.config/mpd/mpd.db"
log_file               "$MUSIC_HOME/.config/mpd/mpd.log"
pid_file               "$MUSIC_HOME/.config/mpd/mpd.pid"
state_file             "$MUSIC_HOME/.config/mpd/mpdstate"

# Audio output
audio_output {
    type        "alsa"
    name        "ALSA Output"
    device      "default"
    mixer_type  "hardware"
    mixer_device "default"
    mixer_control "Master"
}

# HTTP control
bind_to_address         "127.0.0.1"
port                    "6600"

# Performance
max_output_buffer_size  "8192"
EOF

    chown -R "$MUSIC_USER:$MUSIC_USER" "$MUSIC_HOME/.config/mpd"
}

# Configure ALSA
configure_alsa() {
    log "Configuring ALSA..."
    
    cat > /etc/asound.conf << EOF
# ALSA Configuration for low latency
pcm.!default {
    type plug
    slave.pcm "hw:0,0"
}

ctl.!default {
    type hw
    card 0
}
EOF
}

# Configure PulseAudio
configure_pulseaudio() {
    log "Configuring PulseAudio..."
    
    cat > "$MUSIC_HOME/.config/pulse/client.conf" << EOF
# PulseAudio client configuration
default-server = unix:/tmp/pulse-socket
autospawn = yes
daemon-binary = /usr/bin/pulseaudio
enable-shm = yes
shm-size-bytes = 0
EOF

    chown "$MUSIC_USER:$MUSIC_USER" "$MUSIC_HOME/.config/pulse/client.conf"
}

# Create music player application
create_music_app() {
    log "Creating music player application..."
    
    cat > "$APP_DIR/music_app.py" << 'EOF'
#!/usr/bin/env python3
"""
🎵 Music OS - Fullscreen Music Player
A minimal, beautiful music player interface
"""

import tkinter as tk
from tkinter import ttk, filedialog, messagebox
import subprocess
import threading
import os
import json
from PIL import Image, ImageTk
import requests
import mutagen
from mutagen.mp3 import MP3

class MusicPlayer:
    def __init__(self):
        self.root = tk.Tk()
        self.setup_window()
        self.setup_variables()
        self.create_widgets()
        self.setup_mpd()
        
    def setup_window(self):
        """Configure fullscreen window"""
        self.root.title("🎵 Music OS")
        self.root.attributes('-fullscreen', True)
        self.root.configure(bg='#1a1a1a')
        
        # Bind escape key to exit
        self.root.bind('<Escape>', lambda e: self.root.quit())
        
    def setup_variables(self):
        """Initialize variables"""
        self.current_song = None
        self.is_playing = False
        self.music_directory = os.path.expanduser("~/Music")
        self.playlist = []
        self.current_index = 0
        
    def create_widgets(self):
        """Create the main UI"""
        # Main frame
        main_frame = tk.Frame(self.root, bg='#1a1a1a')
        main_frame.pack(fill=tk.BOTH, expand=True, padx=20, pady=20)
        
        # Title
        title_label = tk.Label(
            main_frame, 
            text="🎵 Music OS", 
            font=('Arial', 24, 'bold'),
            fg='#ffffff',
            bg='#1a1a1a'
        )
        title_label.pack(pady=(0, 20))
        
        # Now playing frame
        self.now_playing_frame = tk.Frame(main_frame, bg='#2a2a2a', relief=tk.RAISED, bd=2)
        self.now_playing_frame.pack(fill=tk.X, pady=10)
        
        # Now playing label
        self.now_playing_label = tk.Label(
            self.now_playing_frame,
            text="No song playing",
            font=('Arial', 16),
            fg='#ffffff',
            bg='#2a2a2a'
        )
        self.now_playing_label.pack(pady=10)
        
        # Controls frame
        controls_frame = tk.Frame(main_frame, bg='#1a1a1a')
        controls_frame.pack(pady=20)
        
        # Control buttons
        tk.Button(
            controls_frame,
            text="⏮️ Previous",
            command=self.previous_song,
            font=('Arial', 12),
            bg='#4a4a4a',
            fg='#ffffff',
            relief=tk.FLAT,
            padx=20,
            pady=10
        ).pack(side=tk.LEFT, padx=5)
        
        self.play_button = tk.Button(
            controls_frame,
            text="⏯️ Play",
            command=self.toggle_play,
            font=('Arial', 12),
            bg='#4a4a4a',
            fg='#ffffff',
            relief=tk.FLAT,
            padx=20,
            pady=10
        )
        self.play_button.pack(side=tk.LEFT, padx=5)
        
        tk.Button(
            controls_frame,
            text="⏭️ Next",
            command=self.next_song,
            font=('Arial', 12),
            bg='#4a4a4a',
            fg='#ffffff',
            relief=tk.FLAT,
            padx=20,
            pady=10
        ).pack(side=tk.LEFT, padx=5)
        
        # Volume frame
        volume_frame = tk.Frame(main_frame, bg='#1a1a1a')
        volume_frame.pack(pady=10)
        
        tk.Label(
            volume_frame,
            text="🔈 Volume:",
            font=('Arial', 12),
            fg='#ffffff',
            bg='#1a1a1a'
        ).pack(side=tk.LEFT)
        
        self.volume_scale = tk.Scale(
            volume_frame,
            from_=0,
            to=100,
            orient=tk.HORIZONTAL,
            bg='#1a1a1a',
            fg='#ffffff',
            highlightbackground='#1a1a1a',
            command=self.set_volume
        )
        self.volume_scale.set(50)
        self.volume_scale.pack(side=tk.LEFT, padx=10)
        
        # Tab frame
        tab_frame = tk.Frame(main_frame, bg='#1a1a1a')
        tab_frame.pack(fill=tk.BOTH, expand=True, pady=20)
        
        # Tab buttons
        tk.Button(
            tab_frame,
            text="📁 Local Music",
            command=self.show_local_music,
            font=('Arial', 12),
            bg='#4a4a4a',
            fg='#ffffff',
            relief=tk.FLAT,
            padx=20,
            pady=10
        ).pack(side=tk.LEFT, padx=5)
        
        tk.Button(
            tab_frame,
            text="📺 YouTube",
            command=self.show_youtube,
            font=('Arial', 12),
            bg='#4a4a4a',
            fg='#ffffff',
            relief=tk.FLAT,
            padx=20,
            pady=10
        ).pack(side=tk.LEFT, padx=5)
        
        tk.Button(
            tab_frame,
            text="🎧 Spotify",
            command=self.show_spotify,
            font=('Arial', 12),
            bg='#4a4a4a',
            fg='#ffffff',
            relief=tk.FLAT,
            padx=20,
            pady=10
        ).pack(side=tk.LEFT, padx=5)
        
        tk.Button(
            tab_frame,
            text="⚙️ Settings",
            command=self.show_settings,
            font=('Arial', 12),
            bg='#4a4a4a',
            fg='#ffffff',
            relief=tk.FLAT,
            padx=20,
            pady=10
        ).pack(side=tk.LEFT, padx=5)
        
    def setup_mpd(self):
        """Setup MPD connection"""
        try:
            # Start MPD if not running
            subprocess.run(['systemctl', 'start', 'mpd'], check=False)
            log("MPD setup complete")
        except Exception as e:
            error(f"Failed to setup MPD: {e}")
            
    def toggle_play(self):
        """Toggle play/pause"""
        if self.is_playing:
            subprocess.run(['mpc', 'pause'])
            self.play_button.config(text="⏯️ Play")
            self.is_playing = False
        else:
            subprocess.run(['mpc', 'play'])
            self.play_button.config(text="⏸️ Pause")
            self.is_playing = True
            
    def next_song(self):
        """Play next song"""
        subprocess.run(['mpc', 'next'])
        
    def previous_song(self):
        """Play previous song"""
        subprocess.run(['mpc', 'prev'])
        
    def set_volume(self, value):
        """Set volume"""
        subprocess.run(['mpc', 'volume', value])
        
    def show_local_music(self):
        """Show local music browser"""
        messagebox.showinfo("Local Music", "Local music browser - Coming soon!")
        
    def show_youtube(self):
        """Show YouTube interface"""
        messagebox.showinfo("YouTube", "YouTube streaming - Coming soon!")
        
    def show_spotify(self):
        """Show Spotify interface"""
        messagebox.showinfo("Spotify", "Spotify Connect - Coming soon!")
        
    def show_settings(self):
        """Show settings"""
        messagebox.showinfo("Settings", "Settings panel - Coming soon!")
        
    def run(self):
        """Start the application"""
        self.root.mainloop()

def main():
    """Main function"""
    try:
        app = MusicPlayer()
        app.run()
    except Exception as e:
        print(f"Error starting music player: {e}")
        # Fallback to console
        import subprocess
        subprocess.run(['bash'])

if __name__ == "__main__":
    main()
EOF

    chmod +x "$APP_DIR/music_app.py"
    chown "$MUSIC_USER:$MUSIC_USER" "$APP_DIR/music_app.py"
}

# Create systemd service for auto-start
create_autostart_service() {
    log "Creating auto-start service..."
    
    cat > /etc/systemd/system/music-os.service << EOF
[Unit]
Description=Music OS Player
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
User=$MUSIC_USER
Group=$MUSIC_USER
Environment=DISPLAY=:0
Environment=XAUTHORITY=/home/$MUSIC_USER/.Xauthority
ExecStart=/usr/bin/python3 $APP_DIR/music_app.py
Restart=always
RestartSec=5

[Install]
WantedBy=graphical.target
EOF

    systemctl daemon-reload
    systemctl enable music-os.service
}

# Configure network
configure_network() {
    log "Configuring network..."
    
    systemctl enable NetworkManager
    systemctl enable sshd
    
    # Create basic network configuration
    cat > /etc/NetworkManager/conf.d/10-globally-managed-devices.conf << EOF
[keyfile]
unmanaged-devices=*,except:type:wifi,except:type:gsm,except:type:cdma
EOF
}

# Configure display manager (optional)
configure_display() {
    log "Configuring display manager..."
    
    # Install lightdm for minimal display manager
    pacman -S --noconfirm lightdm lightdm-gtk-greeter
    
    # Configure lightdm to auto-login
    cat > /etc/lightdm/lightdm.conf << EOF
[SeatDefaults]
autologin-user=$MUSIC_USER
autologin-session=lightdm-autologin
EOF
    
    systemctl enable lightdm
}

# Setup firewall
setup_firewall() {
    log "Setting up firewall..."
    
    pacman -S --noconfirm ufw
    
    # Basic firewall rules
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow 6600  # MPD port
    
    systemctl enable ufw
    ufw --force enable
}

# Create setup completion script
create_completion_script() {
    log "Creating completion script..."
    
    cat > "$MUSIC_HOME/setup_complete.sh" << 'EOF'
#!/bin/bash
# Music OS Setup Completion Script

echo "🎵 Music OS Setup Complete!"
echo ""
echo "Next steps:"
echo "1. Reboot the system"
echo "2. The music player should start automatically"
echo "3. Add music files to ~/Music directory"
echo "4. Use SSH to access the system remotely"
echo ""
echo "SSH access: ssh music@$(hostname -I | awk '{print $1}')"
echo ""
echo "Press Enter to reboot now, or Ctrl+C to cancel..."
read
sudo reboot
EOF

    chmod +x "$MUSIC_HOME/setup_complete.sh"
    chown "$MUSIC_USER:$MUSIC_USER" "$MUSIC_HOME/setup_complete.sh"
}

# Main setup function
main_setup() {
    log "Starting Arch Linux Music OS setup..."
    
    check_root
    update_system
    install_core_packages
    install_audio_packages
    install_python_packages
    install_optional_packages
    create_music_user
    setup_directories
    configure_mpd
    configure_alsa
    configure_pulseaudio
    create_music_app
    create_autostart_service
    configure_network
    configure_display
    setup_firewall
    create_completion_script
    
    log "Setup complete! Run ~/setup_complete.sh as the music user to finish."
}

# Run setup
main_setup 