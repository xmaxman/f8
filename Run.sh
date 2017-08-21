#!/usr/bin/env bash
	
figlet Running Bots !

sleep 0.5

killall screen

echo -e "All Screen Prosses Killed !"

screen -d -m ./1.sh

screen -d -m ./3.sh

echo -e "Cli Runned !"

screen -d -m ./2.sh

echo -e "Api Runned !"


exit 1

