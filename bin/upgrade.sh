#!/bin/bash

##############################
##### A Frog Bash Script #####
##############################
#####        @..@        #####
#####        (----)       #####
#####     (>____<)      #####
#####    ^^~~~~^^      #####
##############################

#/Name: upgrade
#/Description: Arch Distros upgrade script
#/Creation Date:
SCRIPT_VERSION=2.6.9

####################################################################
#Dependencies                                                      #
####################################################################
# - pacman
# - paru
# - hblock
# - Internet Conection
####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.

#August 5 2016
#/ made script independant of other scripts
#/ will update eithe suse or fedora as of this date no other distros
#/ are available for my use.
#/
#January 11 2016
#/ Major over haul of the update script
#/ Added routine for openSUSE
#/ Made it a part of the setup script so it sources from that
#/
#January 19, 2017
#/ Updated Tui
#/ removed old tui functions
#/ cleaned up script
#/ added independant update for google-chrome-stable
#/
#December 20 2020
#/ removed other OS"S and have it setup only for Arch brands such as Antergos.
#/
#May 28 2021 
#/REVIVED FROM ALIAS
# alias points to script so I can update my host file as well.
# it also leaves room for other things I need to update seperately.
# refreshed the tui theme 
# added message before upgrading to help keep the upgrade clean as possible.
# and do the best to avoid unwanted issue's. 


#/ Updated 08 25 2022
#/ minor changes in coding

#/ Update 01 29 2023
#/ cleaned a little and added paru to update my aur packages as well

#/ Update 04 29 2023
#/ added update for package list in /home/thefrog/bin/sys folder.
####################################################################
#Variables                                                         #
####################################################################
config_path=/home/thefrog/bin/etc
source ${config_path}/colors.config
source ${config_path}/common.config

upgrade_icon=
nonet_icon=       #NotoSansMono Nerd Font

err_Exit=0
####################################################################
#Script Global Functions                                           #
####################################################################

function Script_Display
{

clear
echo -e "${TITLEBG}${TITLEFG}${TITLE_ICONS}${hosts_icon} ${TITLEFG}$HOSTNAME                                                       ${TITLE_ICONS} ${upgrade_icon}${TITLEFG} OS Upgrade                                                               ${TITLE_ICONS}${version_icon}  ${NUMBCOLOR}${SCRIPT_VERSION}  ${Normal}"
echo -e "${ICONCOLOR}${clock_icon}${Normal}${NUMBCOLOR} `date "+%c"`${Normal}"
echo 
echo -e ${DIVIDER}

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
	#this command cleans all variables for script sessoion
	unset MY_IP target icount NETWORK_STATUS
exit
}
	
function Script_Help
{
	echo "Help"
	Script_Exit
}

####################################################################
#/ User added Functions                                            #
####################################################################
function chk_NET_STATUS
{

#/ check internet connection
MY_IP=`ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`

#/ check if wired or wireless if wired use -A3 to move forward to the actual ip
if [[ $MY_IP = "enp3s0" ]] ; then
	MY_IP=`ip addr | grep 'state UP' -A3 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
fi
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
#chk_NET_STATUS
Script_Display
#/Update system
paru -Syu    #<----[  update with paru to include aur updates as well.
hblock  #<----[  update the host file and block adds
pacman -Qqe > /home/thefrog/bin/sys/Packages.txt  #<----[ rewrite packages file after upgrade to now include any added apps 
Script_Exit
