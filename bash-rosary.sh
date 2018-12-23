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

	## horizontal line across screen
	hr=$(printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' ".")
}

function inputControlls {
	arrowUp=$'\e[A'
	arrowDown=$'\e[B'
	arrowRt=$'\e[C'
	arrowLt=$'\e[D'
	# escKey=$'\['
	# f1Key=$'\[OP'
}

function resizeWindow {
	## Initial resize
	## I designed this App with Xterm in mind. Other terminals may not look how I intended.
	## Optimal desktop gui terminal Size

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

	if [ $isWideEnough -eq 0 ] || [ $isTallEnough -eq 0 ]; then
		resize -s 40 140 &>/dev/null
		stty rows 40
		stty cols 140

		echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
		clear
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

###################################################
## JQ
###################################################

function jqQuery {
	## The longest rout for query, 1N DB Query

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
	query_prayerName=.prayer[$prayerIndex].prayerName
	query_prayerText=.prayer[$prayerIndex].prayerText
	query_scriptureText=.scripture[$scriptureIndex].scriptureText
	query_mesageText=.message[$messageIndex].mesageText

	return_beadID=$(jq $query_beadID $rosaryJSON)
	return_beadType=$(jq $query_beadType $rosaryJSON)
	# return_decadeID=$(jq $query_decadeID $rosaryJSON)
	return_decadeName=$(jq $query_decadeName $rosaryJSON)
	return_mysteryName=$(jq $query_mysteryName $rosaryJSON)
	return_prayerText=$(jq $query_prayerText $rosaryJSON)
	return_prayerName=$(jq $query_prayerName $rosaryJSON)
	return_scriptureText=$(jq $query_scriptureText $rosaryJSON)
	return_mesageText=$(jq $query_mesageText $rosaryJSON)

	beadID=$return_beadID
	beadType=$return_beadType
}

function formatJqText {
	## Undo formatting and modify Jq generated text

	## Remove Quotes from vars
	temp="${return_mysteryName%\"}"; temp="${temp#\"}"
	return_mysteryName=$temp
	temp="${return_mesageText%\"}"; temp="${temp#\"}"
	return_mesageText=$temp
	temp="${return_decadeName%\"}"; temp="${temp#\"}"
	return_decadeName=$temp
	temp="${return_beadType%\"}"; temp="${temp#\"}"
	return_beadType=$temp

	## Dim after <hr>
	htmlHR="\<hr\>"
	bashEcho="${MODE_DIM}"
	return_prayerText=${return_prayerText/$htmlHR/$bashEcho}
	temp="${return_prayerText%\"}"; temp="${temp#\"}"
	return_prayerText=$temp

	## Dim after <hr>
	htmlHR="\<hr\>"
	bashEcho="${MODE_DIM}
	Translation: "
	return_scriptureText=${return_scriptureText/$htmlHR/$bashEcho}

	## Split Prayer into 2 lines
	first2letters=$(echo $return_prayerText | grep -Po "^..")

	case $first2letters in
		"OU") ## Enlgish Our Father
			newLineWith="Give"
			;;
		"Pa") ## Latin Our Father
			newLineWith="Panem"
			;;
		"HA") ## Enlgish Hail Mary
			newLineWith="Holy"
			;;
		"Av") ## Latin Hail Mary
			newLineWith="Sancta"
			;;
		"GL") ## Enlgish Glory Be
			newLineWith="As"
			;;
		"Gl") ## Latin Glory Be
			newLineWith="Sicut"
			;;
		"O ") ## Enlgish Oh my Jesus
			newLineWith="lead"
			;;
		"Do") ## Latin Oh my Jesus
			newLineWith="perduc"
			;;
		* ) ## na
			## echo "idk" 7
			;;
	esac

	bashEcho="
	$newLineWith"
	return_prayerText=${return_prayerText/$newLineWith/$bashEcho}
}

###################################################
## Holliday Dates Calculation
###################################################

function initializeFeastFlags {
	## I assume this app will be turned on/off therfore fefreshing as-needed
	## I did not make a perpetual clock

	isTodayEaster=0
	isEasterSeason=0
	isTodayAsh_Wednesday=0
	isLentSeasion=0
	isTodayHoly_Thursday=0
	isTodayGood_Friday=0
	isTodayHoly_Saturday=0
	isTodayAsh_Wednesday=0
	isTodayJesus_Assension=0
	isTodayPentecost=0
	isTodayImmaculateConception=0
	isTodayAdventStart=0
	isAdventSeasion=0
	isTodayChristmas=0
	isTodaySolemnityOfMary=0
	isTodayEpiphany=0
	isTodayAll_Saints=0

	isOrdinaryTime=0
}

#
## PFM Table Calculations
#

function pfmTableDate {
	## Divide the current year by 19 and get the 1st 3 digits after the decimal

	yearDiv3_decimal=$(echo "scale=3; $thisYear / 19" | bc)
	yearDiv3_int=$(( $thisYear / 19 ))
	last3dec=$(echo "scale=3; $yearDiv3_decimal - $yearDiv3_int" | bc)
	wholeNum=$( echo "scale=0; $last3dec * 1000" | bc )
	wholeNum=$( echo $wholeNum | awk '{print int($0)}' ) ## Floor Round

	## Paschal Full Moon (PFM) Date for Years 326 to 2599 (M=March, A=April)

	pmfArray[0]=A14
	pmfArray[52]=A3
	pmfArray[105]=M23
	pmfArray[157]=A11
	pmfArray[210]=M31
	pmfArray[263]=A18
	pmfArray[315]=A8
	pmfArray[368]=M28
	pmfArray[421]=A16
	pmfArray[473]=A5
	pmfArray[526]=M25
	pmfArray[578]=A13
	pmfArray[631]=A2
	pmfArray[684]=M22
	pmfArray[736]=A10
	pmfArray[789]=M30
	pmfArray[842]=A17
	pmfArray[894]=A7
	pmfArray[947]=M27

	pfmDate=${pmfArray[$wholeNum]}
}

