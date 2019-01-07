#!/bin/bash

## I assume most linux distros will have awk, sed, and wget

function download_audio {
	currentDirPath=$(dirname $0)

	bash "$currentDirPath/audio/dl-app-audio.bash"
}

function download_software {
	currentDirPath=$(dirname $0)

	if [ -f /etc/os-release ]; then
		distroName=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
		thisOS=$distroName
	fi

	## xorg shell emulator
	if ! [ -x "$(command -v xterm)" ]; then
		sudo pacman -S --needed bash grep sed xterm wget gawk
		sudo apt-get install bash grep sed xterm wget gawk
		sudo slapt-get --install bash grep sed xterm wget gawk

		if [ $thisOS -eq "Alpine Linux" ]; then
			# alpine is soo light, even bash is bare bones
			sudo apk add bash grep sed xterm wget gawk curl
		fi
	fi

	## bash gui menu
	if ! [ -x "$(command -v dialog)" ]; then
		sudo pacman -S --needed ncurses dialog bc grep
		sudo apt-get install ncurses dialog bc grep
		sudo slapt-get --install ncurses dialog bc grep
		sudo apk add ncurses dialog bc grep
	fi

	## json parser
	if ! [ -x "$(command -v jq)" ]; then
		sudo pacman -S --needed jq gcc
		sudo apt-get install jq gcc
		sudo apk add jq gcc

		if [ $thisOS -eq "Slackware" ]; then
			compileJq
		fi
	fi

	## console web browser
	if ! [ -x "$(command -v elinks)" ]; then
		sudo pacman -S --needed elinks curl
		sudo apt-get install elinks curl
		sudo slapt-get --install elinks curl
		sudo apk add elinks curl
	fi
}

function download_dependencies {
	download_software
	download_audio
}

## Run

download_dependencies
