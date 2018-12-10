#!/bin/sh

function decorativeColors() {
	## ${Black}
	## https://en.wikipedia.org/wiki/ANSI_escape_code
	## https://linux.101hacks.com/ps1-examples/prompt-color-using-tput/
	## Usage example: echo "abcd $MODE_BEGIN_UNDERLINE edf $MODE_EXIT_UNDERLINE $FG_RED hijk $STYLES_OFF

	## Forground Color using ANSI escape

	FG_BLACK=$(tput setaf 0)
	FG_RED=$(tput setaf 1)
	FG_GREEN=$(tput setaf 2)
	FG_YELLOW=$(tput setaf 3)
	FG_BLUE=$(tput setaf 4)
	FG_MAGENTA=$(tput setaf 5)
	FG_CYAN=$(tput setaf 6)
	FG_WHITE=$(tput setaf 7)
	FG_NoColor=$(tput sgr0)

	## Background Color using ANSI escape

	BG_BLACK=$(tput setab 0)
	BG_RED=$(tput setab 1)
	BG_GREEN=$(tput setab 2)
	BG_YELLOW=$(tput setab 3)
	BG_BLUE=$(tput setab 4)
	BG_MAGENTA=$(tput setab 5)
	BG_CYAN=$(tput setab 6)
	BG_WHITE=$(tput setab 7)
	BG_NoColor=$(tput sgr0)

	## set mode using ANSI escape

	MODE_BOLD=$(tput bold)
	MODE_DIM=$(tput dim)
	MODE_BEGIN_UNDERLINE=$(tput smul)
	MODE_EXIT_UNDERLINE=$(tput rmul)
	MODE_REVERSE=$(tput rev)
	MODE_ENTER_STANDOUT=$(tput smso)
	MODE_EXIT_STANDOUT=$(tput rmso)

	## clear styles using ANSI escape
	STYLES_OFF=$(tput sgr0)

	## Clear screen and home cursor
	CLR_ALL=$(tput clear)

	## horizontal line across screen
	hr=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' ".")
}

function inputControlls() {
	arrowUp=$'\e[A'
	arrowDown=$'\e[B'
	arrowRt=$'\e[C'
	arrowLt=$'\e[D'
	# escKey=$'\['
	# f1Key=$'\[OP'
}

## JQ

function jqQuery() {
	## The logest query rout
	
	query_beadIndex=.rosaryBead[$rosaryBeadID].beadIndex
	query_decadeIndex=.rosaryBead[$rosaryBeadID].decadeIndex
	query_mysteryIndex=.rosaryBead[$rosaryBeadID].mysteryIndex
	query_prayerIndex=.rosaryBead[$rosaryBeadID].prayerIndex
	query_scriptureIndex=.rosaryBead[$rosaryBeadID].scriptureIndex
	query_messageIndex=.rosaryBead[$rosaryBeadID].messageIndex

	beadIndex=$(jq $query_beadIndex $rosaryJSON)
	decadeIndex=$(jq $query_decadeIndex $rosaryJSON)
	mysteryIndex=$(jq $query_mysteryIndex $rosaryJSON)
	prayerIndex=$(jq $query_prayerIndex $rosaryJSON)
	scriptureIndex=$(jq $query_scriptureIndex $rosaryJSON)
	messageIndex=$(jq $query_messageIndex $rosaryJSON)

	query_beadID=.bead[$beadIndex].beadID
	query_beadType=.bead[$beadIndex].beadType
	# query_decadeID=.decade[$decadeIndex].decadeID
	query_decadeName=.decade[$decadeIndex].decadeName
	query_mysteryName=.mystery[$mysteryIndex].mysteryName
	query_prayerText=.prayer[$prayerIndex].prayerText
	query_scriptureText=.scripture[$scriptureIndex].scriptureText
	query_mesageText=.message[$messageIndex].mesageText

	return_beadID=$(jq $query_beadID $rosaryJSON)
	return_beadType=$(jq $query_beadType $rosaryJSON)
	# return_decadeID=$(jq $query_decadeID $rosaryJSON)
	return_decadeName=$(jq $query_decadeName $rosaryJSON)
	return_mysteryName=$(jq $query_mysteryName $rosaryJSON)
	return_prayerText=$(jq $query_prayerText $rosaryJSON)
	return_scriptureText=$(jq $query_scriptureText $rosaryJSON)
	return_mesageText=$(jq $query_mesageText $rosaryJSON)

	beadID=$return_beadID
	beadType=$return_beadType
}