function pfmTableMonth(){
	## determine month according to PMF Date
	firstLetter=${pfmDate:0:1}

	## 1st letter
	if [[ $firstLetter == "M" ]]; then
		virtualMonthName="March"
		virtualMonthNo=03
	else
		virtualMonthName="April"
		virtualMonthNo=04
	fi

	## last 2 numbers
	if [ ${#pfmDate} -lt 3 ]; then
		last2numbers=$( echo -n $pfmDate | tail -c 1 )
		estimatedDay=0$last2numbers
	else
		last2numbers=$( echo -n $pfmDate | tail -c 2 )
		estimatedDay=$last2numbers
	fi
}

function pfmTableYear {
	## PFM Date for year (M=March, A=April)

	case "$pmfDate" in
		"A2" | "A9" | "A16" | "M26" )
			annualNo=0
			;;
		"A3" | "A10" | "A17" | "M27" )
			annualNo=1
			;;
		"A4" | "A11" | "A18" | "M21" | "M28" )
			annualNo=2
			;;
		"A5" | "A12" | "M29" | "M22" )
			annualNo=3
			;;
		"A6" | "A13" | "M23" | "M30" )
			annualNo=4
			;;
		"A7" | "A14" | "M24" | "M31" )
			annualNo=5
			;;
		"A1" | "A8" | "A15" | "M25" )
			annualNo=6
			;;
	esac
}

function pfmTableDecade {
	## Last 2 digits in the current year
	## I am just going to use 18-21 and a few more future years just to fill it out

	last2numbers=$( echo -n $thisYear | tail -c 2 )

	case "$last2numbers" in
		23 | 28 )
			decadeNo=0
			;;
		18 | 29 )
			decadeNo=1
			;;
		19 | 24 )
			decadeNo=2
			;;
		25 | 31 )
			decadeNo=3
			;;
		20 | 26 )
			decadeNo=4
			;;
		21 | 27 )
			decadeNo=5
			;;
		22 | 33 )
			decadeNo=6
			;;
	esac
}

function pfmTableCentury {
	## First 2 digits if current year
	## I expect it will be 20 for the next +900 years... but the calander has changed more than once in the last 900 years
	## There is a lookup table for this... but we do not need to do that, 20 is just 0

	centuryNo=0
}

function pfmTableSum {
	## Add results from all 3 tables
	tableSum=$(( $annualNo + $centuryNo + $decadeNo ))

	case $tableSum in
		0 | 7 | 14 )
			pfmWeekDay=Sunday
			daysToAdd=1
			;;
		1 | 8 | 15 )
			pfmWeekDay=Monday
			daysToAdd=2
			;;
		2 | 9 | 19 )
			pfmWeekDay=Tuesday
			daysToAdd=3
			;;
		3 | 10 | 17 )
			pfmWeekDay=Wednesday
			daysToAdd=4
			;;
		4 | 11 | 18 )
			pfmWeekDay=Thursday
			daysToAdd=5
			;;
		5 | 12 )
			pfmWeekDay=Friday
			daysToAdd=6
			;;
		6 | 13 )
			pfmWeekDay=Saturday
			daysToAdd=7
			;;
	esac
}

#
## Calculate Days Untill Feast
#

function days_Untill_Count {
	# thisYear=$(date +%Y)
	tabulatedDate=$thisYear$monthDay
	saveTheDate=$(( ($(date --date="$tabulatedDate" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $saveTheDate -lt 0 ]; then
		nextYear=$(( $thisYear + 1 ))
		tabulatedDate=$nextYear$monthDay
		saveTheDate=$(( ($(date --date="$tabulatedDate" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi
}

function calculate_Paschal_Full_Moon {
	## Easter

	# thisYear=$(date +%Y)
	pfmTableDate
	pfmTableMonth
	pfmTableYear
	pfmTableDecade
	pfmTableCentury
	pfmTableSum

	## Desired date - today
	tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
	daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))
		pfmTableDate
		pfmTableMonth
		pfmTableYear
		pfmTableDecade
		pfmTableCentury
		pfmTableSum

		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillEaster=$daysUntill
	if [ $daysUntillEaster == 0 ]; then
		isTodayEaster=1
	else
		isTodayEaster=0
	fi
}

#
## Liturgical Callendar Flags
#

function days_untill_Holy_Thursday {
	## Triduum Thursday

	thisYear=$(date +%Y)
	calculate_Paschal_Full_Moon

	daysToRemove=$(( $daysToAdd - 3 ))
	daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))

		calculate_Paschal_Full_Moon

		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysToRemove=$(( $daysToAdd - 3 ))
		daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillHolyThursday=$daysUntill
	if [ $daysUntillHolyThursday == 0 ]; then
		isTodayHoly_Thursday=1
	else
		isTodayHoly_Thursday=0
	fi
}

function days_untill_Good_Friday {
	## Triduum Friday

		thisYear=$(date +%Y)
	calculate_Paschal_Full_Moon

	daysToRemove=$(( $daysToAdd - 2 ))
	daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))

		calculate_Paschal_Full_Moon

		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysToRemove=$(( $daysToAdd - 2 ))
		daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillGoodFriday=$daysUntill
	if [ $daysUntillGoodFriday == 0 ]; then
		isTodayGood_Friday=1
	else
		isTodayGood_Friday=0
	fi
}

function days_untill_Easter_Eve {
	## Triduum Saturday

	thisYear=$(date +%Y)
	calculate_Paschal_Full_Moon

	daysToRemove=$(( $daysToAdd - 1 ))
	daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))

		calculate_Paschal_Full_Moon

		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysToRemove=$(( $daysToAdd - 1 ))
		daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillHolySaturday=$daysUntill
	if [ $daysUntillHolySaturday == 0 ]; then
		isTodayHoly_Saturday=1
	else
		isTodayHoly_Saturday=0
	fi
}

