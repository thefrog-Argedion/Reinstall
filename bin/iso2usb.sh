#!/bin/bash

##############################
##### A Frog Bash Script #####
##############################
#####        @..@        #####
#####       (----)       #####
#####      (>____<)      #####
#####      ^^~~~~^^      #####
##############################
#/Name: iso2disk.sh
#/Description:  a simple bash to burn iso to thumbdrive
#/Creation Date: 02-26-2020
SCRIPT_VERSION=1.3.2

####################################################################
#Dependencies                                                      #
####################################################################
#root privaleges dd du cut sync

####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.

#March 4 2022
# fixed minor errors, created schema for script

#/ Updated 08 29 2022
#/ Removed a few uneeded source files
#/ Removed uneeded function calls

####################################################################
#Variables                                                         #
####################################################################
config_path=/home/thefrog/bin/etc

source ${config_path}/colors.config
source ${config_path}/common.config
root_icon=      #NotoSansMono Nerd Font
iso_icon=       #Segoe MDL2 Assets
usb_icon=      #NotoSansMono Nerd Font
err_Exit=0

####################################################################
#Script Global Functions                                           #
####################################################################

function Script_Display
{

clear
echo -e "${TITLEBG}${TITLEFG}${TITLE_ICONS} ${iso_icon}${TITLEFG} ISO 2 USB                                                 ${TITLE_ICONS}${version_icon}  ${NUMBCOLOR}${SCRIPT_VERSION}  ${Normal}"
echo
echo -e "${ICONCOLOR}${iso_icon} ${TXTCOLOR} ${ISO_FILE} ${NUMBCOLOR}${ISO_SIZE}${Normal}" 
echo -e ${DIVIDER}
#exit

}
  
function Script_Exit
{
	
echo -e ${DIVIDER}
	if [[ ${err_Exit} != 0 ]] ; then
		echo -e ${ER_MSG}
	else
		echo -e ${GB_MSG}
	fi
	unset ISO_SIZE DEVICE2_BURN2 
exit
}
	
####################################################################
#/ User added Functions                                            #
#################################################################### 
 function is_User_Root
{

#/check run as root exit if not
if [[ $EUID -ne 0 ]]; then
		echo -e ${ERRCOLOR} ${error_icon}${Normal} ${NOT_ROOT}
        err_Exit=1
        Sh_Exit

fi

}

####################################################################
#Execute                                                           #
####################################################################

ISO_FILE=`echo $1 | cut -c 1-`
DEVICE2_BURN2=$2
is_User_Root 


ISO_SIZE=`du -hs ${ISO_FILE} | awk '{print $1}'`

Script_Display
echo -e "${WORKCOLOR}${work_icon}  Working"${Normal}
echo -e "Processing Request to ${ICONCOLOR} ${usb_icon} ${TXTCOLOR} ${DEVICE2_BURN2}${Normal}"
dd if=$ISO_FILE.iso of=$DEVICE2_BURN2 status=progress && sync
Script_Exit