## Progressbars

function decade_progressbar() {
	echo ""
	
	if [ -z ${thisDecadeSet+set} ]; then
		# echo "introduction prayer beads: $initialHailMaryCounter/3"
		# printf '%*s\n' "${COLUMNS:-$width}" '' | tr ' ' '-'
		echo
	else
		echo "decade progressbar: $thisDecadeSet/10"
		proportion=$thisDecadeSet/10
		width=$(tput cols)
		width=$((width*$proportion))
		barDecade=$(printf '%*s\n' "${COLUMNS:-$width}" '' | tr ' ' '|')
		echo $BAR_BG$BAR_FG$barDecade$BACKGROUNDCOLOR$FOREGROUNDCOLOR
	fi
	echo ""
}

function mystery_progressbar() {
	
	if [ -z ${mysteryProgress+set} ]; then
		# echo "introduction prayer beads"
		# echo "Progressbars will be applied once the mystery circuit begins"
		# printf '%*s\n' "${COLUMNS:-$width}" '' | tr ' ' '-'
		echo
	else
		echo "mystery peogressbar: $mysteryProgress/50"
		proportion=$mysteryProgress/50
		width=$(tput cols)
		width=$((width*$proportion))
		barMystery=$(printf '%*s\n' "${COLUMNS:-$width}" '' | tr ' ' '|')
		echo $BAR_BG$BAR_FG$barMystery$BACKGROUNDCOLOR$FOREGROUNDCOLOR
	fi
	
	echo ""
}

function beadProgress() {
	case $beadID in
        2)  ## small beads
			if [ $decadeIndex -ne 0 ]; then
			
				if [ $directionFwRw -eq 1 ]; then
					## fwd
					hailmaryCounter=$(( $hailmaryCounter + 1))
				else
					## rev
					hailmaryCounter=$(( $hailmaryCounter - 1))
				fi
	
				thisDecadeSet=$((thisDecadeSet=hailmaryCounter % 10))
				(( moddivision=hailmaryCounter % 10))
				if [ $moddivision -eq 0 ]; then
					thisDecadeSet=10
				fi
				
				mysteryProgress=$((mysteryProgress=hailmaryCounter % 50))
				(( moddivision=hailmaryCounter % 50))
				if [ $moddivision -eq 0 ]; then
					mysteryProgress=50
				fi

				# decade_progressbar
				# mystery_progressbar

			fi

			# handles only the intro hail marys
			if [ $decadeIndex -eq 0 ]; then
				if [ $directionFwRw -eq 1 ]; then
					if [ $initialHailMaryCounter -eq 0 ]; then
						initialHailMaryCounter=1
					else
						initialHailMaryCounter=$(($initialHailMaryCounter + 1))
					fi
				else
					if [ $initialHailMaryCounter -eq 0 ]; then
						$initialHailMaryCounter=3
					else
						initialHailMaryCounter=$(($initialHailMaryCounter - 1))
					fi
				fi
			fi

			stringSpaceCounter=0
			
            ;;
		3)	## big bead
			stringSpaceCounter=0
            initialHailMaryCounter=0

            if [ $directionFwRw -ne 1 ]; then
				moddivision=$(( hailmaryCounter % 10 ))
				if [ $moddivision -gt 0 ]; then
					hailmaryCounter=$(( $hailmaryCounter - 1 ))
				fi
            fi
            ;;
        4) ## string space
			if [ $directionFwRw -eq 1 ]; then
			## fwd
				if [ $stringSpaceCounter -eq 0 ]; then
					stringSpaceCounter=1
					moddivision=$(( hailmaryCounter % 10 ))
					if [ $moddivision -eq 0 ]; then
						hailmaryCounter=$(( $hailmaryCounter + 1 ))
					fi
				else
					stringSpaceCounter=2
					moddivision=$(( hailmaryCounter % 10 ))
					if [ $moddivision -gt 0 ]; then
						hailmaryCounter=$(( $hailmaryCounter - 1 ))
					fi
				fi
			else
			## rev
				if [ $stringSpaceCounter -eq 0 ]; then
					stringSpaceCounter=2
					moddivision=$(( hailmaryCounter % 10 ))
					if [ $moddivision -gt 0 ]; then
						hailmaryCounter=$(( $hailmaryCounter - 1 ))
					fi
				else
					stringSpaceCounter=1
					(( moddivision=hailmaryCounter % 10 ))
					if [ $moddivision -eq 0 ]; then
						hailmaryCounter=$(( $hailmaryCounter + 1 ))
					fi
				fi
            fi
            ;;
        5)	## Mary Icon
			if [ $directionFwRw -eq 1 ]; then
				stringSpaceCounter=3
			fi
			
            stringSpaceCounter=0;

			## mystery according to day of week
            if [ $initialMysteryFlag -eq 0 ]; then
                beadCounter=$mysteryJumpPosition
                initialMysteryFlag=1
            fi            
			;;
		6)	## cross
			initialHailMaryCounter=0
            stringSpaceCounter=0
			;;
        *)
			thisDecadeSet=0
            stringSpaceCounter=0
            ;;
      esac
}

