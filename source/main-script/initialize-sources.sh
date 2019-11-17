#!/bin/bash

function translationDB {

	hostedDirPath=$(dirname $0)

	## define DB within a global var
	if [ $translation -eq 1 ]; then
		# NAB
		rosaryJSON=`echo $hostedDirPath/json-db/rosaryJSON-nab.json`
		translationName="The New American Bible (NAB)"
	fi

	if [ $translation -eq 2 ]; then
		# Vulgate
		rosaryJSON=`echo $hostedDirPath/json-db/rosaryJSON-vulgate.json`
		translationName="Vulgate (Latin)"
	fi
}

function initializeFlags {
	# Save screen
	tput smcup

	BACKGROUNDCOLOR=${BG_BLACK}
	FOREGROUNDCOLOR=${FG_GREEN}
	BAR_BG=${BG_GREEN}
	BAR_FG=${FG_BLACK}
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	clear

	directionFwRw=1
	initialMysteryFlag=0
	initialHailMaryCounter=0
	stringSpaceCounter=0
	hailmaryCounter=0
	beadCounter=0
	thisDecadeSet=0
	mysteryProgress=0

	## instrumental version. Not used
	beadAudioFile="$currentDirPath/source/ogg/JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg"

	introFlag=1
	translation=1
	isMenuOpen=0

	echo "pauseFlag 0" > source/main-script/temp/localFlags
	autoPilot=0
	grep -v "autoPilot" source/main-script/temp/localFlags > temp && mv temp source/main-script/temp/localFlags
	echo "autoPilot 0 $(date)" >> source/main-script/temp/localFlags

	## Autopilot
	if [ ! -z "$inputTag" ]; then

		case "$inputTag" in
			"-a" | "-A" ) # menu
				autoPilot=1

				## focre latin text
				translation=2
				grep -v "autoPilot" source/main-script/temp/localFlags > temp && mv temp source/main-script/temp/localFlags
				echo "autoPilot 1 $(date)" >> source/main-script/temp/localFlags
				;;
			"-l" | "-L" ) # menu
				translation=2
				;;
		esac
	fi

	## Set initial pulseaudio system volume
	amixer set Master 30% </dev/null >/dev/null 2>&1

	## determine mystery of the day
	initializeFeastFlags
	trigger_feastDay
	mystery_Day

	## declare init language translation
	translationDB
}

function mainInit {
	#download_dependencies
	launchXterm
	resizeWindow
}

function myMian {
	resizeWindow

	decorativeColors
	inputControlls
	initializeFlags

	## hide cursor
	tput civis

	splashScreen
	welcomepage
	howToPage

	## turn off intro flag
	introFlag=0

	mainNavigation
}

function download_dependencies {
	currentDirPath=$(dirname $0)
	bash "$currentDirPath/source/gnu/download-gnu-software"
}
