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
		sudo pacman -S --needed xterm
		sudo apt-get install xterm
		sudo slapt-get --install xterm

		if [ $thisOS -eq "Alpine Linux" ]; then
			# alpine is soo light, even bash is bare bones
			sudo apk add bash grep sed xterm wget gawk
		fi
	fi

	## bash gui menu
	if ! [ -x "$(command -v dialog)" ]; then
		sudo pacman -S --needed dialog bc
		sudo apt-get install dialog bc
		sudo slapt-get --install dialog bc
		sudo apk add ncurses dialog bc grep
	fi

	## json parser
	if ! [ -x "$(command -v jq)" ]; then
		sudo pacman -S --needed jq
		sudo apt-get install jq
		sudo apk add jq

		if [ $thisOS -eq "Slackware" ]; then
			compileJq
		fi

	fi

	## c ompiler
	if ! [ -x "$(command -v gcc)" ]; then
		sudo pacman -S --needed gcc
		sudo apt-get install gcc
		sudo slapt-get --install gcc
		sudo apk add gcc
	fi

	## terminal web browser
	if ! [ -x "$(command -v gcc)" ]; then
		sudo pacman -S --needed elinks
		sudo apt-get install elinks
		sudo slapt-get --install elinks
		sudo apk add elinks
	fi
}

function download_dependencies {
	download_software
	download_audio
}

## Run

download_dependencies