## Display

function myAbout() {
	aboutText="This is a Rosary App for the Linux Bash terminal.\nThis app was tested on the default Xterm on Arch.\n\nGithub: https://github.com/mezcel/jq-tpy-terminal.git"
	
	whiptail \
        --title "About" \
        --msgbox "$aboutText" 0 0
}

function splashScreen() {
	echo "$CLR_ALL"
	width=$(tput cols)
	height=$(tput lines)
	str="Termainal Rosary using Jq and Bash"
	length=${#str}
	tput cup $((height/2)) $(((width/ 2)-(length/2)))
	echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
	str="< Lt navigate Rt > ( Up menus Dn ) [Enter]"
	length=${#str}
	tput cup $height $(((width/ 2)-(length/2)))
	echo $str

	## prompt for enter
	read -s welcomeVar
}

function mysteryDay() {
	dayOfWeek=$(date +"%a")
	case "$dayOfWeek" in
		"Sun")
			dayMysteryIndex=4
			mysteryJumpPosition=244
			;;
		"Mon")
			dayMysteryIndex=1
			mysteryJumpPosition=7
			;;
		"Tue")
			dayMysteryIndex=3
			mysteryJumpPosition=165
			;;
		"Wed")
			dayMysteryIndex=4
			mysteryJumpPosition=244
			;;
		"Thu")
			dayMysteryIndex=2
			mysteryJumpPosition=86
			;;
		"Fri")
			dayMysteryIndex=3
			mysteryJumpPosition=165
			;;
		"Sat")
			dayMysteryIndex=1
			mysteryJumpPosition=7
			;;
		*) # echo "waiting" ;;
	esac
}

