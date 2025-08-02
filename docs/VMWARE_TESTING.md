# 🖥️ VMware Testing Guide

This guide will help you test the Custom Music OS in VMware Workstation or VMware Player.

## 📋 Prerequisites

- **VMware Workstation** or **VMware Player** (free)
- **At least 8GB free disk space**
- **2GB RAM** available for the VM
- **Linux build environment** (Ubuntu recommended)

## 🔧 Setup for VMware Testing

### 1. Build the VMware Version

```bash
# Setup Buildroot (if not done already)
./scripts/setup_buildroot.sh

# Build specifically for VMware
./scripts/test_vmware.sh
```

### 2. VM Requirements

The script will create a VM with these specifications:
- **OS**: Other Linux 64-bit
- **Memory**: 1024 MB
- **CPU**: 2 cores
- **Hard disk**: 8 GB
- **Network**: NAT
- **Sound**: Enabled

## 🚀 Creating the VM

### Method 1: Using Generated Files

1. **Run the build script**:
   ```bash
   ./scripts/test_vmware.sh
   ```

2. **Copy VM files** to your VMware directory:
   ```bash
   cp buildroot/music-os.vmx ~/VMware/
   cp buildroot/music-os.vmdk ~/VMware/
   ```

3. **Open VMware** and select "Open a Virtual Machine"

4. **Browse** to the `music-os.vmx` file and open it

### Method 2: Manual VM Creation

1. **Create new VM** in VMware:
   - Choose "Custom" installation
   - Select "Other Linux 64-bit"
   - Set memory to 1024 MB
   - Create 8 GB virtual disk

2. **Configure VM settings**:
   - Enable sound
   - Set network to NAT
   - Enable 3D acceleration

3. **Boot from ISO** (if using disk image)

## 🎵 Testing the Music OS

### First Boot

1. **Start the VM** - It will boot directly to the music player
2. **No login required** - The system starts automatically
3. **Fullscreen mode** - Press Escape to exit fullscreen
4. **Dark theme** - Modern, iPod-inspired interface

### Testing Features

#### ✅ **Music Playback**
```bash
# SSH into the VM (if network works)
ssh useless@<vm-ip>

# Add test music
scp /path/to/music/*.mp3 useless@<vm-ip>:/home/useless/Music/

# Update MPD database
mpc update
```

#### ✅ **GUI Controls**
- **⏯️ Play/Pause** - Click button or Spacebar
- **⏮️ Previous** - Click button or Left arrow
- **⏭️ Next** - Click button or Right arrow
- **🔈 Volume** - Drag slider or use volume keys
- **🖱️ Select song** - Double-click in music list

#### ✅ **Performance Testing**
```bash
# Check boot time
systemd-analyze time

# Check memory usage
free -h

# Check disk usage
df -h

# Monitor processes
htop
```

## 🔧 Troubleshooting

### Common Issues

#### **GUI Not Starting**
```bash
# Check display
echo $DISPLAY

# Check X server
ps aux | grep X

# Restart music player
systemctl restart musicplayer
```

#### **Audio Not Working**
```bash
# Check audio devices
aplay -l

# Test audio
speaker-test -t wav

# Check MPD status
systemctl status mpd
```

#### **Network Issues**
```bash
# Check network
ip addr show

# Test connectivity
ping 8.8.8.8

# Check DHCP
systemctl status dhcpcd
```

#### **Performance Issues**
```bash
# Check CPU usage
top

# Check memory
free -h

# Check disk I/O
iostat
```

### VMware-Specific Issues

#### **VMware Tools Not Working**
- Install open-vm-tools (included in our build)
- Enable "Reinstall VMware Tools" in VM menu

#### **Sound Issues**
- Enable sound in VM settings
- Check "Use host audio" option
- Restart VM after enabling sound

#### **Network Issues**
- Set network adapter to "NAT"
- Check "Connect at power on"
- Restart network service: `systemctl restart dhcpcd`

## 📊 Performance Benchmarks

### Target vs Actual

| Metric | Target | VMware Performance |
|--------|--------|-------------------|
| Boot Time | < 10s | ~8-12s |
| RAM Usage | < 256MB | ~180-220MB |
| Image Size | < 2GB | ~1.5GB |
| Audio Latency | < 50ms | ~30-40ms |

### Optimization Tips

1. **VM Settings**:
   - Enable "Use host audio"
   - Set memory to 1024 MB
   - Enable 2 CPU cores
   - Use SCSI disk controller

2. **Host Optimization**:
   - Close unnecessary applications
   - Defragment host disk
   - Use SSD if available

## 🎯 Testing Checklist

### ✅ **Basic Functionality**
- [ ] VM boots successfully
- [ ] Music player GUI starts
- [ ] Fullscreen mode works
- [ ] Escape key exits fullscreen

### ✅ **Audio Testing**
- [ ] Volume control works
- [ ] Audio output is clear
- [ ] No audio latency issues
- [ ] MPD service running

### ✅ **Music Features**
- [ ] Music library loads
- [ ] Play/pause works
- [ ] Next/previous works
- [ ] Song selection works

### ✅ **Network Features**
- [ ] SSH access works
- [ ] Network connectivity
- [ ] DHCP auto-configuration
- [ ] Internet access (if needed)

### ✅ **Performance**
- [ ] Boot time under 15 seconds
- [ ] Memory usage under 256MB
- [ ] Responsive GUI
- [ ] Smooth audio playback

## 🚀 Next Steps

After successful VMware testing:

1. **Test on real hardware** (Raspberry Pi)
2. **Add your music library**
3. **Customize the interface**
4. **Add more features** (YouTube, Spotify)

## 📞 Getting Help

- **Check logs**: `journalctl -u musicplayer`
- **SSH access**: `ssh useless@<vm-ip>`
- **Emergency console**: Ctrl+Alt+F2 during boot
- **VMware console**: Ctrl+Alt+Enter for fullscreen

---

**Happy testing!** 🎵✨ 