function days_untill_Ash_Wednesday {
	## Lent begins on Ash Wednesday, which is always held 46 days (40 fasting days and 6 Sundays) before Easter Sunday.

	thisYear=$(date +%Y)
	calculate_Paschal_Full_Moon

	daysToRemove=$(( $daysToAdd - 46 ))
	daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))

		calculate_Paschal_Full_Moon

		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysToRemove=$(( $daysToAdd - 46 ))
		daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillAshWednesday=$daysUntill
	if [ $daysUntillAshWednesday == 0 ]; then
		isTodayAsh_Wednesday=1
	else
		isTodayAsh_Wednesday=0
	fi

	## Determine Lent Season

	if [ $daysUntillEaster -le 46 ]; then
		isLentSeasion=1
	else
		isLentSeasion=0
	fi

}

function days_untill_Jesus_Assension {
	## 40 Days After Easter, Thursday

	thisYear=$(date +%Y)
	calculate_Paschal_Full_Moon

	daysToAdd=$(( $daysToAdd + 40 ))
	daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))

		calculate_Paschal_Full_Moon

		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysToAdd=$(( $daysToAdd + 49 ))
		daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillJesusAssension=$daysUntill
	if [ $daysUntillJesusAssension == 0 ]; then
		isTodayJesus_Assension=1
	else
		isTodayJesus_Assension=0
	fi
}

function days_untill_Pentecost {
	## 7 Sundays after Easter

	thisYear=$(date +%Y)
	calculate_Paschal_Full_Moon

	daysToAdd=$(( $daysToAdd + 49 ))
	daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))

		calculate_Paschal_Full_Moon

		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysToAdd=$(( $daysToAdd + 49 ))
		daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillPentecost=$daysUntill
	if [ $daysUntillPentecost == 0 ]; then
		isTodayPentecost=1
	else
		isTodayPentecost=0
	fi

	## Determine Easter Season
	## 50 days after Easter up to Pentecost
	if [ $daysUntillPentecost -lt 50 ]; then
		isEasterSeason=1
		isOrdinaryTime=0
	else
		isEasterSeason=0
	fi


}

function days_untill_Immaculate_Conception {
	## Dec 8
	thisYear=$(date +%Y)
	monthDay="1208"
	days_Untill_Count

	daysUntillImmaculateConception=$saveTheDate

	if [ $daysUntillImmaculateConception == 0 ]; then
		isTodayImmaculateConception=1
	else
		isTodayImmaculateConception=0
	fi

}

function days_untill_Advent {
	## 1st sunday of Dec through Dec 24
	## Start of Liturgical Year
	## Min 4 sunday durations

	thisYear=$(date +%Y)
	calday=$( cal 12 "$thisYear" | awk 'NF==7 && !/^Su/{print $1;exit}' )
	monthDay="120"$calday
	adventDurration=$(( 25 - $calday ))

	days_Untill_Count

	daysUntillAdvent=$saveTheDate

	if [ $daysUntillAdvent -eq 0 ]; then
		isTodayAdventStart=1
	else
		isTodayAdventStart=0
	fi

	## Determine Advent Season

	if [ "$daysUntillChristmas" -le "$adventDurration" ]; then
		isAdventSeasion=1
		isOrdinaryTime=0
	else
		isAdventSeasion=0
	fi
}

function days_untill_Christmas {
	## Dec 25
	thisYear=$(date +%Y)
	monthDay="1225"

	days_Untill_Count

	daysUntillChristmas=$saveTheDate

	if [ $daysUntillChristmas == 0 ]; then
		isTodayChristmas=1
	else
		isTodayChristmas=0
	fi
}

function days_untill_All_Saints {
	## Nov 1
	thisYear=$(date +%Y)
	monthDay="1101"
	days_Untill_Count

	daysUntillAllSaints=$saveTheDate

	if [ $daysUntillAllSaints == 0 ]; then
		isTodayAll_Saints=1
	else
		isTodayAll_Saints=0
	fi
}

function days_untill_Solemnity_of_Mary {
	## Jan 1
	monthDay="0101"
	days_Untill_Count

	daysUntillSolemnityOfMary=$saveTheDate

	if [ $daysUntillSolemnityOfMary == 0 ]; then
		isTodaySolemnityOfMary=1
	else
		isTodaySolemnityOfMary=0
	fi
}

function days_untill_Epiphany {
	## Aprox: Jan 6
	## Start of the 1st segment of ordinary time
	## Sunday closest to 12 days after Christmas
	## If Jan 6 is >= friday add days forward to Sun
	## If Jan 6 is < friday subtract days back to Sun

	thisYear=$(date +%Y)
	monthDay="0106"

	days_Untill_Count

	daysUntillEpiphany=$saveTheDate

	## Shift day into a Sunday
	weekdayEpiphany=$(date --date="$(date) +$daysUntillEpiphany days" +%u) # mon is 1
	daysFromSunday=$((  7 - $weekdayEpiphany ))
	daysUntillEpiphany=$((  $daysUntillEpiphany - $daysFromSunday ))

	if [ $daysUntillEpiphany == 0 ]; then
		isTodayEpiphany=1
	else
		isTodayEpiphany=0
	fi
}

