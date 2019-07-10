#!/bin/bash
wget https://www.realvnc.com/download/file/vnc.files/VNC-Server-6.4.1-Linux-ARM.deb
dpkg -i VNC-Server-6.4.1-Linux-ARM.deb
sudo apt-get install -f
sudo systemctl start vncserver-x11-serviced.service # Start VNC now
sudo systemctl enable vncserver-x11-serviced.service # Start VNC on every bootup
