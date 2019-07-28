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

sudo pip3 install scipy
sudo pip3 install ffmpeg

sudo apt-get install -y ffmpeg

cd ~/.virtualenvs/py3tf/

echo "Installing tensorflow (sometimes fails the first time, \"hash\" error):"
sudo pip3 install tensorflow

MAX_TRIES=4
COUNT=0
while [ $COUNT -lt $MAX_TRIES ]; do
   sudo pip3 install tensorflow --ignore-installed
   if [ $? -eq 0 ];then
	exit 0
   fi
   let COUNT=COUNT+1
done
if [ $COUNT -eq $MAX_TRIES ];then
   echo "Too many non-successful tries - failed to install tensorflow."
   exit
fi

echo "Finished installing tensorflow!"
echo ""

echo "Downloading example code..."
git config --global user.name "Isaac Elmore"
git config --global user.email "isaac.elmore@gmail.com"
cd ~
git clone  https://github.com/tensorflow/tensorflow.git