function trigger_feastDay {
	thisYear=$(date +%Y)

	calculate_Paschal_Full_Moon
	days_untill_Ash_Wednesday
	days_untill_Holy_Thursday
	days_untill_Good_Friday
	days_untill_Easter_Eve
	days_untill_Jesus_Assension
	days_untill_Pentecost
	days_untill_Christmas
	days_untill_Advent
	days_untill_Immaculate_Conception
	days_untill_All_Saints
	days_untill_Epiphany
	days_untill_Solemnity_of_Mary

	## Feast Day App Color Theme
	if [ $isTodayEaster -eq 1 ] || [ $isTodayPentecost -eq 1 ]; then
		## Yellow
		BACKGROUNDCOLOR=${BG_YELLOW}; echo ${BACKGROUNDCOLOR}
		BAR_FG=${FG_YELLOW}
		FOREGROUNDCOLOR=${FG_BLACK}; echo ${FOREGROUNDCOLOR}
		BAR_BG=${BG_BLACK}

	fi

	if [ $isTodayAdventStart -eq 1 ] || [ $isTodayChristmas -eq 1 ] || [ $isTodayEpiphany -eq 1 ]; then
		## Magenta/Purple/Violet
		BACKGROUNDCOLOR=${BG_MAGENTA}; echo ${BACKGROUNDCOLOR}
		BAR_FG=${FG_MAGENTA}
		FOREGROUNDCOLOR=${FG_BLACK}; echo ${FOREGROUNDCOLOR}
		BAR_BG=${BG_BLACK}
	fi
}

function feastDayCountdown {

	dialogEaster="Easter:	$daysUntillEaster \n"
	dialogAssension="Assension of Jesus:	$daysUntillJesusAssension \n"
	dialogPentecost="Pentecost:	$daysUntillPentecost \n"
	dialogAllSaints="All Saints:	$daysUntillAllSaints \n"
	dialogAdvent="Start Advent:	$daysUntillAdvent \n"
	dialogConception="Conception:	 $daysUntillImmaculateConception \n"
	dialogChristmas="Christmas:	$daysUntillChristmas \n"
	dialogSolemnity="Solemnity of Mary:	$daysUntillSolemnityOfMary \n"
	dialogEpiphany="Epiphany:	$daysUntillEpiphany \n"
	dialogAsh="Ash Wednesday:	$daysUntillAshWednesday \n"
	dilogHolyThursday="Holy Thursday: $daysUntillHolyThursday \n"
	dialogGoodFriday="Good Friday: $daysUntillGoodFriday \n"
	dialogHolySaturday="Holy Saturday: $daysUntillHolySaturday \n"

	dialogHR="--- \n"
	dialogOrdinaryTimeSeason="Ordinary Time Season: $isOrdinaryTime \n"
	dialogLentSeason="Lent Season: $isLentSeasion \n"
	dialogAdventSeason="Advent Season: $isAdventSeasion \n"
	dialogEasterSeason="Easter Season: $isEasterSeason \n"

	msgCountdownList="$dialogEaster$dialogAssension$dialogPentecost$dialogAllSaints$dialogAdvent$dialogConception$dialogChristmas$dialogSolemnity$dialogEpiphany$dialogAsh$dilogHolyThursday$dialogGoodFriday$dialogHolySaturday$dialogHR$dialogOrdinaryTimeSeason$dialogLentSeason$dialogAdventSeason$dialogEasterSeason"

	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Feast Day Countdown"

	dialog \
        --backtitle "$screenTitle" \
        --title "$dialogTitle" \
        --infobox "$msgCountdownList" 0 0

	read

	## Disp an Ascii Pie Chart
	liturgicalYearPi
}