function welcomepage() {
	clear
	
	str="Termainal Rosary using Jq and Bash"
	width=$(tput cols)
	length=${#str}
	tput cup 0 $(((width/ 2)-(length/2)))
	echo $str
	
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."

	query_mysteryName=.mystery[$dayMysteryIndex].mysteryName
	query_prayerText=.prayer[1].prayerText

	return_mysteryName=$(jq $query_mysteryName $rosaryJSON)
	return_prayerText=$(jq $query_prayerText $rosaryJSON)

	htmlHR="\<hr\>"
	bashEcho="${MODE_DIM}Guidance: "
	return_prayerText=${return_prayerText/$htmlHR/$bashEcho}
	
	echo "
	Today is a: $dayOfWeek
	The Mystery of the day is: $return_mysteryName


	Note:	Do not navigate too fast. Allow a moment to complete text querying.
		JQ is a C based JSON Parser & I took the longest query rout to retrieve text.
	
	"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "~"
	echo " Begin:

	"	
	echo "$return_prayerText

	${STYLES_OFF}${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	"
	echo "Use the Arrow keys to navigate."
	
			
	introFlag=0
	# key=$arrowRt
}

function goodbyscreen() {
	#clear
	echo "$CLR_ALL"
	
	width=$(tput cols)
	height=$(tput lines)
	str="Termainal Rosary using Jq and Bash"
	length=${#str}
	tput cup $((height/2)) $(((width/ 2)-(length/2)))
	echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
	str="Thank you"
	length=${#str}
	tput cup $height $(((width/ 2)-(length/2)))
	echo $str

	sleep 4
}

function blank_transition_display() {
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	clear
	# echo "$CLR_ALL"
	
	echo " $translationName"
	tput cup $(tput lines)-1 $[$(tput cols)-28]; echo `date`
	
	width=$(tput cols)
	str="Termainal Rosary using Jq and Bash"
	tput cup 0 $(((width/ 2)-(length/2)))
	echo $str
	
	# echo "$hr"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."
	
	echo "$MODE_BEGIN_UNDERLINE Mystery Name: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	loading ..."; echo ""
	echo "$MODE_BEGIN_UNDERLINE Mystery Message: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	loading ..."; echo ""
	echo "$MODE_BEGIN_UNDERLINE Mystery Decade: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	loading ..."; echo ""
	echo "$MODE_BEGIN_UNDERLINE Scripture Text: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	loading ..."; echo ""
	echo "$MODE_BEGIN_UNDERLINE Prayer Text: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	loading ...
	"; echo ""
	echo "$MODE_BEGIN_UNDERLINE Bead Type: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	loading ..."
	
	# echo "$hr"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."

	decade_progressbar
	mystery_progressbar
}

function tputBeadDisplay() {
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	clear
	# echo "$CLR_ALL"
		
	echo " $translationName"
	tput cup $(tput lines)-1 $[$(tput cols)-28]; echo `date`
	
	width=$(tput cols)
	str="Termainal Rosary using Jq and Bash"
	tput cup 0 $(((width/ 2)-(length/2)))
	echo $str
	
	## Remove Quotes from vars
	temp="${return_mysteryName%\"}"; temp="${temp#\"}"
	return_mysteryName=$temp
	temp="${return_mesageText%\"}"; temp="${temp#\"}"
	return_mesageText=$temp
	temp="${return_decadeName%\"}"; temp="${temp#\"}"
	return_decadeName=$temp
	temp="${return_scriptureText%\"}"; temp="${temp#\"}"
	return_scriptureText=$temp
	temp="${return_prayerText%\"}"; temp="${temp#\"}"
	return_prayerText=$temp
	temp="${return_beadType%\"}"; temp="${temp#\"}"
	return_beadType=$temp

	htmlHR="\<hr\>"
	bashEcho="${MODE_DIM}
	Translation: "
	return_scriptureText=${return_scriptureText/$htmlHR/$bashEcho}
	
	#echo "$hr"
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."
	
	echo "$MODE_BEGIN_UNDERLINE Mystery Name: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	$return_mysteryName"; echo ""
	echo "$MODE_BEGIN_UNDERLINE Mystery Message: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	$return_mesageText"; echo ""
	echo "$MODE_BEGIN_UNDERLINE Mystery Decade: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	$return_decadeName"; echo ""
	echo "$MODE_BEGIN_UNDERLINE Scripture Text: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	$return_scriptureText"${STYLES_OFF}${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}; echo ""
	echo "$MODE_BEGIN_UNDERLINE Prayer Text: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	$return_prayerText"; echo ""
	echo "$MODE_BEGIN_UNDERLINE Bead Type: $MODE_EXIT_UNDERLINE"; echo ""
	echo "	$return_beadType"
	
}

function bundledDisplay() {
	tputBeadDisplay
	# echo $hr
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."
	
	beadProgress
	decade_progressbar
	mystery_progressbar
}

function change_color_menu() {
	
	screenTitle="Termainal Rosary using Jq and Bash"
	dialogTitle="Background Color Menu"
	selectedBackgroundColor=$(dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select a background color: \
		\n WIP" \
		0 0 0 \
		"1" "Black"\
		"2" "Magenta"\
		"3" "Red"\
		"4" "Yellow"\
		"5" "Cyan"\
		"6" "Blue"\
		"7" "White"\
		"8" "Green"\
		"9"	"No Style")
		
	case "$selectedBackgroundColor" in
		1) # Black
			BACKGROUNDCOLOR=${BG_BLACK}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_BLACK}
			;;
		2) # Magenta
			BACKGROUNDCOLOR=${BG_MAGENTA}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_MAGENTA}
			;;
		3) # Red
			BACKGROUNDCOLOR=${BG_RED}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_RED}
			;;
		4) #Yellow
			BACKGROUNDCOLOR=${BG_YELLOW}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_YELLOW}
			;;
		5) # Cyan
			BACKGROUNDCOLOR=${BG_CYAN}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_CYAN}
			;;
		6) # Blue
			BACKGROUNDCOLOR=${BG_BLUE}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_BLUE}
			;;
		7) # White
			BACKGROUNDCOLOR=${BG_WHITE}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_WHITE}
			;;
		8) # Green
			BACKGROUNDCOLOR=${BG_GREEN}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_GREEN}
			;;
		9) # No Style
			BACKGROUNDCOLOR=${BG_NoColor}; echo ${BACKGROUNDCOLOR}
			BAR_FG=${FG_NoColor}
			;;
		*) # echo "waiting" ;;
	esac

	dialogTitle="Foreground Color Menu"
	selectedForegroundColor=$(dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select a foreground color: \
		\n WIP" \
		0 0 0 \
		"1" "Black"\
		"2" "Magenta"\
		"3" "Red"\
		"4" "Yellow"\
		"5" "Cyan"\
		"6" "Blue"\
		"7" "White"\
		"8" "Green"\
		"9"	"No Style")
		
	case "$selectedForegroundColor" in
		1) # Black
			FOREGROUNDCOLOR=${FG_BLACK}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_BLACK}
			;;
		2) # Magenta
			FOREGROUNDCOLOR=${FG_MAGENTA}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_MAGENTA}
			;;
		3) # Red
			FOREGROUNDCOLOR=${FG_RED}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_RED}}
			;;
		4) #Yellow
			FOREGROUNDCOLOR=${FG_YELLOW}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_YELLOW}
			;;
		5) # Cyan
			FOREGROUNDCOLOR=${FG_CYAN}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_CYAN}}
			;;
		6) # Blue
			FOREGROUNDCOLOR=${FG_BLUE}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_BLUE}
			;;
		7) # White
			FOREGROUNDCOLOR=${FG_WHITE}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_WHITE}
			;;
		8) # Green
			FOREGROUNDCOLOR=${FG_GREEN}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_GREEN}
			;;
		9) # No Style
			FOREGROUNDCOLOR=${FG_NoColor}; echo ${FOREGROUNDCOLOR}
			BAR_BG=${BG_NoColor}
			;;
		*) # echo "waiting" ;;
	esac
	
}

