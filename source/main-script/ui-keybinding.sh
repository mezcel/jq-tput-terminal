#!/bin/bash
###################################################
## Keyboard Arrows UI
###################################################

function beadFWD {
	directionFwRw=1
	beadCounter=$((beadCounter+1))

	rosaryBeadID=$beadCounter
	# jqQuery
	determine_what_to_query


	if [ $beadCounter -eq $counterMAX ]; then
		# reset counter
		beadCounter=0
	fi
}

function beadREV {
	if [ $beadCounter -gt $counterMIN ]; then
		directionFwRw=0
		beadCounter=$((beadCounter-1))

		rosaryBeadID=$beadCounter
		# jqQuery
		determine_what_to_query
	fi
}

function killAutopilot {
	goodbyescreen

	if pgrep -x "ogg123" &>/dev/null
	then
		killall ogg123 &>/dev/null; killall bash-rosary &>/dev/null
	else
		killall bash-rosary &>/dev/null
	fi
	exit
}

function arrowInputs {

	while read -sN1 key
	do
		## catch 3 multi char sequence within a time window
		## null outputs in case of random error msg
		read -s -n1 -t 0.0001 k1 &>/dev/null
		read -s -n1 -t 0.0001 k2 &>/dev/null
		read -s -n1 -t 0.0001 k3 &>/dev/null
		key+=${k1}${k2}${k3} &>/dev/null

		case "$key" in
			$arrowUp | "w" | "W" | "j" | "J" ) # menu
				menuUP

				## hide cursor
				tput civis
				;;
			$arrowDown | "s" | "S" | "k" | "K" ) # language toggle
				menuDN

				## hide cursor
				tput civis
				;;
			$arrowRt | $returnKey | "d" | "D" | "l" | "L" | "n" | "N" ) # navigate forward
				if [ $introFlag -ne 1 ]; then
					blank_transition_display
					beadFWD
					tput civis
					bundledDisplay
					setBeadAudio

					## kill audio when navigating
					if pgrep -x "ogg123" &>/dev/null
					then
						killall ogg123 &>/dev/null
					fi

				fi
				;;
			$arrowLt | "h" | "H" | "a" | "A" | "b" | "B" ) # navigate back
				blank_transition_display
				beadREV
				tput civis
				bundledDisplay
				setBeadAudio

				## kill audio when navigating
				if pgrep -x "ogg123" &>/dev/null
				then
					killall ogg123 &>/dev/null
				fi

				;;
			"m" | "M" | "p" | "P" ) # ogg123 audio player
				if ! pgrep -x "ogg123" > /dev/null
				then
					ogg123 -q "$beadAudioFile" </dev/null >/dev/null 2>&1 &
					sleep .5s
				else
					if pgrep -x "ogg123" &>/dev/null
					then
						killall ogg123 &>/dev/null
					fi

					sleep .5s
				fi
				;;
			"q" | "Q" | $escKey ) # Force quit app and mplayer and xterm
				autoPilot=0
				killAutopilot
				;;
		esac

	done

	# Restore screen
    tput rmcup
}

function removeTempVarFile {
	currentDirPath=$(dirname $0)
	if [ -f $currentDirPath/source/main-script/temp/varFile ] ; then
		rm $currentDirPath/source/main-script/temp/varFile
	fi
}

function beforeUpDnMenu_autopilot {
	currentDirPath=$(dirname $0)
	if ! [ -f $currentDirPath/source/main-script/temp/varFile ] ; then
		echo "$beadCounter,$hailmaryCounter,$thisDecadeSet,$mysteryProgress,$(date)" > $currentDirPath/source/main-script/temp/varFile
	fi
}

function afterUpDnMenu_autopilot {
	currentDirPath=$(dirname $0)
	if [ -f $currentDirPath/source/main-script/temp/varFile ] ; then

		tempTxtToVar=$(cat $currentDirPath/source/main-script/temp/varFile)

		beadCounter=$( echo $tempTxtToVar | cut -d "," -f 1 )
		rosaryBeadID=$beadCounter
		hailmaryCounter=$( echo $tempTxtToVar | cut -d "," -f 2 )
		thisDecadeSet=$( echo $tempTxtToVar | cut -d "," -f 3 )
		mysteryProgress=$( echo $tempTxtToVar | cut -d "," -f 4 )

		 clear
		 blank_transition_display
		 jqQuery
		 bundledDisplay
		 setBeadAudio

		rm $currentDirPath/source/main-script/temp/varFile
	fi
}

function musicalAutoPilot {
	## turn off user input, ctrl+c to exit
	stty -echo

	setBeadAudio
	ogg123 -q "$beadAudioFile" </dev/null >/dev/null 2>&1 &
	sleep .5s

	autoPilot=1
	isMenuOpen=0
	removeTempVarFile

	while [ $autoPilot -eq 1 ]
	do
		## isOggPlaying=$(echo pgrep -x "ogg123")
		if ! pgrep -x "ogg123" > /dev/null
		then
			currentDirPath=$(dirname $0)
			if [ -f $currentDirPath/source/main-script/temp/varFile ] ; then
				isMenuOpen=1
				beadFWD
				setBeadAudio
				ogg123 -q "$beadAudioFile" </dev/null >/dev/null 2>&1 &
				echo "$beadCounter,$hailmaryCounter,$thisDecadeSet,$mysteryProgress,$(date)" > $currentDirPath/source/main-script/temp/varFile
			else
				blank_transition_display
				beadFWD
				bundledDisplay
				setBeadAudio
				ogg123 -q "$beadAudioFile" </dev/null >/dev/null 2>&1 &
			fi
		fi

	done & while read -sN1 key
	do
		## catch 3 multi char sequence within a time window
		## null outputs in case of random error msg
		read -s -n1 -t 0.0001 k1 &>/dev/null
		read -s -n1 -t 0.0001 k2 &>/dev/null
		read -s -n1 -t 0.0001 k3 &>/dev/null
		key+=${k1}${k2}${k3} &>/dev/null

		case "$key" in
			$arrowUp ) # menu
				isMenuOpen=1
				beforeUpDnMenu_autopilot

				menuUPautopilot
				afterUpDnMenu_autopilot

				## hide cursor
				tput civis
				;;

			$arrowDown ) # language toggle
				isMenuOpen=1
				beforeUpDnMenu_autopilot

				menuDN
				afterUpDnMenu_autopilot

				## hide cursor
				tput civis
				;;

			"q" | "Q" | $escKey ) # Force quit app and mplayer and xterm
				autoPilot=0
				removeTempVarFile
				killAutopilot
				;;
		esac

	done
}

function mainNavigation {
	counterMIN=0
	counterMAX=315

	rosaryBeadID=$beadCounter
	bundledDisplay
	setBeadAudio

	if [ $autoPilot -eq 0 ]; then
		## Keyboard Controlls
		arrowInputs
	else
		## Auto Pilot
		musicalAutoPilot
	fi
}
