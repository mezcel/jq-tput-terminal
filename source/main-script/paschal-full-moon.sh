#!/bin/bash

###################################################
## Holliday Dates Calculation
###################################################

#
## Flag Vars
#

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
	isChristmasSeason=0
	isTodaySolemnityOfMary=0
	isTodayEpiphany=0
	isTodayEpiphany2=0
	isTodayJesusBaptism=0
	isTodayAll_Saints=0

	isOrdinaryTime=0
}

function livingSeasonABC {

	## Living Seasons of Change by Liturgical Year Cycles and Month:
	## A,B,C
	cycleSeasonAdvent=("" "Season of Waiting" "Season of Preparation" "Season of Holiness")
	cycleSeasonEpiphany=("" "Season of Foundation" "Season of New Beginning" "Season of Manifestation")
	cycleSeasonLent=("" "Season of Hope" "Season of Cross Purposes" "Season of Repentance")
	cycleSeasonPentacost=("" "Season of Glory" "Season of Power" "Season of the Spirit")
	cycleSeasonEaster=("" "Season of Salvation" "Season of More Season of Witness" "Season of Joy & Life")

	# Season of Traveling with Jesus (Wk 4-7 Ord B); Season of Sharing (Weeks 3-7 Ordinary C)
	# Season of Salvation (Holy Week, Easter A);Season of More (Easter A); Season of Witness (Holy Week, Easter B);  Season of Joy & Life (Easter C)
	# Season of Apostleship (Wks 9-12 Ordinary A); Season of Signs (Trinity, Body & Blood, 12-13 Ord B); Season of Solemnities (Trinity, Body & Blood C)
	# Season of Discovery (Weeks 14-17 Ordinary A); Season of Patterns (Weeks  14-17 Ordinary B); Season of Journey (Weeks 13-17 Ordinary C)
	# Season of Following Jesus (Weeks 18-22 Ord A); Season of Living Bread (Weeks 18-21 Ordinary B); Season of Treasure (Weeks 18-21 Ordinary C)
	# Season of Agreement (Weeks 23-26 Ordinary A); Season of Mark of the Disciple (Weeks 22-26 Ord B); Season of Acceptance (Weeks 22-26 Ordinary C)
	# Season of Greatest Commandment (Weeks 27-30 Ord A); Season of Vocation (Weeks 27-30 Ordinary B); Season of Faith (Weeks 27-30 Ordinary C)
	# Season of Time (All Saints-Christ the King A); Season of Forever (All Saints-Christ the King B); Season of the Kingdom (All Saints-Christ the King C)

}

#
## PFM Table Calculations
#