## Arrows

function beadFWD() {
	directionFwRw=1
	beadCounter=$((beadCounter+1))
	
	rosaryBeadID=$beadCounter				
	jqQuery

	## keep the terminal from looping too fast
	# sleep 1
	
	if [ $beadCounter -eq $counterMAX ]; then
		# reset counter
		beadCounter=0
	fi
}
	
function beadREV() {
	
	if [ $beadCounter -gt $counterMIN ]; then
		directionFwRw=0
		beadCounter=$((beadCounter-1))
		
		rosaryBeadID=$beadCounter				
		jqQuery
	fi
}

function menuUP() {
	screenTitle="Termainal Rosary using Jq and Bash"
	dialogTitle="Menu"
	selectedMenuItem=$(dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select an option:\
		\n WIP" \
		0 0 0 \
		"1" "Instruction/About"\
		"2" "Start Joyful Mystery"\
		"3" "Start Luminous Mystery"\
		"4" "Start Sorrowfull Mystery"\
		"5" "Start Glorious Mystery"\
		"6"	"View Prayers"\
		"7" "Change Color Theme"\
		"8" "Exit App")

	case "$selectedMenuItem" in
		1)	## About
			myAbout
			;;
		2)	## Joyful
			mysteryJumpPosition=7
			beadCounter=$mysteryJumpPosition
			rosaryBeadID=$beadCounter
			hailmaryCounter=0
			thisDecadeSet=0
			mysteryProgress=0
			initialMysteryFlag=1
			jqQuery
			;;
		3)	## Luminous
			mysteryJumpPosition=86
			beadCounter=$mysteryJumpPosition
			rosaryBeadID=$beadCounter
			hailmaryCounter=0
			thisDecadeSet=0
			mysteryProgress=0
			initialMysteryFlag=1
			jqQuery
			;;
		4)	## Sorrowfull
			mysteryJumpPosition=165
			beadCounter=$mysteryJumpPosition
			rosaryBeadID=$beadCounter
			hailmaryCounter=0
			thisDecadeSet=0
			mysteryProgress=0
			initialMysteryFlag=1
			jqQuery
			;;
		5)	## Glorious
			mysteryJumpPosition=244
			beadCounter=$mysteryJumpPosition
			rosaryBeadID=$beadCounter
			hailmaryCounter=0
			thisDecadeSet=0
			mysteryProgress=0
			initialMysteryFlag=1
			jqQuery
			;;
		6)	## Prayer Menu
			prayerMenu
			;;
		7)	## Color Theme
			change_color_menu
			;;
		8)	## exit app
			goodbyscreen
			exit
			;;
		*)	## na
	esac

	tputBeadDisplay
	
	# echo $hr
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."
	decade_progressbar
	mystery_progressbar
}

