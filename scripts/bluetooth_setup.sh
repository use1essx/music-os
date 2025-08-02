#!/bin/bash

# Music OS Bluetooth Setup Script
# Configures Bluetooth audio output support

echo "🔵 Music OS Bluetooth Setup"
echo "============================"

# Install Bluetooth packages
echo "📦 Installing Bluetooth packages..."
apt update
apt install -y \
    bluetooth \
    bluez \
    bluez-tools \
    pulseaudio-module-bluetooth \
    pulseaudio-utils

# Enable Bluetooth service
echo "🔧 Enabling Bluetooth service..."
systemctl enable bluetooth
systemctl start bluetooth

# Configure PulseAudio for Bluetooth
echo "🎵 Configuring PulseAudio for Bluetooth..."
cat > /etc/pulse/default.pa << 'EOF'
#!/usr/bin/pulseaudio -nF
#
# This file is part of PulseAudio.
#
# PulseAudio is free software; you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# PulseAudio is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with PulseAudio; if not, see <http://www.gnu.org/licenses/>.

# This startup script is used when PulseAudio is started in system
# mode.

### Load core protocols modules
load-module module-native-protocol-unix auth-anonymous=1 socket=/tmp/pulse-socket

### Make sure we always have a sink/source, even if hardware is not available
### Please note that this is not the correct way to do it. You should
### not need to do this manually, but it's often better than nothing.
load-module module-null-sink sink_name=null sink_properties=device.description=Dummy_Sink
load-module module-null-source source_name=null source_properties=device.description=Dummy_Source

### Load enabled modules from $XDG_CONFIG_HOME/pulse/default.pa.d/
.ifexists /etc/pulse/default.pa.d/*.pa
.nf
.include /etc/pulse/default.pa.d/*.pa
.fi

### Load Bluetooth modules
load-module module-bluetooth-discover
load-module module-bluetooth-policy

### Load additional modules from $XDG_CONFIG_HOME/pulse/default.pa.d/
.ifexists ~/.config/pulse/default.pa.d/*.pa
.nf
.include ~/.config/pulse/default.pa.d/*.pa
.fi
EOF

# Create Bluetooth configuration
echo "🔧 Creating Bluetooth configuration..."
cat > /etc/bluetooth/main.conf << 'EOF'
[General]
Name = Music OS
Class = 0x000000
DiscoverableTimeout = 0
PairableTimeout = 0
AutoEnable = true

[Policy]
AutoEnable=true
EOF

# Restart services
echo "🔄 Restarting services..."
systemctl restart bluetooth
pulseaudio --kill
pulseaudio --start

echo "✅ Bluetooth setup complete!"
echo ""
echo "Bluetooth features:"
echo "- Auto-enable Bluetooth on boot"
echo "- Discoverable for pairing"
echo "- Support for Bluetooth headphones/speakers"
echo ""
echo "To pair a device:"
echo "1. Run: bluetoothctl"
echo "2. Run: scan on"
echo "3. Run: pair [device-address]"
echo "4. Run: connect [device-address]" 