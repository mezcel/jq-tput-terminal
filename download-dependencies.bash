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
		sudo pacman -S --needed bash xterm
		sudo apt-get install bash xterm
		sudo slapt-get --install bash xterm

		if [ $thisOS -eq "Alpine Linux" ]; then
			# alpine is soo light, even bash is bare bones
			sudo apk add bash xterm
		fi
	fi

	## gnu terminal and text manipulation tools
	if ! [ -x "$(command -v grep)" ] || ! [ -x "$(command -v sed)" ] || ! [ -x "$(command -v wget)" ] || ! [ -x "$(command -v gawk)" ] || ! [ -x "$(command -v bc)" ]; then
		sudo pacman -S --needed grep sed wget gawk bc
		sudo apt-get install grep sed wget gawk bc
		sudo slapt-get --install grep sed wget gawk bc

		if [ $thisOS -eq "Alpine Linux" ]; then
			# alpine is soo light, even bash is bare bones
			sudo apk add grep sed wget gawk curl bc
		fi
	fi

	## bash gui menu
	if ! [ -x "$(command -v ncurses)" ] || ! [ -x "$(command -v dialog)" ]; then
		sudo pacman -S --needed ncurses dialog
		sudo apt-get install ncurses dialog
		sudo slapt-get --install ncurses dialog
		sudo apk add ncurses dialog
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

	## multimedia audio player
	## I used to use mplayer for this App, but ogg123 is lighter and more specific for this app
	if [ -x "$(command -v ogg123)" ]; then
		sudo pacman -S --needed vorbis-tools
		sudo apt-get install vorbis-tools
		sudo slapt-get --install vorbis-tools
		sudo apk add vorbis-tools
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
