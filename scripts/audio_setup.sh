#!/bin/bash

# Music OS Audio Setup Script
# Configures audio outputs for the music player

echo "🔊 Music OS Audio Setup"
echo "========================"

# Set up audio permissions
echo "📋 Setting up audio permissions..."
usermod -a -G audio pi
usermod -a -G audio mpd

# Configure ALSA for better audio
echo "🎵 Configuring ALSA..."
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

# Set default volume
echo "🔊 Setting default volume..."
amixer set PCM 50%

# Test audio
echo "🎵 Testing audio output..."
speaker-test -t wav -c 2 -l 1 -D hw:0,0

echo "✅ Audio setup complete!"
echo ""
echo "Audio outputs configured:"
echo "- 3.5mm jack (hw:0,0)"
echo "- HDMI audio (hw:0,1)"
echo "- USB DAC (hw:1,0) - if connected" 