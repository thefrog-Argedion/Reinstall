#!/bin/bash

###############################
##### A Frog Bash Script ######
###############################
#####        @..@         #####
#####       (----)        #####
#####      (>____<)       #####
#####      ^^~~~~^^       #####
###############################
#/Name:reinstall.sh
#/Description: a setup script
#/Creation Date: 09 07 2022
SCRIPT_VERSION=1.0.4

####################################################################
#Dependencies                                                      #
####################################################################
#<----[ pacman internet connection

####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.

# Update September 14 2023
# added if statement and variable to determine which device is being installed to.
# added help flag

# Update September 30 2024
# added routine for gateway computer cleaned coded added variable DESTINATION 
# to help with knowing what to do for what system. INSTALL2 is a letter to keep it simple at install time
# DESTINATION is the same as the corresponding folder. 
#
####################################################################
#Variables                                                         #
####################################################################
INSTALL2=$1

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
    echo "WARNING WARNING The outside world has been rejected :D "
	exit 1
fi

}

####################################################################
#Execute                                                           #
####################################################################
if [[ $1 = -h ]] ; then
	Script_Help
fi
chk_NET_STATUS #<----[ make sure we are on line before trying to run script

	if [[ ${INSTALL2} = "D" || ${INSTALL2} = "d" ]] ; then    #<----[ for the time we just have three systems to install to. All with different needs
		#<----[ run bash -c as root as sudo byitself does not work with redirection for fstab.
		sudo bash -c "cat /home/thefrog/Desktop/bin/sys/uuid >> /etc/fstab"  #<----[ edit fstab to include internal drive
		sudo pacman -Syu --needed - < ./Desktop/bin/sys/Packages.txt
		DESTINATION="Desktop"
	elif [[ ${INSTALL2} = "G" || ${INSTALL2} = "g" ]] ; then
		sudo pacman -Syu --needed - < ./Gateway/bin/sys/Packages.txt
		DESTINATION="Gateway"
	elif [[ ${INSTALL2} = "L" || ${INSTALL2} = "l" ]] ; then
	#<----[ The Lenovo has Opensuse on it. Not sure what applications i need to install
	#<----[ Here we just keep the basic dot files 
		echo "Get off your ass and get this done your making me look bad dude. WTF?"
		DESTINATION="Lenovo"
	else
		echo "Uknown device choosen. Exiting with Error!"
		exit 1  ## return error
	fi
	
		mkdir -p ~/.config
		mkdir -p ~/.local
		mkdir -p ~/.themes

  
		if [[ ${DESTINATION} = "Desktop" ]] ; then  #<----[ link folders from internal disk
			rm -rf /home/thefrog/Documents
			rm -rf /home/thefrog/Downloads
			rm -rf /home/thefrog/Pictures
			ln -s /home/thefrog/thepad/thefrog/bin /home/thefrog/
			ln -s /home/thefrog/thepad/thefrog/Pictures /home/thefrog/ 
			ln -s /home/thefrog/thepad/thefrog/Documents /home/thefrog/
			ln -s /home/thefrog/thepad/thefrog/Downloads /home/thefrog/
			ln -s /home/thefrog/thepad/thefrog/tmp /home/thefrog/
		else
			#<----[ copy files from install location (home folder ideally) download from git hub or copy from disk after install and before reboot.
			mkdir -p /home/thefrog/bin
			cp -R ./$DESTINATION/bin/* /home/thefrog/bin
			cp -R ./$DESTINATION/Pictures/* /home/thefrog/Pictures
		fi 

#<---[ install the basic files need to have environment the way we want
		cp -R ./$DESTINATION/.config/* /home/thefrog/.config    
		cp -R ./$DESTINATION/.local/* /home/thefrog/.local		
		cp -R ./$DESTINATION/.themes/* /home/thefrog/.themes
		cp ./$DESTINATION/.gtkrc-2.0 /home/thefrog/.gtkrc-2.0
		cp ./$DESTINATION/.bashrc /home/thefrog/.bashrc
		
#<----[ start services
sudo systemctl enable lightdm.service
sudo systemctl enable bluetooth

#<----[ Install custom service
sudo cp /home/thefrog/$DESTINATION/bin/services/userclean.service /etc/systemd/system
sudo cp /home/thefrog/$DESTINATION/bin/services/clean-cacheplus.sh /usr/bin
sudo chmod +x /usr/bin/clean-cacheplus.sh
sudo systemctl daemon-reload
sudo systemctl enable userclean.service

read -p "Press key to reboot into new environment"
rm -rf /home/thefrog/$DESTINATION  #<----[ cleanup after install
unset INSTALL2 DESTINATION MY_IP target
reboot
exit
