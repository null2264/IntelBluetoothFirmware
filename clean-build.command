#!/bin/bash

# remove all local changes
git reset --hard HEAD
rm -rf build

# pull latest code
git pull

# remove generated firmware
rm IntelBluetoothFirmware/FwBinary.cpp

# remove firmware for other wifi cards
find IntelBluetoothFirmware/fw/ -type f ! -name 'ibt-11-5*' -delete

# generate firmware
xcodebuild -project IntelBluetoothFirmware.xcodeproj -target fw_gen -configuration Release -sdk macosx

# build the kexts
## 1. IntelBluetoothFirmware.kext
xcodebuild -project IntelBluetoothFirmware.xcodeproj -target IntelBluetoothFirmware -configuration Release -sdk macosx

# build the kexts
## 2. IntelBluetoothInjector.kext
xcodebuild -project IntelBluetoothFirmware.xcodeproj -target IntelBluetoothInjector -configuration Release -sdk macosx

# Location of Kexts
echo "You kexts are in build/Release!!"
echo " "
