#!/bin/bash
###################################################
## Keyboard Arrows UI
###################################################

function positionLog {
	grep -v "positionLog" source/main-script/temp/localFlags > temp && mv temp source/main-script/temp/localFlags
	echo "positionLog $beadCounter $hailmaryCounter $thisDecadeSet $mysteryProgress $(date)" >> $currentDirPath/source/main-script/temp/localFlags
}

function setPauseFlag {
	grep -v "pauseFlag" source/main-script/temp/localFlags > temp && mv temp source/main-script/temp/localFlags
	echo "pauseFlag 1 $(date)" >> $currentDirPath/source/main-script/temp/localFlags
}

function unsetPauseFlag {
	grep -v "pauseFlag" source/main-script/temp/localFlags > temp && mv temp source/main-script/temp/localFlags
	echo "pauseFlag 0 $(date)" >> $currentDirPath/source/main-script/temp/localFlags
}

function setAutoPilotFlag {
	grep -v "autoPilot" source/main-script/temp/localFlags > temp && mv temp source/main-script/temp/localFlags
	echo "autoPilot 1 $(date)" >> $currentDirPath/source/main-script/temp/localFlags
}

function unsetAutoPilotFlag {
	grep -v "autoPilot" source/main-script/temp/localFlags > temp && mv temp source/main-script/temp/localFlags
	echo "autoPilot 0 $(date)" >> $currentDirPath/source/main-script/temp/localFlags
}

function beadFWD {
	directionFwRw=1
	beadCounter=$((beadCounter+1))

	rosaryBeadID=$beadCounter
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
		determine_what_to_query
	fi
}

function killAutopilot {
	goodbyescreen

	if pgrep -x "ogg123" &>/dev/null
	then
		killall ogg123 &>/dev/null && killall bash-rosary &>/dev/null
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

				setPauseFlag
				clear
				menuUP

				## hide cursor
				tput civis
				;;
			$arrowDown | "s" | "S" | "k" | "K" ) # language toggle

				setPauseFlag
				clear
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

					positionLog

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

				positionLog

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

				unsetAutoPilotFlag
				autoPilot=0
				killAutopilot

				re_clear_termainal
				;;
		esac

	done

	# Restore screen
    #tput rmcup
    re_clear_termainal
}

function afterUpDnMenu_autopilot {
	currentDirPath=$(dirname $0)

	beadCounter=$(grep "positionLog" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $2}')
	rosaryBeadID=$beadCounter
	hailmaryCounter=$(grep "positionLog" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $3}')
	thisDecadeSet=$(grep "positionLog" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $4}')
	mysteryProgress=$(grep "positionLog" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $5}')
	#sleep 1s

	clear
	blank_transition_display
	jqQuery
	bundledDisplay
	unsetPauseFlag
	isPauseFlag=0
	#sleep 1s
	setBeadAudio

}

function musicalAutoPilot {

	## turn off user input echo, ctrl+c to exit
	stty -echo

	## check if alsamixer is possible
	isAlsaMixer=$(command -v alsamixer)
	if [ -z $isAlsaMixer ]; then
		isAlsaMixer=0;
	else
		isAlsaMixer=1;
	fi

	if [ $isAlsaMixer -eq 1 ]; then
		setBeadAudio
		ogg123 -q "$beadAudioFile" </dev/null >/dev/null 2>&1 &
		sleep .1s

		## Wait for the Sugnum Crusis prayer to finish before continuing with user controls
		while pgrep -x "ogg123" > /dev/null
		do
			isPauseFlag=0
		done
	fi

	while [ $autoPilot -eq 1 ]
	do

		autoPilot=$(grep "autoPilot" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $2}')
		isPauseFlag=$(grep "pauseFlag" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $2}')
		sleep 1s

		if [ -z $isPauseFlag ]; then
			isPauseFlag=0
		fi

		if [ $isPauseFlag -eq 0 ]; then

			if ! pgrep -x "ogg123" > /dev/null
			then
				currentDirPath=$(dirname $0)
				blank_transition_display
				autoPilot=$(grep "autoPilot" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $2}')

				beadFWD
				positionLog

				bundledDisplay

				if [ $isAlsaMixer -eq 1 ]; then
					setBeadAudio
					ogg123 -q "$beadAudioFile" </dev/null >/dev/null 2>&1 &
				else
					sleep 5s
				fi
			fi

		fi

	done & while read -sN1 key
	do
		autoPilot=$(grep "autoPilot" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $2}')
		isPauseFlag=$(grep "pauseFlag" $currentDirPath/source/main-script/temp/localFlags | awk '{printf $2}')

		if [ $autoPilot -eq 1 ] && [ $isPauseFlag -eq 0 ] ; then

			## catch 3 multi char sequence within a time window
			## null outputs in case of random error msg
			read -s -n1 -t 0.0001 k1 &>/dev/null
			read -s -n1 -t 0.0001 k2 &>/dev/null
			read -s -n1 -t 0.0001 k3 &>/dev/null
			key+=${k1}${k2}${k3} &>/dev/null

			case "$key" in

				$arrowUp | "w" | "W" | "j" | "J" ) # menu

					setPauseFlag
					isPauseFlag=1

					menuUPautopilot
					afterUpDnMenu_autopilot

					## hide cursor
					#tput civis
					;;

				"q" | "Q" | $escKey ) # Force quit app and mplayer and xterm

                    clear
					width=$( tput cols )
					height=$( tput lines )
					str="Terminal Rosary using Jq and Bash"
					length=${#str}
					centerText=$(( ( width / 2 )-( length / 2 ) ))
					tput cup $((height/2 )) $centerText
					echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
					str="Goodbye"
					length=${#str}
					centerText=$((( width/ 2 )-( length / 2 )))
					tput cup $height $centerText
					echo $str

					## Exit delay
					read -t 3
					re_clear_termainal

					if pgrep -x "ogg123" &>/dev/null
					then
						re_clear_termainal
						killall ogg123 &>/dev/null && killall bash-rosary &>/dev/null
					else
						re_clear_termainal
						killall bash-rosary &>/dev/null
					fi
					re_clear_termainal
					;;
			esac

		else
			clear
			unsetAutoPilotFlag
			autoPilot=0
			killAutopilot
		fi

	done
}

function mainNavigation {
	counterMIN=0
	counterMAX=315

	rosaryBeadID=$beadCounter

	if [ -f source/main-script/temp/localFlags ]; then
		autoPilot=$(grep "autoPilot" source/main-script/temp/localFlags | awk '{printf $2}')

		if [ $autoPilot -eq 1 ]; then
			my_titlebar "bash-rosary (Autopilot: Latin Chant)"
		else
			autoPilot=0
			my_titlebar "bash-rosary"
		fi
	else
		autoPilot=0
		my_titlebar "bash-rosary"
	fi

	bundledDisplay
	setBeadAudio

	if [ $autoPilot -eq 0 ]; then
		## Keyboard Controls
		arrowInputs
	else
		## Auto Pilot
		musicalAutoPilot
	fi
}
