#!/bin/bash

# remove all local changes
git reset --hard HEAD
rm -rf build
rm -rf MacKernelSDK
rm -rf Lilu

# pull latest code
git pull

# get MacKernelSDK
git clone --depth=1 https://github.com/acidanthera/MacKernelSDK.git

# get and build Lilu
git clone --depth=1 https://github.com/acidanthera/Lilu.git
cd Lilu || exit 1
ln -s ../MacKernelSDK MacKernelSDK
xcodebuild -configuration Debug -arch x86_64
[ ! -d build/Debug/Lilu.kext ] && exit 1
cp -R build/Debug/Lilu.kext ../
cd ../

# remove generated firmware
rm IntelBluetoothFirmware/FwBinary.cpp

# remove firmware for other wifi cards
find IntelBluetoothFirmware/fw/ -type f ! -name 'ibt-11-5*' -delete

# build the kexts
xcodebuild -alltargets -configuration Release

# Location of Kexts
echo "You kexts are in build/Release!!"
echo " "
