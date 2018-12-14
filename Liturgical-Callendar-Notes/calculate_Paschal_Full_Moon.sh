#!/bin/sh

## Calendar Calculator

## Easter Sunday is the Sunday following the Paschal Full Moon (PFM) date for the year.
## In June 325 A.D. astronomers approximated astronomical full moon dates for the Christian church, calling them Ecclesiastical Full Moon (EFM) dates. From 326 A.D. the PFM date has always been the EFM date after March 20 (which was the equinox date in 325 A.D.)
## Table Data derived from https://www.assa.org.au/edm
## http://orthodox-theology.com/media/PDF/1.2017/Erekle.Tsakadze.pdf

## Ordinary Time comprises two periods: the first period begins on Epiphany Day (in the Anglican Communion and Methodist churches) or the day after the Feast of the Baptism of the Lord (in the Catholic Church) and ends on the day before Ash Wednesday; the second period begins on the Monday after Pentecost, the conclusion of the Easter season, and continues until the Saturday before the First Sunday of Advent.

function initializeFeastFlags() {
	isEaster=0
	isAsh_Wednesday=0
	isJesus_Assension=0
	isPentecost=0	
	isImmaculateConception=0
	isChristmas=0
	isSolemnityOfMary=0
	isAll_Saints=0
}

#########################
## PFM Table Calculations
#########################

function pfmTableDate() {
	thisYear=$(date +%Y)

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

function pfmTableYear() {
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

function pfmTableDecade() {
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

function pfmTableCentury() {
	## First 2 digits if current year
	## I expect it will be 20 for the next +900 years... but the calander has changed more than once in the last 900 years
	## There is a lookup table for this... but we do not need to do that, 20 is just 0
	
	centuryNo=0
}

function pfmTableSum() {
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

########################
## Calculate Days Untill
########################

function days_Untill_Count() {
	thisYear=$(date +%Y)
	tabulatedDate=$thisYear$monthDay
	saveTheDate=$(( ($(date --date="$tabulatedDate" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $saveTheDate -lt 0 ]; then
		nextYear=$(( $thisYear + 1 ))
		tabulatedDate=$nextYear$monthDay
		saveTheDate=$(( ($(date --date="$tabulatedDate" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi
}

function calculate_Paschal_Full_Moon() {
	## Easter
	
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
		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))	
	fi

	daysUntillEaster=$daysUntill
	if [ $daysUntillEaster == 0 ]; then
		isEaster=1
	else
		isEaster=0
	fi
	
}

function days_untill_Ash_Wednesday() {
	## Lent begins on Ash Wednesday, which is always held 46 days (40 fasting days and 6 Sundays) before Easter Sunday.

	calculate_Paschal_Full_Moon
	
	daysToRemove=$(( $daysToAdd - 46 ))
	daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))
		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysUntill=$(( ($(date --date="$tabulatedDate -$daysToRemove days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))
	fi

	daysUntillAshWednesday=$daysUntill
	if [ $daysUntillAshWednesday == 0 ]; then
		isAsh_Wednesday=1
	else
		isAsh_Wednesday=0
	fi
}

function days_untill_Jesus_Assension() {
	## 40 Days After Easter, Thursday
	
	calculate_Paschal_Full_Moon

	daysToAdd=$(( $daysToAdd + 40 ))
	daysUntillJesusAssension=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntillJesusAssension == 0 ]; then
		isJesus_Assension=1
	else
		isJesus_Assension=0
	fi
}

function days_untill_Pentecost() {
	## 7 Sundays after Easter

	calculate_Paschal_Full_Moon

	daysToAdd=$(( $daysToAdd + 49 ))
	daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))

	if [ $daysUntill -lt 0 ]; then
		thisYear=$(( $thisYear + 1 ))
		tabulatedDate=$thisYear$virtualMonthNo$estimatedDay
		daysUntill=$(( ($(date --date="$tabulatedDate +$daysToAdd days" +%s) - $(date --date="$(date +%F)" +%s) )/(60*60*24) ))	
	fi

	daysUntillPentecost=$daysUntill
	if [ $daysUntillPentecost == 0 ]; then
		isPentecost=1
	else
		isPentecost=0
	fi
}

function days_untill_Immaculate_Conception() {
	## Dec 8
	
	monthDay="1208"
	days_Untill_Count

	daysUntillImmaculateConception=$saveTheDate

	if [ $daysUntillImmaculateConception == 0 ]; then
		isImmaculateConception=1
	else
		isImmaculateConception=0
	fi
	
}

function days_untill_Christmas() {
	## Dec 25
	
	monthDay="1225"
	days_Untill_Count

	daysUntillChristmas=$saveTheDate

	if [ $daysUntillChristmas == 0 ]; then
		isChristmas=1
	else
		isChristmas=0
	fi
}

function days_untill_All_Saints() {
	## Nov 1
	
	monthDay="1101"
	days_Untill_Count

	daysUntillAllSaints=$saveTheDate

	if [ $daysUntillAllSaints == 0 ]; then
		isAll_Saints=1
	else
		isAll_Saints=0
	fi
}

function days_untill_Solemnity_of_Mary() {
	## Jan 1
	monthDay="0101"
	days_Untill_Count

	daysUntillSolemnityOfMary=$saveTheDate

	if [ $daysUntillSolemnityOfMary == 0 ]; then
		isSolemnityOfMary=1
	else
		isSolemnityOfMary=0
	fi
}

########################
## Debug Disp
########################

initializeFeastFlags

calculate_Paschal_Full_Moon
days_untill_Christmas
days_untill_Ash_Wednesday
days_untill_Pentecost
days_untill_Immaculate_Conception
days_untill_Jesus_Assension
days_untill_All_Saints
days_untill_Solemnity_of_Mary

echo "daysUntillEaster
	$daysUntillEaster
	$isEaster
"
echo "daysUntillChristmas
	$daysUntillChristmas
	$isChristmas
"
echo "daysUntillAshWednesday
	$daysUntillAshWednesday
	$isAsh_Wednesday
"
echo "daysUntillPentecost
	$daysUntillPentecost
	$isPentecost
"
echo "daysUntillImmaculateConception
	$daysUntillImmaculateConception
	$isImmaculateConception
"
echo "daysUntillJesusAssension
	$daysUntillJesusAssension
	$isJesus_Assension
"
echo "daysUntillAllSaints
	$daysUntillAllSaints
	$isAll_Saints
"
echo "daysUntillSolemnityOfMary
	$daysUntillSolemnityOfMary
	$isSolemnityOfMary
"
