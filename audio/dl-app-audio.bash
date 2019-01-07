#!/bin/bash

### install audio used in this app

function arch_audio_players {
	if [ -f /etc/os-release ]; then
		distroName=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
		thisOS=$distroName
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
}

function ogg_audio_files {

	currentDirPath=$(dirname $0)

	localFile="$currentDirPath/cross-english.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://archive.org/download/01SignOfTheCross/01%20Sign%20of%20the%20cross.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/Credo.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/c/c0/Byrd_4-Part_Mass_-_Credo.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/AveMaria.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/2/23/Schola_Gregoriana-Ave_Maria.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/PaterNoster.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/a/af/Schola_Gregoriana-Pater_Noster.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/AveMaria2.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/d/d4/JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/SalveRegina.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/4/46/Petits_Chanteurs_de_Passy_-_Salve_Regina_de_Hermann_Contract.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/Magnificat.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/f/fd/Schola_Gregoriana-Antiphona_et_Magnificat.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/GloriaPatri.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://upload.wikimedia.org/wikipedia/commons/4/45/The_Tudor_Consort_-_J_S_Bach_-_Magnificat_BWV_243_-_Gloria_Patri.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/beep.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://archive.org/download/kkkfffbird_yahoo_Beep_201607/beep.ogg' -O "$localFile"
	fi

	localFile="$currentDirPath/chime.ogg"
	if [ ! -f "$localFile" ];then
		# clear
		echo "	Downloading App Audio:
		"
		wget 'https://archive.org/download/WindChimeCellPhoneAlert/WindChime.ogg' -O "$localFile"
	fi

}

arch_audio_players
ogg_audio_files
