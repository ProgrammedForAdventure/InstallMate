#!/bin/bash

cd ~/Desktop

git clone https://github.com/tensorflow/tensorflow
cd tensorflow

tensorflow/contrib/makefile/download_dependencies.sh
sudo apt-get install -y autoconf automake libtool gcc-4.8 g++-4.8
cd tensorflow/contrib/makefile/downloads/protobuf/
./autogen.sh
./configure
make
sudo make install
sudo ldconfig  # refresh shared library cache
cd ../../../../..
export HOST_NSYNC_LIB=`tensorflow/contrib/makefile/compile_nsync.sh`
export TARGET_NSYNC_LIB="$HOST_NSYNC_LIB"

#make -f tensorflow/contrib/makefile/Makefile HOST_OS=PI TARGET=PI \
# OPTFLAGS="-Os -mfpu=neon-vfpv4 -funsafe-math-optimizations -ftree-vectorize" CXX=g++-4.8

