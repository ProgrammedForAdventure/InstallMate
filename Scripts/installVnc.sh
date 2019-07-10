#!/bin/bash
sudo apt-get update # Update the device
sudo apt-get install -y realvnc-vnc-server # Install VNC
sudo systemctl start vncserver-x11-serviced.service # Start VNC now
sudo systemctl enable vncserver-x11-serviced.service # Start VNC on every bootup