function menuDN() {
	## English / Latin translation
	
	screenTitle="Termainal Rosary using Jq and Bash"
	dialogTitle="Language Selector"
	selectedMenuTranslation=$(dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--radiolist "Switch language:\
		\n\n Use space bar to toggle\n" \
		0 0 0 \
		1 "English - New American Bible" ON\
		2	"Latin - Vulaget" OFF)
		
	if [ $selectedMenuTranslation -gt 0 ]; then
		translation=$selectedMenuTranslation
		
		translationDB
		jqQuery
	fi
	
	tputBeadDisplay
	
	# echo $hr
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."
	decade_progressbar
	mystery_progressbar
}

function prayerMenu() {
	prayerName=$(jq .prayer[1].prayerName $rosaryJSON)
	
	screenTitle="Termainal Rosary using Jq and Bash"
	dialogTitle="Prayer Menu"
	selectedPrayer=$(dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select an option:\
		\n WIP" \
		0 0 0 \
		"1" "$(jq .prayer[1].prayerName $rosaryJSON)"\
		"2" "$(jq .prayer[2].prayerName $rosaryJSON)"\
		"3" "$(jq .prayer[3].prayerName $rosaryJSON)"\
		"4" "$(jq .prayer[4].prayerName $rosaryJSON)"\
		"5" "$(jq .prayer[5].prayerName $rosaryJSON)"\
		"6" "$(jq .prayer[6].prayerName $rosaryJSON)"\
		"7" "$(jq .prayer[7].prayerName $rosaryJSON)"\
		"8" "$(jq .prayer[8].prayerName $rosaryJSON)"\
		"9" "$(jq .prayer[9].prayerName $rosaryJSON)"\
		"10" "$(jq .prayer[10].prayerName $rosaryJSON)"\
		"11" "$(jq .prayer[11].prayerName $rosaryJSON)"\
		"12" "$(jq .prayer[12].prayerName $rosaryJSON)"\
		"13" "$(jq .prayer[13].prayerName $rosaryJSON)"\
		"14" "$(jq .prayer[14].prayerName $rosaryJSON)"\
		"15" "$(jq .prayer[15].prayerName $rosaryJSON)"\
		"16" "$(jq .prayer[16].prayerName $rosaryJSON)" )

	dialogPrayerName=$(jq .prayer[$selectedPrayer].prayerName $rosaryJSON)
	
	dialogPrayerText=$(jq .prayer[$selectedPrayer].prayerText $rosaryJSON)
	htmlPattern="\<br\>"
	bashEcho="\n"
	dialogPrayerText=${dialogPrayerText//$htmlPattern/$bashEcho}
	htmlPattern="\<\/p\>\<p\>"
	bashEcho="\n\n"
	dialogPrayerText=${dialogPrayerText//$htmlPattern/$bashEcho}
	htmlPattern="\<\/p\>"
	bashEcho=""
	dialogPrayerText=${dialogPrayerText//$htmlPattern/$bashEcho}
	htmlPattern="\<p\>"
	bashEcho=""
	dialogPrayerText=${dialogPrayerText//$htmlPattern/$bashEcho}

	# dialog \
    #    --backtitle "Termainal Rosary using Jq and Bash" \
    #    --title "$dialogPrayerName" \
    #    --infobox "$dialogPrayerText" 0 0
    # read -s

    whiptail \
        --title "$dialogPrayerName" \
        --msgbox "$dialogPrayerText" 0 0
		
}

function arrowInputs() {
	counterMIN=0
	counterMAX=315

	while read -sN1 key
	do		
		## catch 3 multi char sequence within a time window
		## null outputs in case of random error msg
		read -s -n1 -t 0.0001 k1 &>/dev/null
		read -s -n1 -t 0.0001 k2 &>/dev/null
		read -s -n1 -t 0.0001 k3 &>/dev/null
		key+=${k1}${k2}${k3} &>/dev/null
		
		case "$key" in
			$arrowUp) # menu
				menuUP
				;;
			$arrowDown) # language toggle
				menuDN
				;;
			$arrowRt) # navigate forward
				if [ $introFlag -ne 1 ]; then
				
					clear
					blank_transition_display
					beadFWD

					bundledDisplay
					
				fi
				;;
			$arrowLt) # navigate back
			
				clear				
				blank_transition_display
				beadREV

				bundledDisplay
				
				;;
			*) # echo "waiting" ;;
		esac
	done

	# Restore screen
    tput rmcup
}

## Vars
function translationDB() {
	
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

function initialize() {
	# Save screen
    tput smcup

    BACKGROUNDCOLOR=${BG_BLACK}
	FOREGROUNDCOLOR=${FG_GREEN}
	BAR_BG=${BG_GREEN}
	BAR_FG=${FG_BLACK}
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	clear
    
	initialMysteryFlag=0
	showBibleListFlag=0
	showPrayerListFlag=0
	iamtyping=0
	mainPageLoaded=0
    
	initialHailMaryCounter=0
	stringSpaceCounter=0
	hailmaryCounter=0
	beadCounter=0

	introFlag=1
	
	translation=1

	## determine mystery of the day
	mysteryDay
	
	## declare init language translation
	translationDB

	
}

function myMian() {
	decorativeColors
	inputControlls
	initialize
	
	splashScreen
	welcomepage
	
	arrowInputs
}

## Run
myMian
