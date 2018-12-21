#!/bin/sh

### install audio used in this app

function arch_audio_players() {
	## midi player with soundfont
	sudo pacman -S --needed fluidsynth
	sudo pacman -S --needed soundfont-fluid

	## multimedia player for video and audio
	sudo pacman -S --needed mplayer
}

function ogg_audio_files() {
	
	currentDirPath=$(dirname $0)

	localFile="$currentDirPath/Credo.ogg"
	if [ ! -f "$localFile" ];then
		clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/c/c0/Byrd_4-Part_Mass_-_Credo.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/AveMaria.ogg"
	if [ ! -f "$localFile" ];then
		clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/2/23/Schola_Gregoriana-Ave_Maria.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/PaterNoster.ogg"
	if [ ! -f "$localFile" ];then
		clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/a/af/Schola_Gregoriana-Pater_Noster.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/AveMaria2.ogg"
	if [ ! -f "$localFile" ];then
		clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/d/d4/JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg' -O "$localFile"
	fi
}

ogg_audio_files
