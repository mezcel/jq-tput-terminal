#!/bin/bash
###################################################
## Elinks Mass Readings
###################################################

function elinksUsccbMassReadings {
	## Daily Mass Readings from USCB Website
	## http://www.usccb.org/bible/readings/010619.cfm

	## Define Today
	thisYear=$(date +%y)
	thisMonth=$(date +%m)
	thisDay=$(date +%d)

	currentDirPath=$(dirname $0)
	destinationPath=$currentDirPath/source/html/
	if ! [ -f $destinationPath ]; then
		mkdir $destinationPath
	fi

	htmlFileName=mass-readings.html
	htmlFilePath=$destinationPath$htmlFileName

	# wget $usccbHostUrl -P $destinationPath -O $htmlFileName
	usccbHostUrl="http://www.usccb.org/bible/readings/"$thisMonth$thisDay$thisYear".cfm"

	if ! [ -f $destinationPath/visitUsccbLog.txt ]; then
		echo "Website Visit Log:" > $destinationPath/visitUsccbLog.txt
		echo "------------------------------------------------------------------------------" >> $destinationPath/visitUsccbLog.txt
	fi
	echo "$(date)	$usccbHostUrl" >> $destinationPath/visitUsccbLog.txt

	## Put website text into a var
	websiteHtmlText=$(curl $usccbHostUrl)

	## Crop the desited text section
	cropText=$(echo $websiteHtmlText | grep -oP '\<div class\=\"contentarea\"\>\s*\K.*(?=\s+\<style type\=\"text\/css\"\>)')
	cropText="$(echo "$cropText" | sed 's/<a name\=\"readingssignup\".*$//g')"

	## convert local url path to remote web path
	htmlahref="href=\""
	urlhostahref="${htmlahref}http://www.usccb.org"
	cropText=${cropText//$htmlahref/$urlhostahref}

	## Make a tmp text file for bash display in elinks or Linx
	rm $htmlFilePath
	headerDate=$(date)
	echo "<p><hr><center><b>$headerDate</b></center><br><i>Press [q] to exit.<br>Press [Insert/Delete] to scroll up/down line-wise.</i><hr></p>$cropText" >> $htmlFilePath

	echo "${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}"
	clear
	width=$(tput cols)
	height=$(tput lines)
	str="Terminal Rosary using Jq and Bash"
	length=${#str}
	centerText=$(( (width / 2)-(length / 2) ))
	tputAppTitle=$(tput cup 0 $centerText; echo "$str")

	tputAppTranslation=$(tput cup 0 1; echo $translationName)
	tputAppClock=$(tput cup 0 $[$(tput cols)-29]; echo `date`)
	tputAppHeaderLine=$(tput cup 1 0; printf '%*s\n' "${COLUMNS:-$(tput cols)}" ' ' | tr ' ' ".")

	echo "${tputAppTitle}${tputAppTranslation}${tputAppClock}${tputAppHeaderLine}

	Today's daily mass readings is taken from: ${MODE_BEGIN_UNDERLINE}$usccbHostUrl${MODE_EXIT_UNDERLINE}

	Web scraped and parsed html file: \"$htmlFilePath\"

	Elinks Controlls:
		Press [q] to exit the Elinks app once within Elinks.
		Press [esc] for other Elinks options.

		[Insert/Delete]		Scroll up/down line-wise. (vertically)
		[PageUp/PageDown]	Scroll up/down page-wise.
		[Home/End]		Scroll to the start/end of the document.
	"
	height=$(tput lines)
	if [ $height -ge 34 ]; then
		tput cup $[$(tput lines)-2]
	fi
	read -p "[Press Enter]" -s enterVar

	## Display Text in a terminal web browser
	elinks $htmlFilePath
}

function elinksUsccb {
	## check if sever is up
	myPingAddr=usccb.org
	ping -c1 $myPingAddr &>/dev/null
	pingFlag=$?
	sleep .5s

	if [ $pingFlag -eq 0 ]; then
		elinksUsccbMassReadings
	else
		currentDirPath=$(dirname $0)
		elinks "$currentDirPath/source/html/404.html"
	fi
}