#!/bin/bash

##############################
##### A Frog Bash Script #####
##############################
#####        @..@        #####
#####       (----)       #####
#####      (>____<)      #####
#####      ^^~~~~^^      #####
##############################

#/Name:makeitmyne.sh
#/Description: a setup script
#/Creation Date: 09 07 2022
SCRIPT_VERSION=1.0.3

####################################################################
#Dependencies                                                      #
####################################################################
#<----[ pacman paru internet connection

#<----[ optional - alacritty

####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.

# Update September 14 2023
# added if statement and variable to determine which device is being installed to.
# added help flag
####################################################################
#Variables                                                         #
####################################################################
bin_path=/run/media/thefrog/Reinstall/bin
config_path=$bin_path/etc
source ${config_path}/colors.config
source ${config_path}/common.config

INSTALL_WHERE=$1
####################################################################
#Script Global Functions                                           #
####################################################################

function Script_Display
{

clear
echo -e "${TITLEBG}${TITLEFG}${iconcolor}$ {host_icon}${Normal} ${TITLEFG}$HOSTNAME ${Normal}                      ${iconcolor}${texicon}${Normal} ${TITLEFG} Make it Myne                         ${NUMBCOLOR}${version_icon}${Normal}  ${TITLEFG}${SCRIPT_VERSION}  ${Normal}"
echo -e "${ICONCOLOR}${clock_icon}${Normal}${TXTCOLOR} `date "+%c"`${Normal}"
echo ""
echo ${DIVIDER}
}

function Script_Exit
{
	
echo -e ${DIVIDER}
    #Decide if Exiting with error
	if [[ ${err_Exit} != 0 ]] ; then
		echo -e ${ER_MSG}
	else
		echo -e ${GB_MSG}
	fi
	unset  
exit
}


function Script_Help
{
	echo "Reinstall is made to easily setup multiple systems with one script"
	echo "Usage is as follows"
	echo "L for Laptop		D for Desktop"
	echo "example"
	echo "reinstall.sh D" 
	Script_Exit
}

####################################################################
#/ User added Functions                                            #
####################################################################
function chk_NET_STATUS
{

#/ check internet connection
MY_IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
target=$MY_IP
icount=$( ping -c 1 $target | grep icmp* | wc -l ) > /dev/null 2>&1
if [[ $icount -eq 0 ]] ; then
    #inform user that net was not found
    echo -e ${ERRCOLOR} ${error_icon}${Normal} ${NO_INTERNET}
	err_Exit=1
	Script_Exit
fi

}

####################################################################
#Execute                                                           #
####################################################################
if [[ $1 = -h ]] ; then
	Script_Help
fi
chk_NET_STATUS #<----[ make sure we are on line before trying to run script


#<----[ check to ensure that where to install is chosen. 
if [[ -z ${INSTALL_WHERE} ]] ; then
	Script_Help
elif [[ ${INSTALL_WHERE} = "D" ]] ; then
#<----[ install packages from package list sorting out all of the aur packages as to not error.
sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort /run/media/thefrog/Reinstall/bin/sys/Desktop-Packages.txt))
#<----[ install from the AUR (I use paru) installing from AUR is interactive.
#<----[  first start with a single package as the initial build environment takes a bit of time to install test and be ready
sleep 3
paru -S pygtk     #<----[  starting with pygtk 
paru -S brave-bin qpdfview kickshaw obkey hardinfo2 gksu fslint fslint-gui
#<----[ add custom entries into fstab
#sudo bat /home/thefrog/bin/sys/uuid >> /etc/fstab
sudo cat /run/media/thefrog/Reinstall/bin/sys/uuid >> /etc/fstab  #<----[ open uuid and fstab to put entries of uuid into fstab since the above command returns error. 
else
#<----[ for the time we just have the two systems to install to. The laptop needs differ than the desktop needs.
#<----[ install packages from package list sorting out all of the aur packages as to not error.
sudo pacman -S --needed $(comm -12 <(pacman -Slq | sort) <(sort /run/media/thefrog/Reinstall/bin/sys/Laptop-Packages.txt))
	paru -S gksu #<----[  first start with a single package as the initial build environment takes a bit of time to install test and be ready
	paru -S qpdfview hardinfo2
fi
#<----[ No matter which desktop or laptop the remaining are needed for both devices.

#<----[ bluetooth services under endeavour
sudo sysemctl enable --now bluetooth

#<----[ Install custom service
sudo cp /run/media/thefrog/Reinstall/bin/services/userclean.service /etc/systemd/system
sudo cp /run/media/thefrog/Reinstall/bin/services/clean-cacheplus.sh /usr/bin
sudo chmod +x /usr/bin/clean-cacheplus.sh
sudo systemctl daemon-reload
sudo systemctl enable --now userclean.service
sudo systemctl enable lightdm.service
#dbus-launch dconf load / < xed.dconf

#<----[ Reset home folder

#<----[ Remove folders not needed
rm -rf Documents Downloads Pictures

#<----[ Create symbolic links to removed folders
ln -s /home/thefrog/thepad/thefrog/bin /home/thefrog/bin
ln -s /home/thefrog/thepad/thefrog/Documents /home/thefrog/Documents
ln -s /home/thefrog/thepad/thefrog/Downloads /home/thefrog/Downloads
ln -s /home/thefrog/thepad/thefrog/Pictures /home/thefrog/Pictures
ln -s /home/thefrog/thepad/thefrog/tmp /home/thefrog/tmp

#<----[ Copy config files needed for basic setup
if [[ ${INSTALL_WHERE} = "D" ]]
	cp -rv /run/media/thefrog/Reinstall/Desktop/.config $HOME/.config
	cp -rv /run/media/thefrog/Reinstall/Desktop/.local $HOME/.local
else
	cp -rv /run/media/thefrog/Reinstall/Laptop/.config $HOME/.config
	cp -rv /run/media/thefrog/Reinstall/Laptop/.local $HOME/.local
fi


Script_Exit
