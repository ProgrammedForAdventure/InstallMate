#!/bin/bash

# This script assumes the device has already been updated.

echo "Installing developer tools..."
sudo apt-get install -y build-essential cmake unzip pkg-config
echo "Finished installing developer tools."
echo "=========================="
echo ""

echo "Installing image and video I/O libraries..."
sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
echo "Finished installing image and video I/O libraries."
echo "=========================="
echo ""

echo "Installing GTK for GUI backend..."
sudo apt-get install -y libgtk-3-dev
echo "Installing mathematical optimizations for OpenCv..."
sudo apt-get install -y libatlas-base-dev gfortran

echo "Installing Python3 development headers..."
sudo apt-get install -y python3-dev
echo "Finished installing GTK, math optimizations, and Python3 dev headers."
echo "=========================="
echo ""

echo "Downloading OpenCV..."
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/4.0.0.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.0.0.zip
echo "Finished downloading. Unzipping..."
unzip opencv.zip
unzip opencv_contrib.zip
mv opencv-4.0.0 opencv
mv opencv_contrib-4.0.0 opencv_contrib
echo "Finished unzipping OpenCv."
echo "=========================="
echo ""

# Add these lines if you need to install pip
echo "Installing pip..."
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
echo "Finished installing pip."

echo "Installing virtualenv..."
sudo pip install virtualenv virtualenvwrapper
echo "Done installing virtualenv."

echo "Adding virtual environment lines to .bashrc."
echo "# virtualenv and virtualenvwrapper" >> ~/.bashrc
echo "export WORKON_HOME=$HOME/.virtualenvs" >> ~/.bashrc
echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc
echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc
source `which virtualenvwrapper.sh`

echo "Creating virtual environment \"py3cv4\" for installation"
mkvirtualenv py3cv4 -p python3
source /home/development/.virtualenvs/py3cv4/bin/activate

echo "Installing numpy..."
sudo pip install numpy
echo "Finished installing numpy."
echo ""

echo "Installing gstreamer..."
sudo apt install -y gstreamer1.0
sudo apt install -y gstreamer1.0-tools
sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
echo "Done installing gstreamer."

echo "Preparing to build OpenCv..."
echo "=================================="
echo ""

cd ~/opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D INSTALL_C_EXAMPLES=OFF \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
	-D PYTHON_EXECUTABLE=~/.virtualenvs/py3cv4/bin/python \
	-D WITH_GSTREAMER=ON \
	-D WITH_FFMPEG=ON \
	-D WITH_OPENMP=ON \
	-D BUILD_EXAMPLES=ON ..

echo ""
echo "======================="
echo "Building OpenCV..."
make -j4
sudo make install
sudo ldconfig






