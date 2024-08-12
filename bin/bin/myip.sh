#!/bin/bash

##############################
##### A Frog Bash Script #####
##############################
#####        @..@        #####
#####       (----)       #####
#####      (>____<)      #####
#####      ^^~~~~^^      #####
##############################

#/Name: myip
#/Description: script to display online status
#/Creation Date: 09 15 2019
SCRIPT_VERSION=2.0.9

####################################################################
#Dependencies                                                      #
####################################################################

####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.

#/ Updated 09 02 2022
#/ placed in new template format
#/ added error trapping into fucntion instead of routine
#/ removed uneccessary source files and added what was being 
#/ used from them into the script itself

#/ Updated 09 14 2023
#/ fixed script to run on both wifi and just lan was an undiscovered bug until recently
#/ added ability to tell if on wifi or lan ip connection
#/ cleaned up interface
####################################################################
#Variables                                                         #
####################################################################
config_path=/home/thefrog/bin/etc
source ${config_path}/colors.config
source ${config_path}/common.config

#  fontawesome 
nonet_icon=       #NotoSansMono Nerd Font 
net_icon=🖧      ##Noto Sans Symbols2
mother_icon=       #HoloLens MDL2 Assets
local_icon=			#Symbols Nerd Font
lan_icon= 			#NotoSansMono Nerd Font
wifi_icon= 			#fontawesome
err_Exit=0
####################################################################
#Script Global Functions                                           #
####################################################################

function Script_Display
{

clear
echo -e "${TITLEBG}${TITLEFG}${TITLE_ICONS}${hosts_icon}${TITLEFG} $HOSTNAME                                                    ${TITLE_ICONS}${net_icon} ${TITLEFG} My IP                                                              ${TITLE_ICONS}${version_icon}  ${NUMBCOLOR}${SCRIPT_VERSION}  ${Normal}"
echo -e "${ICONCOLOR}${clock_icon}${Normal}${NUMBCOLOR}`date "+%c"`${Normal}"
echo ""

}

function Script_Exit
{
	

    #Decide if Exiting with error
	if [[ ${err_Exit} != 0 ]] ; then
		echo -e ${ER_MSG}
	else
		echo -e ${GB_MSG}
	fi
	unset MY_IP target icount public_ip

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
CON_TYPE=`ip addr | grep 'state UP' | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
if [[ $MY_IP = "enp3s0" ]] ; then
	MY_IP=`ip addr | grep 'state UP' -A3 | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
	CON_TYPE=`ip addr | grep 'state UP' | tail -n1 | awk '{print $2}' | cut -f1  -d'/'`
fi

target=$MY_IP
icount=$( ping -c 1 $target | grep icmp* | wc -l ) > /dev/null 2>&1
if [[ $icount -eq 0 ]] ; then
    #inform user that net was not found
   
    echo -e ${ERRCOLOR} ${error_icon}${Normal} ${NO_INTERNET}
	err_Exit=1
	Script_Exit
else
    NETWORK_STATUS=$MY_IP
fi

}

function get_PUBLIC_IP
{

public_ip=
public_ip="$(drill myip.opendns.com @resolver1.opendns.com | awk '/^myip\./ && $3 == "IN" {print $5}')"
if [[ -z ${public_ip} ]]; then
	public_ip="Offline"
fi
}
####################################################################
#Execute                                                           #
####################################################################

#/ check internet connection
chk_NET_STATUS
Script_Display

    echo "Aquiring Your Ip Connections"
       get_PUBLIC_IP
if [[ ${CON_TYPE} = "enp10s0:" ]] ; then
	CON_ICON=${lan_icon}
else
	CON_ICON=${wifi_icon}
fi
       Script_Display
    echo -e "${ICONCOLOR}${CON_ICON}${Normal}  ${CON_TYPE}"
    echo -e "${ICONCOLOR}${local_icon}${Normal}  Local${Normal}     ${NUMBCOLOR} $MY_IP${Normal}"
    echo -e "${ICONCOLOR}${mother_icon}${Normal}  Public     ${NUMBCOLOR}${public_ip}${Normal}"
echo -e ${DIVIDER}
Script_Exit