function liturgicalYearPi {
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	clear
	# pieChart="$(cat ascii-pie-chart.txt)"
	str="Terminal Rosary using Jq and Bash"
	width=$(tput cols)
	length=${#str}
	tput cup 0 $(((width/ 2)-(length/2)))
	echo $str

	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."

	str="Liturgical Year Pie Chart"
	width=$(tput cols)
	length=${#str}
	tput cup 3 $(((width/ 2)-(length/2)))
	echo $str
	echo "
	"
	# cat ascii-pie-chart.txt
	cat ./Liturgical-Calendar-Notes/tiny-pie.txt

	height=$(tput lines)
	if [ $height -ge 34 ]; then
		tput cup $[$(tput lines)-2]
	fi

	read -p "[Enter]" -s
}

###################################################
## tput Page Display
###################################################

function initTputStingVars {
	clearTpuLine=$(tput el)

	width=$(tput cols)
	height=$(tput lines)
	str="Terminal Rosary using Jq and Bash"
	length=${#str}
	tputAppTitle=$(tput cup 0 $(( (width/2)-(length/2) )); echo "$str")

	tputAppTranslation=$(tput cup 0 1; echo $translationName)
	tputAppClock=$(tput cup 0 $[$(tput cols)-29]; echo `date`)
	tputAppHeaderLine=$(tput cup 1 0; printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' ".")

	tputAppMysteryLabel=$(tput cup 4 0; echo "Mystery Name" )
	tputAppMystery=$(tput cup 6 0; printf "%${width}s" ""; tput cup 6 4; echo "	loading..." )

	tputAppDecadeLabel=$(tput cup 8 0; echo "Mystery Decade")
	tputAppDecade=$(tput cup 10 0; printf "%${width}s" ""; tput cup 10 4; echo "	loading..."  )

	tputAppMessageLabel=$(tput cup 12 0; echo "Mystery Message")
	tputAppMessage=$(tput cup 14 0; printf "%${width}s" ""; tput cup 14 4; echo "	loading..."  )

	tputAppScriptureLabel=$(tput cup 16 0; echo "Scripture Text")
	tputAppScripture=$(tput cup 18 0; printf "%${width}s" "" )$(tput cup 19 0; printf "%${width}s" "" )$(tput cup 20 0; printf "%${width}s" "" )$(tput cup 21 0; printf "%${width}s" "" )$( tput cup 18 4; echo "	loading..." )

	tputAppPrayerLabel=$(tput cup 22 0; printf "%${width}s" "" )$(tput cup 22 0; echo "Prayer Text")
	tputAppPrayer=$(tput cup 23 0; printf "%${width}s" "" )$(tput cup 24 0; printf "%${width}s" "" )$(tput cup 25 0; printf "%${width}s" "" )$(tput cup 26 0; printf "%${width}s" "" )$(tput cup 27 0; printf "%${width}s" "" )$(tput cup 28 0; printf "%${width}s" "" )$(tput cup 24 4; echo "	loading..." )
}

function tputStingVars {
	formatJqText

	width=$(tput cols)
	height=$(tput lines)
	str="Terminal Rosary using Jq and Bash"
	length=${#str}
	tputAppTitle=$(tput cup 0 $(( (width/2)-(length/2) )); echo "$str")

	tputAppTranslation=$(tput cup 0 1; echo $translationName)
	tputAppClock=$(tput cup 0 $[$(tput cols)-29]; echo `date`)
	tputAppHeaderLine=$(tput cup 1 0; printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' ".")

	tputAppMysteryLabel=$(tput cup 4 0; echo "${MODE_BEGIN_UNDERLINE}Mystery Name${MODE_EXIT_UNDERLINE}:")
	tputAppMystery=$(tput cup 6 0; printf "%${width}s" ""; tput cup 6 8; echo $return_mysteryName)

	tputAppDecadeLabel=$(tput cup 8 0; echo "${MODE_BEGIN_UNDERLINE}Mystery Decade${MODE_EXIT_UNDERLINE}:")
	tputAppDecade=$(tput cup 10 0; printf "%${width}s" ""; tput cup 10 8; echo $return_decadeName)

	tputAppMessageLabel=$(tput cup 12 0; echo "${MODE_BEGIN_UNDERLINE}Mystery Message${MODE_EXIT_UNDERLINE}:")
	tputAppMessage=$(tput cup 14 0; printf "%${width}s" ""; tput cup 14 8; echo $return_mesageText)

	tputAppScriptureLabel=$(tput cup 16 0; echo "${MODE_BEGIN_UNDERLINE}Scripture Text${MODE_EXIT_UNDERLINE}:")
	tputAppScripture=$(tput cup 18 0; printf "%${width}s" ""; tput cup 18 8; echo $return_scriptureText)$STYLES_OFF$BACKGROUNDCOLOR$FOREGROUNDCOLOR

	tputAppPrayerLabel=$(tput cup 22 0; echo "${MODE_BEGIN_UNDERLINE}Prayer Text${MODE_EXIT_UNDERLINE}:")
	tputAppPrayer=$(tput cup 24 0; printf "%${width}s" ""; tput cup 24 8; echo $return_prayerText)
}

function myAbout {
	aboutText="This is a Rosary App for the Linux Bash terminal.\nThis app was tested on the default Xterm on Arch.\nThe best UI experience for this app is through a login console TTY CLI\n\nThis App is just a (personal) technical exercise. This App is a linguistic and scriptural \"reference\". \n\nSource Code:\nGithub: https://github.com/mezcel/jq-tpy-terminal.git"

	whiptail \
        --title "About" \
        --msgbox "$aboutText" 0 0
}

function splashScreen {
	echo "$CLR_ALL"
	width=$(tput cols)
	height=$(tput lines)
	str="Terminal Rosary using Jq and Bash"
	length=${#str}
	tput cup $((height/2)) $(((width/ 2)-(length/2)))
	echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
	str="< Lt navigate Rt > ( Up menus Dn )"
	length=${#str}
	tput cup $height $(((width/ 2)-(length/2)))
	echo $str

	## prompt for enter
	read -p "[Press Enter]" -s welcomeVar
}

function mystery_Day {
	dayOfWeek=$(date +"%A")
	case "$dayOfWeek" in
		"Sunday")
			dayMysteryIndex=4
			mysteryJumpPosition=244
			;;
		"Monday")
			dayMysteryIndex=1
			mysteryJumpPosition=7
			;;
		"Tuesday")
			dayMysteryIndex=3
			mysteryJumpPosition=165
			;;
		"Wednesday")
			dayMysteryIndex=4
			mysteryJumpPosition=244
			;;
		"Thursday")
			dayMysteryIndex=2
			mysteryJumpPosition=86
			;;
		"Friday")
			dayMysteryIndex=3
			mysteryJumpPosition=165
			;;
		"Saturday")
			dayMysteryIndex=1
			mysteryJumpPosition=7
			;;
		*) # echo "waiting" ;;
	esac

	## This is just so we dont start on Sorrowfull Mysteries on these "Non Lent/Non Gloomy" days.

	if [ $isTodayEaster -eq 1 ]; then
		## Glorious Mystery
		dayMysteryIndex=4
		mysteryJumpPosition=244
	fi

	if [ $isTodayChristmas -eq 1 ]; then
		## Joyful Mystery
		dayMysteryIndex=1
		mysteryJumpPosition=7
	fi
}

