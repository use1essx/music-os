# Buildroot Scripts (Legacy)

This directory contains scripts for the legacy Buildroot version of Music OS.

## Scripts

- **setup.sh** - Buildroot setup script
- **build.sh** - Build script for creating system images
- **test_vmware.sh** - VMware testing script

## Usage

`ash
# Set up Buildroot environment
./scripts/buildroot/setup.sh

# Build the system
./scripts/buildroot/build.sh

# Test in VMware
./scripts/buildroot/test_vmware.sh
`

**Note**: The Buildroot version is legacy and not recommended for new installations.
