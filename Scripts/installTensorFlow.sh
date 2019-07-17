cd ~

sudo apt update -y

#Install dependencies that are/may be missing from Ubuntu Mate
sudo apt install -y python3-dev python3-pip
sudo apt install -y libatlas-base-dev
sudo pip3 install -U virtualenv
sudo apt-get install -y python-h5py

sudo virtualenv --system-site-packages -p python3 ~/.virtualenvs/py3tf
source ~/.virtualenvs/py3tf/bin/activate
pip install --upgrade pip
pip install scipy
pip install ffmpeg

#sudo apt-get install -y curl && sudo curl -sSL https://get.docker.com/ | sh
sudo apt-get install -y ffmpeg
sudo apt-get update -y && sudo apt-get upgrade -y

cd ~/.virtualenvs/py3tf/
#git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
#git checkout r1.14

# I went and edited the /install/install_deb...sh file and removed the ffmpeg line from it because it was causing issues
sudo CI_DOCKER_EXTRA_PARAMS="-e  CI_BUILD_PYTHON=python3 -e CROSSTOOL_PYTHON_INCLUDE_PATH=/usr/include/python3.6" \
    tensorflow/tools/ci_build/ci_build.sh PI-PYTHON3 \
    tensorflow/tools/ci_build/pi/build_raspberry_pi.sh

sudo pip install tensorflow-r1.14-cp34-none-linux_armv71.whl