function welcomepage {
	clear

	str="Terminal Rosary using Jq and Bash"
	width=$(tput cols)
	length=${#str}
	tput cup 0 $(((width/ 2)-(length/2)))
	echo $str

	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."

	query_mysteryName=.mystery[$dayMysteryIndex].mysteryName
	return_mysteryName=$(jq $query_mysteryName $rosaryJSON)

	echo "
	Today is:				$dayOfWeek

	The default \"Mystery of the day\" is:	$return_mysteryName

	Liturgical Callendar:"

	if [ $isTodayEaster -eq 1 ]; then
		echo "						Easter Day"
	fi
	if [ $isEasterSeason -eq 1 ]; then
		echo "						This is the Easter Season"
	fi
	if [ $isTodayAsh_Wednesday -eq 1 ]; then
		echo "						Today is Ash Wednesday"
	fi
	if [ $isLentSeasion -eq 1 ]; then
		echo "						This is the Lent Season"
	fi
	if [ $isTodayHoly_Thursday -eq 1 ]; then
		echo "						This is Holy Thursday"
	fi
	if [ $isTodayGood_Friday -eq 1 ]; then
		echo "						This is the Good Friday"
	fi
	if [ $isTodayHoly_Saturday -eq 1 ]; then
		echo "						This is the Holy Saturday"
	fi
	if [ $isTodayJesus_Assension -eq 1 ]; then
		echo "						Today is the Feast of Jesus's Assension"
	fi
	if [ $isTodayPentecost -eq 1 ]; then
		echo "						Tday is Pentecost"
	fi
	if [ $isTodayImmaculateConception -eq 1 ]; then
		echo "						Today is the feast of the Immaculate Conception"
	fi
	if [ $isTodayAdventStart -eq 1 ]; then
		echo "						Advent Starts Today"
	fi
	if [ $isAdventSeasion -eq 1 ]; then
		echo "						This is the Advent Season"
	fi
	if [ $isTodayChristmas -eq 1 ]; then
		echo "						Today is Christmas"
	fi
	if [ $isTodaySolemnityOfMary -eq 1 ]; then
		echo "						Today is the Feast of the Solemnity of Mary"
	fi
	if [ $isTodayEpiphany -eq 1 ]; then
		echo "						Today is the Feast of the Epiphany"
	fi
	if [ $isTodayAll_Saints -eq 1 ]; then
		echo "						Today is All Saints Day"
	fi
	if [ $isOrdinaryTime -eq 1 ]; then
		echo "						This is the Ordinary Time Season"
	fi

	echo "

	Basic UI Instructions:
		Use the Rt and Lt arrow keyboard keys to progress forward or backwards.
		Use the Down arrow key to select the Scripture Language Translation ( English NAB or Latin Vulgate )
		Use the Up arrow key to access the main Menu
		The 'M' Key will toggle ON/OFF app audio (the audio will match the displayed prayer at the time of 'M')


	Advice:
		Do not navigate too fast. Allow a moment for text querying to complete.
		JQ is a C based JSON Parser & I took the longest 1N query rout to retrieve text.

		Optimal screen height is 40 lines (using factory default fonts)
		Optimal screen width is 140 cols (using factory default fonts)


	Software Dependancies:
		* Linux Bash, NOT Win10's Gitbash
		* jq with gcc
		* dialog
		* fluidsynth with soundfont-fluid or MPlayer (optional audio)

		If \"Mystery of the day\", has a value, you probably have all the software requirements.
		If the menu does not work after this page, you need to install \"dialog\"

	"

	height=$(tput lines)
	if [ $height -ge 34 ]; then
		tput cup $[$(tput lines)-2]
	fi
	read -p "[Press Enter]" -s enterVar
}

function howToPage {
	echo "${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}"
	clear

	str="Terminal Rosary using Jq and Bash"
	width=$(tput cols)
	length=${#str}
	tput cup 0 $(((width/ 2)-(length/2)))
	echo $str

	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."

	instructionList="

	How to pray The Rosary:

	1.	Make the Sign of the Cross and say the Apostles Creed.
	2.	Say the Our Father.
	3.	Say three Hail Marys.
	4.	Say the Glory be to the Father.
	5.	Announce the first mystery; then say the Our Father.
	6.	Say ten Hail Marys, while meditating on the mystery.
	7.	Say the Glory be to the Father and the Fatima Prayer.
	8.	Announce the second mystery; then say the Our Father.
	9.	Repeat 6 and 7, and continue with third, fourth, and fifth mysteries in the same manner.
	10.	Say the Hail Holy Queen.
	11.	Say the Prayer After the Rosary.




	Reality Check:

	* This App is just a (personal) technical exercise. This App is a linguistic and scriptural \"refference\".
	* Try focusing more on the mysteries than on the actual prayers. But focus on the prayers too.
	* Use a blessed rosary. Some blessed rosaries may be associated with additional benefits.
	* Take a moment at the beginning of each decade to reflect on the mystery it represents"

	echo "${instructionList}${FG_NoColor}${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}"

	height=$(tput lines)
	if [ $height -ge 34 ]; then
		tput cup $[$(tput lines)-2]
	fi
	echo "Use the Arrow keys to navigate."

	while read -sN1 key
	do
	case "$key" in
	esac
		read -s -n1 -t 0.0001 k1 &>/dev/null
		read -s -n1 -t 0.0001 k2 &>/dev/null
		read -s -n1 -t 0.0001 k3 &>/dev/null
		key+=${k1}${k2}${k3} &>/dev/null

		case "$key" in
			$arrowRt )
				## Start the bead sequence
				beadCounter=$(( $mysteryJumpPosition - 7 ))
				query_mysteryName=.mystery[$dayMysteryIndex].mysteryName
				query_prayerText=.prayer[1].prayerText
				return_prayerText=$(jq $query_prayerText $rosaryJSON)
				echo "${FG_NoColor}${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}"
				clear
				return
				;;
		esac
	done

}

function goodbyescreen {
	# echo "$CLR_ALL"
	clear

	width=$(tput cols)
	height=$(tput lines)
	str="Terminal Rosary using Jq and Bash"
	length=${#str}
	tput cup $((height/2)) $(((width/ 2)-(length/2)))
	echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
	str="Goodbye"
	length=${#str}
	tput cup $height $(((width/ 2)-(length/2)))
	echo $str

	read -t 3 -p "" exitVar
	echo "$CLR_ALL"
}

#
## Bead Display
#

function blank_transition_display {
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	updateScreenSize

	initTputStingVars

	echo "${tputAppTitle}${tputAppClock}${tputAppTranslation}${tputAppHeaderLine}${tputAppMysteryLabel}${tputAppMystery}${tputAppDecadeLabel}${tputAppDecade}${tputAppMessageLabel}${tputAppMessage}${tputAppScriptureLabel}${tputAppScripture}${tputAppPrayerLabel}${tputAppPrayer}${tputAppBeadTypeNameLabel}${tputAppBeadTypeName}${tputClearProgressFooter}"
}

function tputBeadDisplay {
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	updateScreenSize

	tputStingVars

	echo "$tputAppTitle$tputAppClock$tputAppTranslation$tputAppHeaderLine$tputAppMysteryLabel$tputAppMystery$tputAppDecadeLabel$tputAppDecade$tputAppMessageLabel$tputAppMessage$tputAppScriptureLabel$tputAppScripture$tputAppPrayerLabel$tputAppPrayer$tputAppBeadTypeNameLabel$tputAppBeadTypeName$tputClearProgressFooter"
}

#
## Progressbars
#

function progressbars {
	height=$(tput lines)
	width=$(tput cols)

	if [ $height -ge 34 ]; then

		tputAppPrayer=$(tput cup $[$(tput lines)-9] 0; printf "%${width}s" ""; tput cup 24 8; echo $return_prayerText)

		str=" PROGRESS BARS "
		progressBarDivider=$(tput cup $[$(tput lines)-9] 0; printf "%${width}s" ""; tput cup $[$(tput lines)-9] 0; printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' ".")
		length=${#str}
		progressBarTitle=$(tput cup $[$(tput lines)-8] 0; printf "%${width}s" ""; tput cup $[$(tput lines)-8] $(((width/ 2)-(length/2))); echo $BAR_BG$BAR_FG$str$BACKGROUNDCOLOR$FOREGROUNDCOLOR)

		#########		
		if [ $thisDecadeSet -lt 10 ]; then
			decDisp=" $thisDecadeSet"
		else
			decDisp=$thisDecadeSet
		fi
		stringLength=${#return_prayerName}
		stringLength=$(( $stringLength + 1 ))
		tputDecadeBarLabel=$(tput cup $[$(tput lines)-7] 0; printf "%${width}s" ""; tput cup $[$(tput lines)-7] 0; echo " Decade:  $decDisp/10	 $return_beadType")$(tput cup $[$(tput lines)-7]  $[$(tput cols)-$stringLength]; echo $return_prayerName)
		proportion=$thisDecadeSet/10
		barWidth=$((width*$proportion))
		barWidth=$((barWidth - 2))
		barDecade=$(printf '%*s\n' "${COLUMNS:-$barWidth}" ' ' | tr ' ' '|')
		tputDecadeBar=$(tput cup $[$(tput lines)-6] 0; printf "%${width}s" ""; tput cup $[$(tput lines)-6] 1; echo $BAR_BG$BAR_FG$barDecade$BACKGROUNDCOLOR$FOREGROUNDCOLOR)

		#########
		if [ $mysteryProgress -lt 10 ]; then
			mystDisp=" $mysteryProgress"
		else
			mystDisp=$mysteryProgress
		fi
		stringLength=${#return_decadeName}
		stringLength=$(( $stringLength + 1 ))
		tputMysteryBarLabel=$(tput cup $[$(tput lines)-4] 0; printf "%${width}s" ""; tput cup $[$(tput lines)-4] 0; echo " Mystery: $mystDisp/50	 $return_mysteryName")$(tput cup $[$(tput lines)-4] $[$(tput cols)-$stringLength]; echo $return_decadeName)
		proportion=$mysteryProgress/50
		barWidth=$((width*$proportion))
		barWidth=$((barWidth - 2))
		barMystery=$(printf '%*s\n' "${COLUMNS:-$barWidth}" ' ' | tr ' ' '|')
		tputMysteryBar=$(tput cup $[$(tput lines)-2] 0; printf "%${width}s" ""; tput cup $[$(tput lines)-1] 0; printf "%${width}s" ""; tput cup $[$(tput lines)-3] 0; printf "%${width}s" ""; tput cup $[$(tput lines)-3] 1; echo $BAR_BG$BAR_FG$barMystery$BACKGROUNDCOLOR$FOREGROUNDCOLOR)

		# stringLength=${#isAudio}
		# isAudio=$(put cup $[$(tput lines)-1] $[$(tput cols)-$stringLength]; echo $isAudio)

		echo "$STYLES_OFF$BACKGROUNDCOLOR$FOREGROUNDCOLOR$progressBarDivider$progressBarTitle$tputDecadeBarLabel$tputDecadeBar$tputMysteryBarLabel$tputMysteryBar"
	fi

}

function beadProgress {
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

			fi

			# handles only the intro hail marys
			if [ $decadeIndex -eq 0 ]; then
				hailmaryCounter=0
				thisDecadeSet=0
				mysteryProgress=0
				
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
			beadAudioFile="./audio/AveMaria.ogg"

            ;;
		3)	## big bead
			stringSpaceCounter=0
            initialHailMaryCounter=0
            thisDecadeSet=0

            if [ $directionFwRw -ne 1 ]; then
				moddivision=$(( hailmaryCounter % 10 ))
				if [ $moddivision -gt 0 ]; then
					hailmaryCounter=$(( $hailmaryCounter - 1 ))
				fi
            fi
            
            beadAudioFile="./audio/PaterNoster.ogg"
            
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
            
            beadAudioFile="./audio/GloriaPatri.ogg"
            
            ;;
        5)	## Mary Icon
			if [ $directionFwRw -eq 1 ]; then
				stringSpaceCounter=3
			fi

            stringSpaceCounter=0;

			## mystery according to day of week
            # if [ $initialMysteryFlag -eq 0 ]; then
            #     beadCounter=$mysteryJumpPosition
            #     initialMysteryFlag=1
            # fi
            beadAudioFile="./audio/SalveRegina.ogg"
			;;
		6)	## cross
			# hailmaryCounter=0
			initialHailMaryCounter=0
            stringSpaceCounter=0
            # thisDecadeSet=0
            # mysteryProgress=0
            
            beadAudioFile="./audio/Credo.ogg"
			;;
        *)
			thisDecadeSet=0
            stringSpaceCounter=0
            mysteryProgress=0
            
            # beadAudioFile=""
            ;;
      esac
}

function bundledDisplay {
	resizeWindow
	tputBeadDisplay
	beadProgress
	progressbars
}

###################################################
## Dialog Menus
###################################################

function change_color_menu {

	screenTitle="Terminal Rosary using Jq and Bash"
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
		*) # echo "waiting"
			return
			;;
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
		*) # echo "waiting"
			return
			;;
	esac

}

function menuUP {
	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Menu"
	selectedMenuItem=$(dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--menu "Select an option:\
		\n WIP" \
		0 0 0 \
		"1" "About"\
		"2" "Start Joyful Mystery"\
		"3" "Start Luminous Mystery"\
		"4" "Start Sorrowfull Mystery"\
		"5" "Start Glorious Mystery"\
		"6"	"View Prayers"\
		"7" "Change Color Theme"\
		"8" "Feast Day Countdown"\
		"9" "Exit App")

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
		8)	## Feast Day List
			feastDayCountdown
			;;
		9)	## exit app
			killall fluidsynth &>/dev/null
			killall mplayer &>/dev/null

			goodbyescreen
			tput cnorm
			tput sgr0
			reset
			exit
			;;
		*)	## na
	esac

	if [ $introFlag -eq 1 ]; then
		echo $STYLES_OFF $CLR_ALL $BACKGROUNDCOLOR $FOREGROUNDCOLOR
		clear
		howToPage
	else

		echo $STYLES_OFF $CLR_ALL $BACKGROUNDCOLOR $FOREGROUNDCOLOR
		clear
		tputBeadDisplay
		progressbars
	fi
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

	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Language Selector"
	selectedMenuTranslation=$(dialog 2>&1 >/dev/tty \
		--backtitle "$screenTitle" \
		--title "$dialogTitle" \
		--ok-label "Ok" \
		--cancel-label "Cancel" \
		--radiolist "Switch language:\
		\n\n Use space bar to toggle\n" \
		0 0 0 \
		"1" "English - New American Bible" "$nabSwitch" \
		"2"	"Latin - Vulgate" "$vulgateSwitch" ) || selectedMenuTranslation=$translation


	translation=$selectedMenuTranslation

	translationDB
	jqQuery

	if [ $introFlag -eq 1 ]; then
		echo $STYLES_OFF $CLR_ALL $BACKGROUNDCOLOR $FOREGROUNDCOLOR
		clear
		howToPage
	else
		echo $STYLES_OFF $CLR_ALL $BACKGROUNDCOLOR $FOREGROUNDCOLOR
		clear
		tputBeadDisplay
		progressbars
	fi
}

