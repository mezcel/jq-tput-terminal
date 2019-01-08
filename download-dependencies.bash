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
	if ! [ -x "$(command -v grep)" ] || ! [ -x "$(command -v sed)" ] || ! [ -x "$(command -v wget)" ] || ! [ -x "$(command -v gawk)" ] || ! [ -x "$(command -v bc)" ] || ! [ -x "$(command -v curl)" ]; then
		sudo pacman -S --needed grep sed wget gawk bc curl
		sudo apt-get install grep sed wget gawk bc curl
		sudo slapt-get --install grep sed wget gawk bc curl

		if [ $thisOS -eq "Alpine Linux" ]; then
			# alpine is soo light, even bash is bare bones
			sudo apk add grep sed wget gawk curl bc curl
		fi
	fi

	## bash gui menu
	if ! [ -f /usr/include/ncurses.h ] || ! [ -x "$(command -v dialog)" ]; then
		sudo pacman -S --needed ncurses dialog
		sudo apt-get install libncurses5-dev libncursesw5-dev dialog
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

	## ogg audio player
	if ! [ -f /usr/bin/ogg123 ];then

		## gnu fix for arch
		if [ $thisOS -eq "Arch Linux" ]; then
			sudo pacman -S --needed vorbis-tools

			## ogg123 fix for playback
			## comment out line "dev=default"
			sed -i -e 's/dev=default/# dev=default/g' /etc/libao.conf
		else
			sudo apt-get install vorbis-tools
			sudo slapt-get --install vorbis-tools
		fi
	fi

	## console web browser html viewer
	if ! [ -x "$(command -v elinks)" ]; then
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
# "checking github for latest update ..."
git pull &>/dev/null

download_dependencies
