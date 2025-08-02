#!/bin/bash

# Music OS WiFi Setup Script
# Configures WiFi connectivity for the music player

echo "📶 Music OS WiFi Setup"
echo "======================"

# Install WiFi packages
echo "📦 Installing WiFi packages..."
apt update
apt install -y \
    wpasupplicant \
    wireless-tools \
    network-manager

# Enable NetworkManager
echo "🔧 Enabling NetworkManager..."
systemctl enable NetworkManager
systemctl start NetworkManager

# Create WiFi configuration directory
mkdir -p /etc/NetworkManager/system-connections/

echo "✅ WiFi setup complete!"
echo ""
echo "WiFi features:"
echo "- NetworkManager for easy WiFi management"
echo "- Support for WPA/WPA2/WPA3 networks"
echo "- Auto-connect to saved networks"
echo ""
echo "To connect to WiFi:"
echo "1. Run: nmcli device wifi list"
echo "2. Run: nmcli device wifi connect [SSID] password [PASSWORD]"
echo ""
echo "Or use the GUI:"
echo "1. Run: nmtui"
echo "2. Select 'Activate a connection'"
echo "3. Choose your WiFi network" 