function prayerMenu {
	prayerName=$(jq .prayer[1].prayerName $rosaryJSON)

	screenTitle="Terminal Rosary using Jq and Bash"
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
		"16" "$(jq .prayer[16].prayerName $rosaryJSON)" ) || return
		

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

    whiptail \
        --title "$dialogPrayerName" \
        --msgbox "$dialogPrayerText" 0 0

}

###################################################
## Keyboard Arrows UI
###################################################

function beadFWD {
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

function beadREV {

	if [ $beadCounter -gt $counterMIN ]; then
		directionFwRw=0
		beadCounter=$((beadCounter-1))

		rosaryBeadID=$beadCounter
		jqQuery
	fi
}

function arrowInputs {

	counterMIN=0
	counterMAX=315

	bundledDisplay

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

				## hide cursor
				tput civis
				;;
			$arrowDown) # language toggle
				menuDN

				## hide cursor
				tput civis
				;;
			$arrowRt) # navigate forward
				if [ $introFlag -ne 1 ]; then
					blank_transition_display
					beadFWD
					bundledDisplay
				fi
				;;
			$arrowLt) # navigate back
				blank_transition_display
				beadREV
				bundledDisplay
				
				;;
			"m" | "M") # mplayer audio
			
				if ! pgrep -x "mplayer" > /dev/null
				then					
					if [ "$beadAudioFile" != "" ]; then
						mplayer $beadAudioFile </dev/null >/dev/null 2>&1 &
					fi
				else
					killall mplayer &>/dev/null
				fi
				sleep .5s
				# progressbars
				
				;;
		esac
		
	done

	# Restore screen
    tput rmcup
}

