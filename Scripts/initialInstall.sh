#!/bin/bash
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt install -y git
git config --global user.email "isaac.elmore@gmail.com"
git config --global user.name "Isaac Elmore"
sudo apt autoremove -y

# Now perform the device specific installs, while outputting 
# their data to a file and the terminal.
sudo pip3 install adafruit-blinka
sudo pip3 install adafruit-circuitpython-tlc5947
sudo pip3 install --upgrade --ignore-installed SpiDev
sudo pip3 install imutils

sudo ./installVnc.sh 2>&1 | tee vncInstallResults.txt
sudo ./installOpenCv.sh 2>&1 | tee opencvInstallResults.txt
sudo ./installSixFab4gLte.sh 2>&1 | tee sixFab4gLteInstallResults.txt
