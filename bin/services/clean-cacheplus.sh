#!/bin/bash

#######################
#######################
####    @..@       ####
####   (----)      ####
####  (>____<)     ####
####  ^^~~~~^^     ####
#######################
##
#/Name: clean-xbel
#/Description: remeove the recently used xbel
#/Creation Date: 03 26 2023
SCRIPT_VERSION=1.0.0

####################################################################
#Dependencies                                                      #
####################################################################

####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.

####################################################################
#Variables                                                         #
####################################################################
config_path=/home/thefrog/bin/etc
source ${config_path}/colors.config
source ${config_path}/common.config


err_Exit=0
####################################################################
#Script Global Functions                                           #
####################################################################

function Script_Display
{

clear
echo -e "${TITLEBG}${TITLEFG}${ICONCOLOR}$ {host_icon}${Normal} ${TITLEFG}$HOSTNAME ${Normal}                      ${ICONCOLOR}${texicon}${Normal} ${TITLEFG} Put Title Here                         ${NUMBCOLOR}${version_icon}${Normal}  ${TITLEFG}${SCRIPT_VERSION}  ${Normal}"
echo -e "                             ${ICONCOLOR}${clock_icon}${Normal}${TXTCOLOR} `date "+%c"`${Normal}"
echo ""

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
	#this command cleans all variables for each script sessoion
	#exec env --ignore-environment /bin/bash 
	#unset 
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

####################################################################
#Execute                                                           #
####################################################################
rm -f /home/thefrog/.local/share/recently-used.xbel
rm -Rf /home/thefrog/.cache
Script_Exit
