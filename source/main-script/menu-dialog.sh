#!/bin/bash
###################################################
## Dialog Menus
###################################################

function change_color_menu {

	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Background Color Menu"
	selectedBackgroundColor=$( dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select a background color: \n " 0 0 0 \
		"1" "Black" \
		"2" "Magenta" \
		"3" "Red" \
		"4" "Yellow" \
		"5" "Cyan" \
		"6" "Blue" \
		"7" "White" \
		"8" "Green" \
		"9"	"No Style" )

	case "$selectedBackgroundColor" in
		1) # Black
			BACKGROUNDCOLOR=${BG_BLACK}
			BAR_FG=${FG_BLACK}
			;;
		2) # Magenta
			BACKGROUNDCOLOR=${BG_MAGENTA}
			BAR_FG=${FG_MAGENTA}
			;;
		3) # Red
			BACKGROUNDCOLOR=${BG_RED}
			BAR_FG=${FG_RED}
			;;
		4) #Yellow
			BACKGROUNDCOLOR=${BG_YELLOW}
			BAR_FG=${FG_YELLOW}
			;;
		5) # Cyan
			BACKGROUNDCOLOR=${BG_CYAN}
			BAR_FG=${FG_CYAN}
			;;
		6) # Blue
			BACKGROUNDCOLOR=${BG_BLUE}
			BAR_FG=${FG_BLUE}
			;;
		7) # White
			BACKGROUNDCOLOR=${BG_WHITE}
			BAR_FG=${FG_WHITE}
			;;
		8) # Green
			BACKGROUNDCOLOR=${BG_GREEN}
			BAR_FG=${FG_GREEN}
			;;
		9) # No Style
			BACKGROUNDCOLOR=${BG_NoColor}
			BAR_FG=${FG_NoColor}
			;;
	esac

	dialogTitle="Foreground Color Menu"
	selectedForegroundColor=$( dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select a foreground color: \n " 0 0 0 \
		"1" "Black" \
		"2" "Magenta" \
		"3" "Red" \
		"4" "Yellow" \
		"5" "Cyan" \
		"6" "Blue" \
		"7" "White" \
		"8" "Green" \
		"9"	"No Style" )

	case "$selectedForegroundColor" in
		1) # Black
			FOREGROUNDCOLOR=${FG_BLACK}
			BAR_BG=${BG_BLACK}
			;;
		2) # Magenta
			FOREGROUNDCOLOR=${FG_MAGENTA}
			BAR_BG=${BG_MAGENTA}
			;;
		3) # Red
			FOREGROUNDCOLOR=${FG_RED}
			BAR_BG=${BG_RED}
			;;
		4) #Yellow
			FOREGROUNDCOLOR=${FG_YELLOW}
			BAR_BG=${BG_YELLOW}
			;;
		5) # Cyan
			FOREGROUNDCOLOR=${FG_CYAN}
			BAR_BG=${BG_CYAN}
			;;
		6) # Blue
			FOREGROUNDCOLOR=${FG_BLUE}
			BAR_BG=${BG_BLUE}
			;;
		7) # White
			FOREGROUNDCOLOR=${FG_WHITE}
			BAR_BG=${BG_WHITE}
			;;
		8) # Green
			FOREGROUNDCOLOR=${FG_GREEN}
			BAR_BG=${BG_GREEN}
			;;
		9) # No Style
			FOREGROUNDCOLOR=${FG_NoColor}
			BAR_BG=${BG_NoColor}
			;;
	esac

	echo ${BACKGROUNDCOLOR} ${FOREGROUNDCOLOR}

}

function menuUP {
	myPingAddr=usccb.org
	ping -c1 $myPingAddr &>/dev/null
	pingFlag=$?

	if [[ $pingFlag -eq 0 ]]; then
		showonlineStatus=online
	else
		showonlineStatus=offline
	fi

	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Main Menu"
	selectedMenuItem=$( dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select an option: \n " 0 0 0 \
		"1" "About" \
		"2" "Goto Joyful Mystery" \
		"3" "Goto Luminous Mystery" \
		"4" "Goto Sorrowfull Mystery" \
		"5" "Goto Glorious Mystery" \
		"6"	"View Prayers" \
		"7" "Change Color Theme" \
		"8" "Feast Day Countdown" \
		"9" "Daily Mass Readings ($showonlineStatus)" \
		"10" "Exit App" )


	case "$selectedMenuItem" in
		1)	## About
			#clear
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
			#clear
			prayerMenu
			;;
		7)	## Color Theme
			#clear
			change_color_menu
			;;
		8)	## Feast Day List
			#clear
			feastDayCountdown
			;;
		9) # elinks mass readings
			#clear
			elinksUsccb
			;;
		10)	## exit app
			if [ $autoPilot -eq 1 ]; then
				autoPilot=0
			else
				goodbyescreen
				tput cnorm
				tput sgr0
				reset
				exit
			fi

			break
			;;
	esac


	echo "$STYLES_OFF $CLR_ALL $CLR_ALL_LINES $BACKGROUNDCOLOR $FOREGROUNDCOLOR"
	clear

	if [ $introFlag -eq 1 ]; then
		howToPage
	else
		# bundledDisplay
		resizeWindow
		tputBeadDisplay
		progressbars
	fi

	## Delay just for a less rushed UI experience
	sleep .5s
}

