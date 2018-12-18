#!/bin/sh

function splashScreen() {
	echo "$CLR_ALL"
	width=$(tput cols)
	height=$(tput lines)
	str="Termainal Rosary using Jq and Bash"
	length=${#str}
	tput cup $((height/2)) $(((width/ 2)-(length/2)))
	echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
	str="( A new 120x40 window will popup )"
	length=${#str}
	tput cup $height $(((width/ 2)-(length/2)))
	echo $str

	read -s -t 1 -p "" exitVar &>/dev/null
}

function launch_new_window() {
	hostedDirPath=$(dirname $0)

	## most linux systems have xterm
	# XTerm*geometry: 120x40
	xterm -geometry 120x40+0+0 $hostedDirPath/bash-rosary.sh

}

splashScreen
launch_new_window