###################################################
## Vars
###################################################

function download_audio {
	bash ./audio/dl-app-audio.sh
}

function download_dependencies {

	# distroName=$(awk -F= '/^NAME/{print $2}' /etc/os-release)
	
	## xorg shell emulator
	if ! [ -x "$(command -v xterm)" ];then
		sudo pacman -S --needed xterm
		sudo apt-get install xterm
	fi
	
	## bash gui menu
	if ! [ -x "$(command -v dialog)" ];then
		sudo pacman -S --needed dialog
		sudo apt-get install dialog
	fi
	
	## json parser
	if ! [ -x "$(command -v jq)" ];then
		sudo pacman -S --needed jq
		sudo apt-get install jq
	fi

	## c ompiler
	if ! [ -x "$(command -v gcc)" ];then
		sudo pacman -S --needed gcc
		sudo apt-get install gcc
	fi
}

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

function initialize {	
	# Save screen
    tput smcup

    BACKGROUNDCOLOR=${BG_BLACK}
	FOREGROUNDCOLOR=${FG_GREEN}
	BAR_BG=${BG_GREEN}
	BAR_FG=${FG_BLACK}
	echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
	clear

	initialMysteryFlag=0
	initialHailMaryCounter=0
	stringSpaceCounter=0
	hailmaryCounter=0
	beadCounter=0
	thisDecadeSet=0
	mysteryProgress=0
	beadAudioFile="-loop 0 ./audio/AveMaria2.ogg"

	introFlag=1
	translation=1

	## determine mystery of the day
	initializeFeastFlags
	trigger_feastDay
	mystery_Day

	## declare init language translation
	translationDB

	## dl audio if needed
	download_audio
}

function myMian {
	download_dependencies
	
	resizeWindow

	decorativeColors
	inputControlls
	initialize

	## hide cursor
	tput civis
	
	splashScreen
	welcomepage
	howToPage

	## turn off intro flag
	introFlag=0

	## infinite loop untill terminated by menu option
	arrowInputs
}

## Run
myMian

## Restore cursor
tput cnorm
tput sgr0
