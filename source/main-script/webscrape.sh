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
    ##usccbHostUrl="http://www.usccb.org/bible/readings/"$thisMonth$thisDay$thisYear".cfm"

    usccbHostUrl="https://bible.usccb.org/bible/readings/"$thisMonth$thisDay$thisYear".cfm"

    if ! [ -f $destinationPath/visitUsccbLog.txt ]; then
        echo "Website Visit Log:" > $destinationPath/visitUsccbLog.txt
        echo "------------------------------------------------------------------------------" >> $destinationPath/visitUsccbLog.txt
    fi
    echo "$(date)   $usccbHostUrl" >> $destinationPath/visitUsccbLog.txt

    ## Put website text into a var
    websiteHtmlText=$(curl $usccbHostUrl)
    sleep 1

    ## Crop the desired text section
    #cropText=$(echo $websiteHtmlText | grep -oP '\<div class\=\"contentarea\"\>\s*\K.*(?=\s+\<style type\=\"text\/css\"\>)')
    #cropText="$(echo "$cropText" | sed 's/<a name\=\"readingssignup\".*$//g')"

    ## Updated Dec2020
    ## Check if two Reading 1 & 2 are available
    echo $websiteHtmlText | grep "Reading 2" &>/dev/null
    isTwoReadings=$?


    if [ $isTwoReadings -eq 0 ]; then
        readingOne=$(echo $websiteHtmlText | sed -e 's/.*<h3 class="name">Reading 1 <\/h3>\(.*\)<h3 class="name">Responsorial Psalm <\/h3>.*/\1/')
        responsorialPsalms=$(echo $websiteHtmlText | sed -e 's/.*<h3 class="name">Responsorial Psalm <\/h3>\(.*\)<h3 class="name">Reading 2 <\/h3>.*/\1/')
        readingTwo=$(echo $websiteHtmlText | sed -e 's/.*<h3 class="name">Reading 2 <\/h3>\(.*\)<h3 class="name">Gospel <\/h3>.*/\1/')
        gospelReadings=$(echo $websiteHtmlText | sed -e 's/.*<h3 class="name">Gospel <\/h3>\(.*\)<div class="block block-ai-html-parser block-readings-books">.*/\1/')

        cropText="<h3>Reading 1</h3> ${readingOne} <h3>Responsorial Psalm</h3> ${responsorialPsalms} <h3>Reading 2</h3> ${readingTwo} <h3>Gospel</h3> ${gospelReadings}"
    else
        readingOne=$(echo $websiteHtmlText | sed -e 's/.*<h3 class="name">Reading 1 <\/h3>\(.*\)<h3 class="name">Responsorial Psalm <\/h3>.*/\1/')
        responsorialPsalms=$(echo $websiteHtmlText | sed -e 's/.*<h3 class="name">Responsorial Psalm <\/h3>\(.*\)<h3 class="name">Gospel <\/h3>.*/\1/')
        gospelReadings=$(echo $websiteHtmlText | sed -e 's/.*<h3 class="name">Gospel <\/h3>\(.*\)<div class="block block-ai-html-parser block-readings-books">.*/\1/')

        cropText="<h3>Reading 1</h3> ${readingOne} <h3>Responsorial Psalm</h3> ${responsorialPsalms} <h3>Gospel</h3> ${gospelReadings}"
    fi


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

        [Insert/Delete]     Scroll up/down line-wise. (vertically)
        [PageUp/PageDown]   Scroll up/down page-wise.
        [Home/End]      Scroll to the start/end of the document.
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
