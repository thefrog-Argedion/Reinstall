#!/bin/bash

###############################
##### A Frog Bash Script ######
###############################
#####         @..@        #####
#####        (----)       #####
#####       (>____<)      #####
#####       ^^~~~~^^      #####
###############################

#/Name:install-service
#/Description: a script to install my custom cache clean service.
#/Creation Date: 09 24 2023
SCRIPT_VERSION=1.0.0

####################################################################
#Dependencies                                                      #
####################################################################
#<----[ systemctl init system
#<----[ Root Required
#<----[ optional - alacritty

####################################################################
#                           Updates                                #
####################################################################
#/ this section reserved for update notes.


####################################################################
#Variables                                                         #
####################################################################
sudo cp /home/thefrog/bin/services/userclean.service /etc/systemd/system
sudo cp /home/thefrog/bin/services/clean-cacheplus.sh /usr/bin
sudo chmod +x /usr/bin/clean-cacheplus.sh
sudo systemctl daemon-reload
sudo systemctl enable userclean.service
