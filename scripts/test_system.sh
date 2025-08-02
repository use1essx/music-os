#!/bin/bash

# Music OS System Test Script
# Tests all components of the music player system

echo "🧪 Music OS System Test"
echo "======================="

# Test 1: Check if MPD is running
echo "1. Testing MPD service..."
if systemctl is-active --quiet mpd; then
    echo "   ✅ MPD is running"
else
    echo "   ❌ MPD is not running"
    echo "   Starting MPD..."
    sudo systemctl start mpd
fi

# Test 2: Check music directory
echo "2. Testing music directory..."
if [ -d "/home/pi/Music" ]; then
    echo "   ✅ Music directory exists"
    music_count=$(find /home/pi/Music -name "*.mp3" -o -name "*.flac" -o -name "*.wav" | wc -l)
    echo "   📁 Found $music_count music files"
else
    echo "   ❌ Music directory not found"
fi

# Test 3: Check audio devices
echo "3. Testing audio devices..."
if command -v aplay &> /dev/null; then
    echo "   🔊 Audio devices:"
    aplay -l | grep -E "card|device"
else
    echo "   ❌ aplay not found"
fi

# Test 4: Test MPD connection
echo "4. Testing MPD connection..."
if command -v mpc &> /dev/null; then
    mpc status > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "   ✅ MPD connection successful"
        echo "   📊 MPD status:"
        mpc status
    else
        echo "   ❌ MPD connection failed"
    fi
else
    echo "   ❌ mpc not found"
fi

# Test 5: Check Python dependencies
echo "5. Testing Python dependencies..."
python3 -c "import tkinter, PIL, mutagen, pygame" 2>/dev/null
if [ $? -eq 0 ]; then
    echo "   ✅ All Python dependencies available"
else
    echo "   ❌ Missing Python dependencies"
fi

# Test 6: Check music player script
echo "6. Testing music player script..."
if [ -f "/home/pi/MusicUI/music_player.py" ]; then
    echo "   ✅ Music player script exists"
    python3 -m py_compile /home/pi/MusicUI/music_player.py 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "   ✅ Music player script syntax is valid"
    else
        echo "   ❌ Music player script has syntax errors"
    fi
else
    echo "   ❌ Music player script not found"
fi

# Test 7: Check systemd service
echo "7. Testing systemd service..."
if [ -f "/etc/systemd/system/musicplayer.service" ]; then
    echo "   ✅ Music player service exists"
    if systemctl is-enabled musicplayer.service &> /dev/null; then
        echo "   ✅ Music player service is enabled"
    else
        echo "   ❌ Music player service is not enabled"
    fi
else
    echo "   ❌ Music player service not found"
fi

# Test 8: Test audio output
echo "8. Testing audio output..."
if command -v speaker-test &> /dev/null; then
    echo "   🔊 Testing audio (3 seconds)..."
    timeout 3 speaker-test -t wav -c 2 -l 1 -D hw:0,0 > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "   ✅ Audio output working"
    else
        echo "   ❌ Audio output failed"
    fi
else
    echo "   ❌ speaker-test not found"
fi

echo ""
echo "🎵 Test Summary"
echo "==============="
echo "If all tests passed, your Music OS should be working correctly!"
echo ""
echo "To start the music player manually:"
echo "  python3 /home/pi/MusicUI/music_player.py"
echo ""
echo "To reboot and test autostart:"
 