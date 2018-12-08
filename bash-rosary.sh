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

	## horizontal line across scrren
	unicodeLine=($'\u2500\n')
	hr=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' ".")
}

function splashScreen() {
	width=$(tput cols)
	height=$(tput lines)
	str="Termainal Rosary using Jq and Bash"
	length=${#str}
	tput cup $((height/2)) $(((width/ 2)-(length/2)))
	echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
	str="< Lt navigate Rt > ( Up menus Dn )"
	length=${#str}
	tput cup $height $(((width/ 2)-(length/2)))
	echo $str
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

	sleep 2
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
		echo "introduction prayer beads: $initialHailMaryCounter/3"
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
		echo "Progressbars will be applied once the mystery circuit begins"
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
        2)
			if [ $decadeIndex -ne 0 ]; then
			
				if [ $directionFwRw -eq 1 ]; then
					hailmaryCounter=$(( $hailmaryCounter + 1))
				else
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
		3)
			stringSpaceCounter=0
            initialHailMaryCounter=0

            if [ $directionFwRw -ne 1 ]; then
				moddivision=$(( hailmaryCounter % 10 ))
				if [ $moddivision -gt 0 ]; then
					hailmaryCounter=$(( $hailmaryCounter - 1 ))
				fi
            fi
            ;;
        4)
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
        5)
			if [ $directionFwRw -eq 1 ]; then
				stringSpaceCounter=3
			fi
			
            stringSpaceCounter=0;

            if [ $initialMysteryFlag -eq 0 ]; then
				# beadCounter=initialMystery()[1];
                # hailmaryCounter=((initialMystery()[0] * 10) - 10)
                initialMysteryFlag=1
            fi            
			;;
		6)
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

function blank_transition_display() {
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	#clear
	echo "$CLR_ALL"
	
	echo " $translationName"
	width=$(tput cols)
	str="Termainal Rosary using Jq and Bash"
	tput cup 0 $(((width/ 2)-(length/2)))
	echo $str
	tput cup $(tput lines)-1 $[$(tput cols)-28]; echo `date`
	
	echo "$hr"
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
	echo "$hr"

	decade_progressbar
	mystery_progressbar
}

function tputBeadDisplay() {
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	#clear
	echo "$CLR_ALL"
		
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
	
	echo "$hr"
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
		"8" "Exit/Close App")

	case "$selectedMenuItem" in
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
	
	echo $hr
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
	
	echo $hr
	decade_progressbar
	mystery_progressbar
}

function change_color_menu() {
	screenTitle="Termainal Rosary using Jq and Bash"
	dialogTitle="Color Theme Menu"
	selectedTheme=$(dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select an color theme:\
		\n WIP" \
		0 0 0 \
		"1" "Green on Black"\
		"2" "Black on White")
		
	case "$selectedTheme" in
		1) # Green on Black
		
			BACKGROUNDCOLOR=${BG_BLACK}
			FOREGROUNDCOLOR=${FG_GREEN}
			BAR_BG=${BG_GREEN}
			BAR_FG=${FG_BLACK}
			
			echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
			;;
		2) # Black on White
		
			BACKGROUNDCOLOR=${BG_WHITE}
			FOREGROUNDCOLOR=${FG_BLACK}
			BAR_BG=${BG_BLACK}
			BAR_FG=${FG_WHITE}
			
			echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
			;;
		*) # echo "waiting" ;;
	esac
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

	translation=1
	
	translationDB
}

## UI
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
			$arrowDown) # language
			
				menuDN
				;;
			$arrowRt) # navigate forward
			
				#clear
				echo "$CLR_ALL"
				
				blank_transition_display
				beadFWD
				
				tputBeadDisplay
				echo $hr
				
				beadProgress
				decade_progressbar
				mystery_progressbar
				;;
			$arrowLt) # navigate back
			
				#clear
				echo "$CLR_ALL"
				
				blank_transition_display
				beadREV

				tputBeadDisplay
				echo $hr
				
				beadProgress
				decade_progressbar
				mystery_progressbar
				;;
			*) # echo "waiting" ;;
		esac
	done

	# Restore screen
    tput rmcup
}

function myMian() {
	decorativeColors
	inputControlls
	initialize
	splashScreen
	
	arrowInputs
}

## Run
myMian
