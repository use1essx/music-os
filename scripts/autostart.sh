#!/bin/bash

# Music OS Autostart Script
# This script configures the system to boot directly into the music player

# Configure autologin
if ! grep -q "autologin-user=pi" /etc/systemd/system/getty@tty1.service.d/autologin.conf 2>/dev/null; then
    mkdir -p /etc/systemd/system/getty@tty1.service.d
    cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf << 'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin pi --noclear %I $TERM
EOF
fi

# Configure auto-start X server
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

echo "✅ Autostart configuration complete!"
echo "The system will now boot directly into the music player." 