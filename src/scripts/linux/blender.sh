#!/bin/sh

sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/3bf863cc.pub
sudo apt-get update

sudo apt-get -y install software-properties-common 
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get -y install file libasyncns0 \
                       libcaca0 libdc1394-dev libexpat1 libfftw3-dev libflac-dev \
                       libfreetype6 libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa glew-utils \
                       libglu1-mesa libgomp1 libgsm1 libjack-jackd2-0 libjpeg-turbo-progs libjpeg-dev \
                       libmagic1 libogg0 libopenal-data libopenal1 \
                       liborc-0.4-0 libpulse0 libraw1394-11 libsamplerate0 \
                       libsdl1.2debian libsndfile1 libspeex1 libsqlite3-0 libtheora0 \
                       libusb-1.0-0 libvorbis0a libvorbisenc2 libwrap0 libx11-6 libx11-data \
                       libx11-xcb1 libxau6 libxcb-glx0 libxcb1 libxdamage1 libxdmcp6 libxext6 libxfixes3 libxi6 \
                       libxxf86vm1 mime-support python3 tcpd ucf libxrender1 libxkbcommon-x11-0 libegl-dev curl unzip python3-pip \
                       libsm6 libfontconfig1

curl -fSL http://mirrors.iu13.net/blender/release/Blender4.3/blender-4.3.0-linux-x64.tar.xz -o blender.tar.xz
# curl -fSL  http://www.blender.org/download/release/Blender4.3/blender-4.3.0-linux-x64.tar.xz -o blender.tar.xz

mkdir -p /opt/blender
tar -xf blender.tar.xz -C /opt/blender --strip-components=1
rm blender.tar.xz