function pfmTableDate {
	## Divide the current year by 19 and get the 1st 3 digits after the decimal

	yearDiv3_decimal=$(echo "scale=3; $thisYear / 19" | bc)
	yearDiv3_int=$(( $thisYear / 19 ))
	last3dec=$( echo "scale=3; $yearDiv3_decimal - $yearDiv3_int" | bc )
	wholeNum=$( echo "scale=0; $last3dec * 1000" | bc )
	wholeNum=$( echo $wholeNum | awk '{print int($0)}' ) ## Floor Round'

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

function pfmTableMonth {
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

	# remove first char
	estimatedDay=${pfmDate:1}

	if [ ${#estimatedDay} -lt 2 ]; then
		estimatedDay=0$estimatedDay
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

	## thisYear=$(date +%Y)
	last2numbers=${thisYear:${#thisYear}-2}

	# thisYear=$(date +%Y)
	# last2numbers=$( echo -n $thisYear | tail -c 2 )

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
		tabulatedDate="$nextYear$monthDay"
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
		nextYear=$(( $thisYear + 1 ))
		thisYear=$nextYear
		pfmTableDate
		pfmTableMonth
		pfmTableYear
		pfmTableDecade
		pfmTableCentury
		pfmTableSum

		tabulatedDate=$nextYear$virtualMonthNo$estimatedDay
		daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillEaster=$daysUntill
	if [ $daysUntillEaster == 0 ]; then
		isTodayEaster=1
	else
		isTodayEaster=0
	fi

	## Determine Lent Season

	if [ $daysUntillEaster -gt 0 ] && [ $daysUntillEaster -le 46 ]; then
		isLentSeasion=1
	else
		isLentSeasion=0
	fi
}

#
## Liturgical Calendar Counters
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



}

function days_untill_Jesus_Assension {
	## 40 Days After Easter, Thursday

	thisYear=$(date +%Y)
	## calculate_Paschal_Full_Moon
	
	pfmTableDate
	pfmTableMonth
	pfmTableYear
	pfmTableDecade
	pfmTableCentury
	pfmTableSum
	
	tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
	daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	
	if [ $daysUntill -lt 0 ]; then
		daysToAdd=$(( $daysToAdd + 40 ))
		daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

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
	# calculate_Paschal_Full_Moon
	
	pfmTableDate
	pfmTableMonth
	pfmTableYear
	pfmTableDecade
	pfmTableCentury
	pfmTableSum
	
	tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
	daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	
	if [ $daysUntill -lt 0 ]; then
		daysToAdd=$(( $daysToAdd + 49 ))
		daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

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
	if [ $daysUntillPentecost -gt 0 ] && [ $daysUntillPentecost -lt 50 ]; then
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

	if [ $daysUntillChristmas -gt 0 ] && [ $daysUntillChristmas -lt $adventDurration ]; then
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
	## The day is transfered to a Sunday if the day falls between Jan 2-8
	## Day of Obligation

	thisYear=$(date +%Y)
	monthDay="0106"

	days_Untill_Count

	daysUntillEpiphany=$saveTheDate

	## Shift day onto a Sunday
	weekdayEpiphany=$(date --date="$(date) +$daysUntillEpiphany days" +%u) # mon is 1
	daysFromSunday=$((  7 - $weekdayEpiphany ))
	daysUntillEpiphany=$((  $daysUntillEpiphany - $daysFromSunday ))

	if [ $daysUntillEpiphany -gt 0 ] && [ $daysUntillEpiphany -le 12 ]; then
		isChristmasSeason=1
	else
		isChristmasSeason=0
	fi

	if [ $daysUntillEpiphany -eq 0 ]; then
		isTodayEpiphany=1
	else
		isTodayEpiphany=0
	fi
}

function thePreviousEphany {
	## calculate when the last ephany was

	thisYear=$(date +%Y)
	lastYear=$( $thisYear - 1 )
	thisYear=$lastYear
	monthDay="0106"

	days_Untill_Count

	daysUntillEpiphany2=$saveTheDate

	## Shift Epiphany day onto a Sunday
	weekdayEpiphany2=$(date --date="$(date) +$daysUntillEpiphany2 days" +%u) # mon is 1
	daysFromSunday2=$((  7 - $weekdayEpiphany2 ))
	daysUntillEpiphany2=$((  $daysUntillEpiphany2 - $daysFromSunday2 ))

	## Add a day if they share the same day
	if [ $daysUntillEpiphany2 -eq 0 ]; then
		isTodayEpiphany2=1
		daysUntillJesusBaptism=$($daysUntillJesusBaptism + 1)
	else
		isTodayEpiphany2=0
	fi
}

function days_untill_JesusBaptism {
	## Aprox Jan 13
	## sunday after the Mass which celbrates the Epiphany
	## Monday if Epiphany Sunday shared the same day

	thisYear=$(date +%Y)
	monthDay="0113"

	days_Untill_Count

	daysUntillJesusBaptism=$saveTheDate

	## Shift JesusBaptism day onto a Sunday
	weekdayJesusBaptism=$(date --date="$(date) +$daysUntillJesusBaptism days" +%u) # mon is 1
	daysFromSunday=$((  7 - $weekdayJesusBaptism ))
	daysUntillJesusBaptism=$((  $daysUntillJesusBaptism - $daysFromSunday ))

	## Check if the day conflicts with Epiphany
	if [ $daysUntillJesusBaptism -eq 0 ]; then
		thePreviousEphany
	fi

	if [ $daysUntillJesusBaptism -eq 0 ] && [ $isTodayEpiphany2 -eq 0 ] && [ $daysUntillJesusBaptism -ne $daysUntillEpiphany ]; then
		isTodayJesusBaptism=1
		isOrdinaryTime=1
	else
		if [ $daysUntillJesusBaptism -eq $daysUntillEpiphany ]; then
			daysUntillJesusBaptism=$( $daysUntillJesusBaptism + 1 )
		fi
		isTodayJesusBaptism=0
	fi
}

function days_untill_OrdinaryTime {
	## 33-34 weeks total

	if [ $isAdventSeasion -eq 0 ] && [ $isEasterSeason -eq 0 ] && [ $isLentSeasion -eq 0 ] && [ $isChristmasSeason -eq 0 ]; then
		isOrdinaryTime=1
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
	days_untill_JesusBaptism
	days_untill_Solemnity_of_Mary
	days_untill_OrdinaryTime

	yearCycleABC

	## Feast Day App Color Theme
	## It is required, for Catholics, to go to Mass at least 2x a year. Easter and Christmas would be the 2 days to go.

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

	dialogHR1="\n--- Days Untill --- \n"
	dialogEaster="Easter:	$daysUntillEaster \n"
	dialogAssension="Assension of Jesus:	$daysUntillJesusAssension \n"
	dialogPentecost="Pentecost:	$daysUntillPentecost \n"
	dialogAllSaints="All Saints:	$daysUntillAllSaints \n"
	dialogAdvent="Start Advent:	$daysUntillAdvent \n"
	dialogConception="Conception:	 $daysUntillImmaculateConception \n"
	dialogChristmas="Christmas:	$daysUntillChristmas \n"
	dialogSolemnity="Solemnity of Mary:	$daysUntillSolemnityOfMary \n"
	dialogEpiphany="Epiphany:	$daysUntillEpiphany \n"
	dialogJesusBaptism="Baptism of Jesus: $daysUntillJesusBaptism \n"
	dialogAsh="Ash Wednesday:	$daysUntillAshWednesday \n"
	dilogHolyThursday="Holy Thursday: $daysUntillHolyThursday \n"
	dialogGoodFriday="Good Friday: $daysUntillGoodFriday \n"
	dialogHolySaturday="Holy Saturday: $daysUntillHolySaturday \n"

	dialogHR2="\n--- Season Flags --- \n"
	dialogABCCycle="$cycleLetter \n"
	dialogOrdinaryTimeSeason="Ordinary Time Season: $isOrdinaryTime \n"
	dialogLentSeason="Lent Season: $isLentSeasion \n"
	dialogAdventSeason="Advent Season: $isAdventSeasion \n"
	dialogChristmasSeason="Christmas Season: $isChristmasSeason \n"
	dialogEasterSeason="Easter Season: $isEasterSeason \n"

	msgCountdownList="$dialogHR1$dialogEaster$dialogAssension$dialogPentecost$dialogAllSaints$dialogAdvent$dialogConception$dialogChristmas$dialogSolemnity$dialogEpiphany$dialogJesusBaptism$dialogAsh$dilogHolyThursday$dialogGoodFriday$dialogHolySaturday$dialogHR2$dialogABCCycle$dialogOrdinaryTimeSeason$dialogLentSeason$dialogAdventSeason$dialogChristmasSeason$dialogEasterSeason\n"

	screenTitle="Terminal Rosary using Jq and Bash"
	dialogTitle="Feast Day Countdown"

	dialog \
        --backtitle "$screenTitle" \
        --title "$dialogTitle" \
        --infobox "$msgCountdownList" 0 0

	read

	## Disp an Ascii Pie Chart
	dispPieChart
}

function yearCycleABC {
	## Year A  12/2016-11/2017, 2019-2020, 2022-23
	## Year B  12/2017-11/2018,  2020-2021, 2023-24
	## Year C  12/2015-11/2016, 2018-19, 2021-22

	## Year starts on the 1st Sunday of Advent on the previous year

	thisYear=$(date +%Y)
	calday=$( cal 12 "$thisYear" | awk 'NF==7 && !/^Su/{print $1;exit}' )
	monthDay="120"$calday
	tabulatedDate=$thisYear$monthDay
	saveTheDate=$(( ($(date --date="$tabulatedDate" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $saveTheDate -lt 0 ]; then
		# use next year
		# cycleYear=$(( $thisYear + 1 ))
		cycleYear=$thisYear
	else
		# use this year
		# cycleYear=$thisYear
		cycleYear=$(( $thisYear - 1 ))
	fi

	decadeYear=$(( $cycleYear - 2000 ))
	modularDiv3=$(expr $decadeYear % 3)

	case $modularDiv3 in
		1 )
			cycleLetter="Sunday Cycle A: The Gospel of Matthew"
			abcNo=1
			;;
		2 )
			cycleLetter="Sunday Cycle B: The Gospel of Mark"
			abcNo=2
			;;
		0 )
			cycleLetter="Sunday Cycle C: The Gospel of Luke"
			abcNo=3
			;;
	esac

	livingSeasonABC

	abcAdvent=${cycleSeasonAdvent[$abcNo]}
	abcChristmas=${cycleSeasonEpiphany[$abcNo]}
	abcLent=${cycleSeasonLent[$abcNo]}
	abcEaster=${cycleSeasonEaster[$abcNo]}
}

#
# Pie Chart Info Page
#
function dispPieChart {

	echo "${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}"
	clear

	str="Terminal Rosary using Jq and Bash"
	width=$(tput cols)
	length=${#str}
	centerText=$(( (width / 2)-(length / 2) ))
	pieChartTitle=$( tput cup 0 $centerText )
	echo "$pieChartTitle$str"

	printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' "."

	str="Liturgical Year Pie Chart"
	width=$(tput cols)
	length=${#str}
	centerText=$(( (width / 2)-(length / 2) ))
	pieChartHeader=$(tput cup 3 $centerText)
	echo "$pieChartHeader$str"
	echo ""

	currentDirPath=$(dirname $0)
	cat "$currentDirPath/source/main-script/tiny-pie.txt"

	height=$(tput lines)
	if [ $height -ge 34 ]; then
		tput cup $[$(tput lines)-2]
	fi

	read -p "[Enter]" -s enterVar
}
