#!/bin/sh


YELLOW='\033[1;33m'

RED='\033[0;31m'

BLUE='\033[1;34m'

SET='\033[0m'

shield_hat

=2
echo "${YELLOW}Downloading setup files${SET}"
wget --no-check-certificate  https://raw.githubusercontent.com/sixfab/Sixfab_PPP_Installer/master/ppp_installer/chat-connect -O chat-connect

if [ $? -ne 0 ]; then
    echo "${RED}Download failed${SET}"
    exit 1; 
fi

wget --no-check-certificate  https://raw.githubusercontent.com/sixfab/Sixfab_PPP_Installer/master/ppp_installer/chat-disconnect -O chat-disconnect

if [ $? -ne 0 ]; then
    echo "${RED}Download failed${SET}"
    exit 1;
fi

wget --no-check-certificate  https://raw.githubusercontent.com/sixfab/Sixfab_PPP_Installer/master/ppp_installer/provider -O provider

if [ $? -ne 0 ]; then
    echo "${RED}Download failed${SET}"
    exit 1;
fi

while [ 1 ]
do
	
kernelUpdate="y"
case $kernelUpdate in
		[Yy]* )  break;;
		
		[Nn]* )  echo "${YELLOW}rpi-update${SET}"
			rpi-update
		    break;;
		*)  echo "${RED}Wrong Selection, Select among Y or n${SET}";;
	esac
done

echo "${YELLOW}ppp install${SET}"
apt-get install ppp


carrierapn="hologram"
usernpass
="n"
	
	case $usernpass in
		
[Yy]* )  while [ 1 ] 
        do 
        
        echo "${YELLOW}Enter username${SET}"
        read username

        
echo "${YELLOW}Enter password${SET}"
        
read password
        sed -i "s/noauth/#noauth\nuser \"$username\"\npassword \"$password\"/" provider
        break 
        done

        break;;
		
		[Nn]* )  break;;
		*)  echo "${RED}Wrong Selection, Select among Y or n${SET}";;
	esac
done


echo "${YELLOW}What is your device communication PORT? (ttyS0/ttyUSB3/etc.)${SET}"

devicename="ttyUSB3" 


mkdir -p /etc/chatscripts
if [ $shield_hat -eq 3 ] || [ $shield_hat -eq 4 ]; then
  sed -i "s/#EXTRA/$EXTRA/" chat-connect
else
  sed -i "/#EXTRA/d" chat-connect
fi

mv chat-connect /etc/chatscripts/
mv chat-disconnect /etc/chatscripts/

mkdir -p /etc/ppp/peers
sed -i "s/#APN/$carrierapn/" provider
sed -i "s/#DEVICE/$devicename/" provider
mv provider /etc/ppp/peers/provider

if ! (grep -q 'route' /etc/ppp/ip-up ); then
    echo "sudo route del default" >> /etc/ppp/ip-up
    echo "sudo route add default ppp0" >> /etc/ppp/ip-up
fi

if [ $shield_hat -eq 2 ]; then
	if ! (grep -q 'max_usb_current' /boot/config.txt ); then
		echo "max_usb_current=1" >> /boot/config.txt
	fi
fi

while [ 1 ]
do
	echo "${YELLOW}Do you want to activate auto connect/reconnect service at R.Pi boot up? [Y/n] ${SET}"
	
auto_reconnect
="y"
	case $auto_reconnect in
		[Yy]* )    echo "${YELLOW}Downloading setup file${SET}"
			  
			  wget --no-check-certificate https://raw.githubusercontent.com/sixfab/Sixfab_PPP_Installer/master/ppp_installer/reconnect_service -O reconnect.service
			  
			  if [ $shield_hat -eq 1 ]; then
			  
				wget --no-check-certificate  https://raw.githubusercontent.com/sixfab/Sixfab_PPP_Installer/master/ppp_installer/reconnect_gprsshield -O reconnect.sh
			  
			  elif [ $shield_hat -eq 2 ]; then 
			  
				wget --no-check-certificate  https://raw.githubusercontent.com/sixfab/Sixfab_PPP_Installer/master/ppp_installer/reconnect_baseshield -O reconnect.sh
				
			  elif [ $shield_hat -eq 3 ]; then 
			  
				wget --no-check-certificate  https://raw.githubusercontent.com/sixfab/Sixfab_PPP_Installer/master/ppp_installer/reconnect_cellulariot_app -O reconnect.sh
			  
			  elif [ $shield_hat -eq 4 ]; then 
			  
				wget --no-check-certificate  https://raw.githubusercontent.com/sixfab/Sixfab_PPP_Installer/master/ppp_installer/reconnect_cellulariot -O reconnect.sh
			  fi
			  
			  mv reconnect.sh /usr/src/
			  mv reconnect.service /etc/systemd/system/
			  
			  
			  systemctl daemon-reload
			  systemctl enable reconnect.service
			  
			  break;;
			  
		[Nn]* )    echo "${YELLOW}To connect to internet run ${BLUE}\"sudo pon\"${YELLOW} and to disconnect run ${BLUE}\"sudo poff\" ${SET}"
			  break;;
		*)   echo "${RED}Wrong Selection, Select among Y or n${SET}";;
	esac
done