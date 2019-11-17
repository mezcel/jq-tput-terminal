#!/bin/bash
###################################################
## UI Appearance Vars
###################################################

function decorativeColors {
	## Forground Color using tput

	FG_BLACK=$(tput setaf 0)
	FG_RED=$(tput setaf 1)
	FG_GREEN=$(tput setaf 2)
	FG_YELLOW=$(tput setaf 3)
	FG_BLUE=$(tput setaf 4)
	FG_MAGENTA=$(tput setaf 5)
	FG_CYAN=$(tput setaf 6)
	FG_WHITE=$(tput setaf 7)
	FG_NoColor=$(tput sgr0)

	## Background Color using tput

	BG_BLACK=$(tput setab 0)
	BG_RED=$(tput setab 1)
	BG_GREEN=$(tput setab 2)
	BG_YELLOW=$(tput setab 3)
	BG_BLUE=$(tput setab 4)
	BG_MAGENTA=$(tput setab 5)
	BG_CYAN=$(tput setab 6)
	BG_WHITE=$(tput setab 7)
	BG_NoColor=$(tput sgr0)

	## set mode using tput

	MODE_BOLD=$(tput bold)
	MODE_DIM=$(tput dim)
	MODE_BEGIN_UNDERLINE=$(tput smul)
	MODE_EXIT_UNDERLINE=$(tput rmul)
	MODE_REVERSE=$(tput rev)
	MODE_ENTER_STANDOUT=$(tput smso)
	MODE_EXIT_STANDOUT=$(tput rmso)

	## clear styles using tput
	STYLES_OFF=$(tput sgr0)

	## Clear screen and home cursor
	CLR_ALL=$(tput clear)
	CLR_ALL_LINES=$(tput cup 0 0 && tput ed)

	## Blink
	BLINKING=$(tput blink)

	HIDECURSOR=$(tput civis)
	SHOWCURSOR=$(tput cnorm)
}

function inputControlls {
	arrowUp=$'\e[A'
	arrowDown=$'\e[B'
	arrowRt=$'\e[C'
	arrowLt=$'\e[D'

	returnKey=$'\x0a'
	escKey=$'\e'
}

function resizeWindow {
	## Initial resize
	## I designed this App with Xterm in mind. Other terminals may not look how I intended.
	## Optimal desktop gui terminal Size

	## Resize if the shell is a Desktop app, or not a Linux login term

	processPidName=$(echo $TERM)

	if [ $processPidName = "xterm" ] || [ $processPidName = "xterm-256color" ] && [ $processPidName != "linux" ]; then

		if [ $(tput cols) -lt 140 ]; then
			isWideEnough=0
		else
			isWideEnough=1
		fi

		if [ $(tput lines) -lt 40 ]; then
			isTallEnough=0
		else
			isTallEnough=1
		fi

		## perform resize
		if [ $isWideEnough -eq 0 ] || [ $isTallEnough -eq 0 ]; then
			resize -s 40 140 &>/dev/null
			stty rows 40
			stty cols 140

			echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
			clear
		fi
	fi

	currentScrrenWidth=$(tput cols)
	currentScreenHeight=$(tput lines)
}

function updateScreenSize {
	if [ $currentScrrenWidth -ne $(tput cols) ]; then
		currentScrrenWidth=$(tput cols)
		echo "$CLR_ALL$BACKGROUNDCOLOR$FOREGROUNDCOLOR"
		clear
	fi

	if [ $currentScreenHeight -ne $(tput lines) ]; then
		currentScreenHeight=$(tput lines)
		echo "$CLR_ALL$BACKGROUNDCOLOR$FOREGROUNDCOLOR"
		clear
	fi
}

function launchXterm {
	hostedDirPath=$(dirname $0)
	processPidName=$(echo $TERM)

	case $processPidName in
		"xterm" | "xterm-256color" )	## xterm
					resizeWindow
					;;
		"linux" )	## login terminal
					isLinuxTerminal=1
					;;
	esac

}

#
# Ogg Audio File Paths
#

function setBeadAudio {
	## prayerIndex
	## set audio media to match the current prayer

	currentDirPath=$(dirname $0)
	isLiveStreaming=0

	case $prayerIndex in
		0 ) ## none
			beadAudioFile="$currentDirPath/source/ogg/beep.ogg"
			;;
		1 ) ## sign of the cross
			beadAudioFile=$currentDirPath/source/ogg/'01 Sign of the cross.ogg'
			;;
		2 ) ## Credo
			beadAudioFile="$currentDirPath/source/ogg/Byrd_4-Part_Mass_-_Credo.ogg"
			;;
		3 ) ## PaterNoster
			beadAudioFile="$currentDirPath/source/ogg/Schola_Gregoriana-Pater_Noster.ogg"
			;;
		4 ) ## AveMaria
			beadAudioFile="$currentDirPath/source/ogg/Schola_Gregoriana-Ave_Maria.ogg"
			## beadAudioFile="$currentDirPath/source/ogg/JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg"
			;;
		5 ) ## GloriaPatri
			beadAudioFile="$currentDirPath/source/ogg/The_Tudor_Consort_-_J_S_Bach_-_Magnificat_BWV_243_-_Gloria_Patri.ogg"
			;;
		6 ) ## Fatima Prayer
			beadAudioFile="$currentDirPath/source/ogg/WindChime.ogg"
			;;
		7 ) ## SalveRegina
			beadAudioFile="$currentDirPath/source/ogg/Petits_Chanteurs_de_Passy_-_Salve_Regina_de_Hermann_Contract.ogg"
			;;
		8 ) ## Oremus
			beadAudioFile="$currentDirPath/source/ogg/WindChime.ogg"
			;;
		9 ) ## Litaniae Lauretanae
			beadAudioFile="$currentDirPath/source/ogg/WindChime.ogg"
			;;
		* ) ## none
			beadAudioFile="$currentDirPath/source/ogg/beep.ogg"
			;;
	esac

}
