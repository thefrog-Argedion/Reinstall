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
SCRIPT_VERSION=1.0.4

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
#
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
#Script Global Functions                                           #
####################################################################


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
	if [[ ${INSTALL2} = "D" || "d" ]] ; then    #<----[ for the time we just have three systems to install to. All with different needs
		DESTINATION="Desktop"
		echo "Install and Setup for Hewlitt Packard"
		sudo pacman -Syu --needed - < ./Desktop/bin/sys/Packages.txt
		sudo cat ./Desktop/bin/sys/uuid >> fstab  #<----[ add internal hard drive to fstab
	elif [[ ${INSTALL2} = "G" || "g" ]] ; then
		echo "Install and Setup for Gateway"
		sudo pacman -Syu --needed - < ./Gateway/bin/sys/Packages.txt
		DESTINATION="Gateway"
	elif [[ ${INSTALL2} = "L" || "l" ]] ; then
	#<----[ The Lenovo has Opensuse on it. Not sure what applications i need to install
	#<----[ Here we just keep the basic dot files 
		echo "create routines for opensuse"
		DESTINATION="Lenovo"
	else
		echo "Unespected device choosen. Exiting with Error!"
		err =1
		Script_Help 
		
	fi
		mkdir -p ~/.config
		mkdir -p ~/.local
		mkdir -p ~/.themes
		mkdir -p ~/bin
  
		if [[ ${DESTINATION} = "D" ]] ; then  #<----[ link folders from internal disk
			ln -s /home/thefrog/thepad/bin /home/thefrog/
			ln -s /home/thefrog/thepad/Pictures /home/thefrog/ 
			ln -s /home/thefrog/thepad/Documents /home/thefrog/
			ln -s /home/thefrog/thepad/Downloads /home/thefrog/
			ln -s /home/thefrog/thepad/tmp /home/thefrog/
		else
			cp -R ./$DESTINATION/bin/* /home/thefrog/bin
			cp -R ./$DESTINATION/Pictures/* /home/thefrog/Pictures
		fi 
  
		cp -R ./$DESTINATION/.config/* /home/thefrog/.config
		cp -R ./$DESTINATION/.local/* /home/thefrog/.local		
		cp -R ./$DESTINATION/.themes/* /home/thefrog/.themes
		cp ./$DESTINATION/.gtkrc-2.0 /home/thefrog/.gtkrc-2.0
		cp ./$DESTINATION/.bashrc /home/thefrog/.bashrc


#<----[ start services
sudo systemctl enable lightdm.service
sudo systemctl enable bluetooth

#<----[ Install custom service
sudo cp /home/thefrog/bin/services/userclean.service /etc/systemd/system
sudo cp /home/thefrog/bin/services/clean-cacheplus.sh /usr/bin
sudo chmod +x /usr/bin/clean-cacheplus.sh
sudo systemctl daemon-reload
sudo systemctl enable userclean.service

read -p "Press key to reboot into new environment"
rm -rf /home/thefrog/$DESTINATION #<----[ toggle with a comment for troubleshooting but remove the install folder after install completes.
reboot