function menuUPautopilot {
	myPingAddr=usccb.org
	ping -c1 $myPingAddr &>/dev/null
	pingFlag=$?

	if [[ $pingFlag -eq 0 ]]; then
		showonlineStatus=online
	else
		showonlineStatus=offline
	fi

	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Main Menu"
	selectedMenuItem=$( dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select an option: \n " 0 0 0 \
		"1" "About" \
		"6"	"View Prayers" \
		"8" "Feast Day Countdown" \
		"9" "Daily Mass Readings ($showonlineStatus)" \
		"10" "Exit App" ) || clear

	case "$selectedMenuItem" in
		1)	## About
			myAbout
			;;
		6)	## Prayer Menu
            prayerMenu
			;;
		8)	## Feast Day List
            feastDayCountdown
			;;
		9) # elinks mass readings
			elinksUsccb
			;;
		10)	## exit app
			if [ $autoPilot -eq 1 ]; then
				autoPilot=0
				unsetAutoPilotFlag
				killAutopilot
			else
				goodbyescreen
				tput cnorm
				tput sgr0
				reset
				exit
			fi
			;;
	esac

	unsetPauseFlag

	echo "$STYLES_OFF $CLR_ALL $CLR_ALL_LINES $BACKGROUNDCOLOR $FOREGROUNDCOLOR"
    clear
}

function menuDN {
	## English / Latin translation

	if [ $translation == 1 ]; then
		nabSwitch=ON
		vulgateSwitch=OFF
	else
		nabSwitch=OFF
		vulgateSwitch=ON
	fi

	clear

	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Language Selector"
	selectedMenuTranslation=$( dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--radiolist "Switch language: \n\n Use space bar to toggle\n" 0 0 0 \
		"1" "English - New American Bible" "$nabSwitch" \
		"2"	"Latin - Vulgate" "$vulgateSwitch" ) || selectedMenuTranslation=$translation


	translation=$selectedMenuTranslation
	translationDB
	jqQuery

	echo "$STYLES_OFF $CLR_ALL $CLR_ALL_LINES $BACKGROUNDCOLOR $FOREGROUNDCOLOR"
	clear

	if [ $introFlag -eq 1 ]; then
		howToPage
	else
		# bundledDisplay
		resizeWindow
		tputBeadDisplay
		progressbars
	fi

	unsetPauseFlag
}

function prayerMenu {
	prayerName=$(jq .prayer[1].prayerName $rosaryJSON)

	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Prayer Menu"
	selectedPrayer=$( dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select an option: \n Paired with English/Latin" 0 0 0 \
		"1" "$(jq .prayer[1].prayerName $rosaryJSON)" \
		"2" "$(jq .prayer[2].prayerName $rosaryJSON)" \
		"3" "$(jq .prayer[3].prayerName $rosaryJSON)" \
		"4" "$(jq .prayer[4].prayerName $rosaryJSON)" \
		"5" "$(jq .prayer[5].prayerName $rosaryJSON)" \
		"6" "$(jq .prayer[6].prayerName $rosaryJSON)" \
		"7" "$(jq .prayer[7].prayerName $rosaryJSON)" \
		"8" "$(jq .prayer[8].prayerName $rosaryJSON)" \
		"9" "$(jq .prayer[9].prayerName $rosaryJSON)" \
		"10" "$(jq .prayer[10].prayerName $rosaryJSON)" \
		"11" "$(jq .prayer[11].prayerName $rosaryJSON)" \
		"12" "$(jq .prayer[12].prayerName $rosaryJSON)" \
		"13" "$(jq .prayer[13].prayerName $rosaryJSON)" \
		"14" "$(jq .prayer[14].prayerName $rosaryJSON)" \
		"15" "$(jq .prayer[15].prayerName $rosaryJSON)" \
		"16" "$(jq .prayer[16].prayerName $rosaryJSON)" ) || return

	dialogPrayerName=$(jq .prayer[$selectedPrayer].prayerName $rosaryJSON)
	dialogPrayerText=$(jq .prayer[$selectedPrayer].prayerText $rosaryJSON)
	htmlPattern=" \<br\>"
	bashEcho=" \n"
	dialogPrayerText=${dialogPrayerText//$htmlPattern/$bashEcho}
	htmlPattern=" \<\/p\>\<p\>"
	bashEcho=" \n\n"
	dialogPrayerText=${dialogPrayerText//$htmlPattern/$bashEcho}
	htmlPattern=" \<\/p\>"
	bashEcho=""
	dialogPrayerText=${dialogPrayerText//$htmlPattern/$bashEcho}
	htmlPattern=" \<p\>"
	bashEcho=""
	dialogPrayerText=${dialogPrayerText//$htmlPattern/$bashEcho}

	whiptail \
		--title "$dialogPrayerName" \
		--msgbox "$dialogPrayerText" 0 0

	echo $BACKGROUNDCOLOR
	clear
}
