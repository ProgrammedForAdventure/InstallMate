#!/bin/bash

cd ~

sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get autoremove -y

#Install dependencies that are/may be missing
sudo apt-get install -y python3-dev python3-pip
sudo apt-get install -y libatlas-base-dev
sudo pip3 install --upgrade pip
sudo pip3 install -U virtualenv virtualenvwrapper
sudo apt-get install -y python-h5py

# Source virtualenvwrapper
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.7
source `which virtualenvwrapper.sh`
rmvirtualenv py3tf
mkvirtualenv --python /usr/bin/python3.7 py3tf
workon py3tf
echo "Done creating virtualenv \"py3tf\""

sudo pip3 install ffmpeg
sudo pip3 install pillow lxml jupyter matplotlib cython

sudo apt-get install -y python-tk
sudo apt-get install -y ffmpeg

# Install OpenCV dependencies
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y qt4-dev-tools

# Install OpenCV
sudo apt install -y python3-opencv

# Install protobuf
sudo apt-get install -y autoconf automake libtool curl
cd ~/Desktop
wget https://github.com/google/protobuf/releases/download/v3.9.1/protobuf-all-3.9.1.tar.gz
tar -zxvf protobuf-all-3.9.1.tar.gz
cd protobuf-3.9.1
./configure && make && make check && sudo make install

cd python
python3 setup.py build --cpp_implementation
python3 setup.py test --cpp_implementation
sudo python3 setup.py install --cpp_implementation
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=3
sudo ldconfig
cd ~
mkdir tensorflow1
cd tensorflow1
git clone --recurse-submodules https://github.com/tensorflow/models.git
sudo echo "export PYTHONPATH=$PYTHONPATH:/home/pi/tensorflow1/models/research:/home/pi/tensorflow1/models/research/slim" >> ~/.bashrc

cd ~/.virtualenvs/py3tf/

echo "Installing tensorflow (sometimes fails the first time, \"hash\" error):"

MAX_TRIES=4
COUNT=0
FINISHED=0
while [ $COUNT -lt $MAX_TRIES ]; do
   sudo pip3 install tensorflow --ignore-installed
   if [ $? -eq 0 ];then
	COUNT=MAX_TRIES
	FINISHED=1
   fi
   let COUNT=COUNT+1
done
if [ $FINISHED -eq 0 ];then
   echo "Too many non-successful tries - failed to install tensorflow."
   exit
fi

echo "Finished installing tensorflow!"
echo ""

echo "Downloading example code..."
git config --global user.name "Isaac Elmore"
git config --global user.email "isaac.elmore@gmail.com"
cd ~/Desktop
git clone  https://github.com/tensorflow/models.git

if [ $? -eq 0 ];then
	echo "Successfully downloaded example code. Installation complete!"
fi
