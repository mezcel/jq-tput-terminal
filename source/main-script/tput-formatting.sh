#!/bin/bash
###################################################
## tput Page Display
###################################################

function transitionalTputStingVars {
    clearTpuLine=$( tput el)

    width=$( tput cols )
    height=$( tput lines )
    str="Terminal Rosary using Jq and Bash"
    length=${#str}
    centerText=$(( ( width / 2 )-( length / 2 ) ))
    tputAppTitle=$( tput cup 0 $centerText; echo "$str" )

    tputAppTranslation=$( tput cup 0 1 )
    tputAppClock=$( tput cup 0 $[$( tput cols )-29]; echo `date` )
    tputAppHeaderLine=$( tput cup 1 0; printf '%*s\n' "${COLUMNS:-$( tput cols )}" ' ' | tr ' ' "." )

    tputAppMysteryLabel=$( tput cup 4 0; echo "Mystery Name:" )
    tputAppDecadeLabel=$( tput cup 8 0; echo "Mystery Decade:" )
    tputAppMessageLabel=$( tput cup 12 0; echo "Mystery Message:" )
    tputAppScriptureLabel=$( tput cup 16 0; printf "%${width}s" ""; tput cup 16 0; echo "Scripture Text:"; tput cup 17 0; printf "%${width}s" ""  )

    ## Special condition for introdution prayers
    if [ $mysteryProgress -eq 0 ]; then
        ## Introduction Prayers
        # tputAppMystery=$( tput cup 6 0; printf "%${width}s" ""; tput cup 6 4; printf "%${width}s" "" )
        tputAppMessage=$( tput cup 14 0; printf "%${width}s" ""; tput cup 14 4; printf "%${width}s" ""; tput cup 15 0; printf "%${width}s" "" )
        tputAppScripture=$( tput cup 18 0; printf "%${width}s" "" )$( tput cup 19 0; printf "%${width}s" "" )$( tput cup 20 0; printf "%${width}s" "" )$( tput cup 21 0; printf "%${width}s" "" )$( tput cup 18 4; printf "%${width}s" "" )
    else
        ## the rest of the rosary
        # tputAppMystery=$( tput cup 6 0; printf "%${width}s" ""; tput cup 6 4; echo "  loading..." )
        tputAppMessage=$( tput cup 14 0;  printf "%${width}s" ""; tput cup 14 4; echo " loading..."; tput cup 15 0; printf "%${width}s" "" )
        tputAppScripture=$( tput cup 18 0; printf "%${width}s" "" )$( tput cup 19 0; printf "%${width}s" "" )$( tput cup 20 0; printf "%${width}s" "" )$( tput cup 21 0; printf "%${width}s" "" )$( tput cup 18 4; echo "   loading..." )
    fi

    tputAppPrayerLabel=$( tput cup 22 0; printf "%${width}s" ""; tput cup 22 0; echo "Prayer Text:"; printf "%${width}s" "" )
    tputAppPrayer=$( tput cup 23 0; printf "%${width}s" "" )$( tput cup 24 0; printf "%${width}s" "" )$( tput cup 25 0; printf "%${width}s" "" )$( tput cup 26 0; printf "%${width}s" "" )$( tput cup 27 0; printf "%${width}s" "" )$( tput cup 28 0; printf "%${width}s" "" )$( tput cup 24 4; echo "  loading..." )

    ## Render terminal layout display
    tput civis
    echo "${tputAppTitle}${tputAppClock}${tputAppTranslation}${tputAppHeaderLine}${tputAppMysteryLabel}${tputAppMystery}${tputAppDecadeLabel}${tputAppDecade}${tputAppMessageLabel}${tputAppMessage}${tputAppScriptureLabel}${tputAppScripture}${tputAppPrayerLabel}${tputAppPrayer}${tputAppBeadTypeNameLabel}${tputAppBeadTypeName}${tputClearProgressFooter}"
}

function tputStingVars {
    formatJqText

    width=$( tput cols )
    height=$( tput lines )
    str="Terminal Rosary using Jq and Bash"
    length=${#str}
    centerText=$(( ( width/2 )-( length / 2 ) ))
    tputAppTitle=$( tput cup 0 $centerText; echo "$str" )

    tputAppTranslation=$( tput cup 0 1; echo $translationName )
    tputAppClock=$( tput cup 0 $[$( tput cols )-29]; echo `date` )
    tputAppHeaderLine=$( tput cup 1 0; printf '%*s\n' "${COLUMNS:-$( tput cols )}" ' ' | tr ' ' "." )

    tputAppMysteryLabel=$( tput cup 4 0; echo "${MODE_BEGIN_UNDERLINE}Mystery Name${MODE_EXIT_UNDERLINE}:" )
    tputAppMystery=$( tput cup 6 0; printf "%${width}s" ""; tput cup 6 8; echo $return_mysteryName; tput cup 7 0; printf "%${width}s" "" )

    tputAppDecadeLabel=$( tput cup 8 0; echo "${MODE_BEGIN_UNDERLINE}Mystery Decade${MODE_EXIT_UNDERLINE}:" )
    tputAppDecade=$( tput cup 10 0; printf "%${width}s" ""; tput cup 10 8; echo $return_decadeName )

    ## Special condition durring introdution prayers sequence
    if [ $mysteryProgress -eq 0 ]; then
        ## Introduction Prayers
        tputAppScriptureLabel=$( tput cup 16 0; echo "${MODE_BEGIN_UNDERLINE}Scripture Text${MODE_EXIT_UNDERLINE}:" )
        tputAppScripture=$( tput cup 18 0; printf "%${width}s" "" )$STYLES_OFF$BACKGROUNDCOLOR$FOREGROUNDCOLOR
    else
        ## the rest of the rosary
        tputAppScriptureLabel=$( tput cup 16 0; echo "${MODE_BEGIN_UNDERLINE}Scripture Text${MODE_EXIT_UNDERLINE}:" )
        tputAppScripture=$( tput cup 18 0; printf "%${width}s" ""; tput cup 18 8; echo $return_scriptureText )$STYLES_OFF$BACKGROUNDCOLOR$FOREGROUNDCOLOR
    fi

    tputAppPrayerLabel=$( tput cup 22 0; printf "%${width}s" ""; tput cup 22 0; echo "${MODE_BEGIN_UNDERLINE}Prayer Text${MODE_EXIT_UNDERLINE}:" )
    tputAppPrayer=$( tput cup 24 0; printf "%${width}s" ""; tput cup 24 8; echo $return_prayerText)

    ## Special Condition to display backgoud information before starting a decade
    ## Hide the scriptre slot and the message slot, and instead display decade info
    case $beadID in
        3 | 5 ) ## Decade start
            if [ $prayerIndex -eq 0 ]; then
                isDecadeInfo=1
            else
                isDecadeInfo=0
            fi
            ;;
        * ) ## Normal rendering sequence
            isDecadeInfo=0
            ;;
    esac

    if [ $isDecadeInfo -eq 1 ]; then
        ## Decade start

        ## Clear the scripture slot
        tputAppScriptureLabel=$( tput cup 16 0; printf "%${width}s" ""; tput cup 17 0; printf "%${width}s" "_" )
        tputAppScripture=$( tput cup 18 0; printf "%${width}s" "" )$( tput cup 19 0; printf "%${width}s" "" )$( tput cup 20 0; printf "%${width}s" "" )$( tput cup 21 0; printf "%${width}s" "" )$( tput cup 18 4; printf "%${width}s" "" )

        ## Replace the message space with mystery background notes
        tputAppMessageLabel=$( tput cup 12 0; printf "%${width}s" ""; tput cup 12 0; echo "${MODE_BEGIN_UNDERLINE}Background${MODE_EXIT_UNDERLINE}:" )
        tputAppMessage=$( tput cup 14 0; printf "%${width}s" ""; tput cup 15 0; printf "%${width}s" ""; tput cup 14 0; echo $return_decadeInfo)

        ## Output string
        tput civis
        echo "$tputAppTitle$tputAppClock$tputAppTranslation$tputAppHeaderLine$tputAppMysteryLabel$tputAppMystery$tputAppDecadeLabel$tputAppDecade$tputAppScriptureLabel$tputAppScripture$tputAppMessageLabel$tputAppMessage$tputAppPrayerLabel$tputAppPrayer$tputAppBeadTypeNameLabel$tputAppBeadTypeName$tputClearProgressFooter"
    else
        ## Normal rendering sequence
        tputAppMessageLabel=$( tput cup 12 0; echo "${MODE_BEGIN_UNDERLINE}Mystery Message${MODE_EXIT_UNDERLINE}:" )
        tputAppMessage=$( tput cup 14 0; printf "%${width}s" ""; tput cup 14 8; echo $return_mesageText; tput cup 15 0; printf "%${width}s" "")
        tputAppScriptureLabel=$( tput cup 16 0; printf "%${width}s" ""; tput cup 16 0; echo "${MODE_BEGIN_UNDERLINE}Scripture Text${MODE_EXIT_UNDERLINE}:"; tput cup 17 0; printf "%${width}s" ""; )
        tputAppScripture=$( tput cup 18 0; printf "%${width}s" ""; tput cup 18 8; echo $return_scriptureText)$STYLES_OFF$BACKGROUNDCOLOR$FOREGROUNDCOLOR

        ## Output string
        tput civis
        echo "$tputAppTitle$tputAppClock$tputAppTranslation$tputAppHeaderLine$tputAppMysteryLabel$tputAppMystery$tputAppDecadeLabel$tputAppDecade$tputAppMessageLabel$tputAppMessage$tputAppScriptureLabel$tputAppScripture$tputAppPrayerLabel$tputAppPrayer$tputAppBeadTypeNameLabel$tputAppBeadTypeName$tputClearProgressFooter"
    fi

}

function audio_credits {

    FG_NoColor=$(tput sgr0)
    FG_CYAN=$(tput setaf 6)
    MODE_ENTER_STANDOUT=$(tput smso)
    MODE_EXIT_STANDOUT=$(tput rmso)

echo "$FG_CYAN
Libre audio used in this application:
- https://commons.wikimedia.org/wiki/File:${MODE_ENTER_STANDOUT}Schola_Gregoriana-Ave_Maria.ogg${MODE_EXIT_STANDOUT}
- https://commons.wikimedia.org/wiki/File:${MODE_ENTER_STANDOUT}Schola_Gregoriana-Pater_Noster.ogg${MODE_EXIT_STANDOUT}
- https://commons.wikimedia.org/wiki/File:${MODE_ENTER_STANDOUT}JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg${MODE_EXIT_STANDOUT}
- https://commons.wikimedia.org/wiki/File:${MODE_ENTER_STANDOUT}Byrd_4-Part_Mass_-_Credo.ogg${MODE_EXIT_STANDOUT}
- https://commons.wikimedia.org/wiki/File:${MODE_ENTER_STANDOUT}Petits_Chanteurs_de_Passy_-_Salve_Regina_de_Hermann_Contract.ogg${MODE_EXIT_STANDOUT}
- https://commons.wikimedia.org/wiki/File:${MODE_ENTER_STANDOUT}Schola_Gregoriana-Antiphona_et_Magnificat.ogg${MODE_EXIT_STANDOUT}
- https://commons.wikimedia.org/wiki/File:${MODE_ENTER_STANDOUT}The_Tudor_Consort_-_J_S_Bach_-_Magnificat_BWV_243_-_Gloria_Patri.ogg${MODE_EXIT_STANDOUT}
$FG_NoColor
Press any key to continue, or wait 10s ...
"

    read -t 10 readPause
}

function myAbout {
    aboutText="Author: \n    Mezcel (https://github.com/mezcel) \n    Wiki based on the 1st version (https://mezcel.wixsite.com/rosary)\n\nDescription:\n    This is a Rosary App for the Linux Bash terminal.\n    This app was developed for Xterm on Archlinux & Debian.\n    The best UI experience for this app is through a login console TTY CLI\n\n    This App is just a (personal) technical exercise. This App is a linguistic and scriptural \"reference\". \n\nSource Code:\n    git clone https://github.com/mezcel/jq-tput-terminal.git\n\nLibre audio used in this application:\n- https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Ave_Maria.ogg\n- https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Pater_Noster.ogg\n- https://commons.wikimedia.org/wiki/File:JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg\n- https://commons.wikimedia.org/wiki/File:Byrd_4-Part_Mass_-_Credo.ogg\n- https://commons.wikimedia.org/wiki/File:Petits_Chanteurs_de_Passy_-_Salve_Regina_de_Hermann_Contract.ogg\n- https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Antiphona_et_Magnificat.ogg\n- https://commons.wikimedia.org/wiki/File:The_Tudor_Consort_-_J_S_Bach_-_Magnificat_BWV_243_-_Gloria_Patri.ogg"

    whiptail \
        --title "About" \
        --msgbox "$aboutText" 0 0

    echo $BACKGROUNDCOLOR
    clear
}

function splashScreen {
    my_titlebar "bash-rosary"

    echo "$CLR_ALL"
    width=$( tput cols )
    height=$( tput lines )
    str="Terminal Rosary using Jq and Bash"
    length=${#str}
    centerText=$(( ( width / 2 )-( length / 2 ) ))
    tput cup $((height/2 )) $centerText
    echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
    str="< Lt navigate Rt > ( Up menus Dn )"
    length=${#str}
    centerText=$(( ( width / 2 )-( length / 2 ) ))
    tput cup $height $centerText
    echo $str

    ## prompt for enter
    read -p "[Press Enter]" -s welcomeVar
}

function mystery_Day {
    dayOfWeek=$(date +"%A" )
    case "$dayOfWeek" in
        "Sunday" )
            dayMysteryIndex=4
            mysteryJumpPosition=244
            ;;
        "Monday" )
            dayMysteryIndex=1
            mysteryJumpPosition=7
            ;;
        "Tuesday" )
            dayMysteryIndex=3
            mysteryJumpPosition=165
            ;;
        "Wednesday" )
            dayMysteryIndex=4
            mysteryJumpPosition=244
            ;;
        "Thursday" )
            dayMysteryIndex=2
            mysteryJumpPosition=86
            ;;
        "Friday" )
            dayMysteryIndex=3
            mysteryJumpPosition=165
            ;;
        "Saturday" )
            dayMysteryIndex=1
            mysteryJumpPosition=7
            ;;
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

    my_titlebar "bash-rosary (preface)"

    resizeWindow
    clear

    str="Terminal Rosary using Jq and Bash"
    width=$( tput cols )
    length=${#str}
    centerText=$((( width/ 2 )-( length / 2 )))
    tput cup 0 $centerText
    echo $str

    printf '%*s\n' "${COLUMNS:-$( tput cols )}" ' ' | tr ' ' "."

    query_mysteryName=.mystery[$dayMysteryIndex].mysteryName
    return_mysteryName=$(jq $query_mysteryName $rosaryJSON)

    echo "
    Liturgical Year:            $cycleLetter

    Today is:               $dayOfWeek

    The default \"Mystery of the day\" is:  $return_mysteryName

    Liturgical Calendar:"

    if [ $isTodayEaster -eq 1 ]; then
        echo "                      Easter Day"
    fi

    if [ $isEasterSeason -eq 1 ]; then
        echo "                      This is the Easter Season, $abcEaster"
    fi

    if [ $isTodayAsh_Wednesday -eq 1 ]; then
        echo "                      Today is Ash Wednesday"
    fi

    if [ $isLentSeasion -eq 1 ]; then
        echo "                      This is the Lent Season, $abcLent"
    fi

    if [ $isTodayHoly_Thursday -eq 1 ]; then
        echo "                      This is Holy Thursday:"
        echo "                          Commemoration of the Last Supper of Jesus Christ"
    fi

    if [ $isTodayGood_Friday -eq 1 ]; then
        echo "                      This is the Good Friday:"
        echo "                          Commemoration of the crucifixion of Jesus"

    fi

    if [ $isTodayHoly_Saturday -eq 1 ]; then
        echo "                      This is the Holy Saturday:"
        echo "                          Commemoration of the day that Jesus' body lay in the tomb"

    fi

    if [ $isTodayJesus_Assension -eq 1 ]; then
        echo "                      Today is the Feast of Jesus's Assension"
    fi

    if [ $isTodayPentecost -eq 1 ]; then
        echo "                      Tday is Pentecost:"
        echo "                          Day on which the Spirit descended upon the apostles."
        echo "                          Jewish  \"Feast of harvest\"."
    fi

    if [ $isTodayImmaculateConception -eq 1 ]; then
        echo "                      Today is the feast of the Immaculate Conception:"
        echo "      (Catholic Catechism 490) To become the mother of the Savior, Mary \"was enriched by God with gifts appropriate to such a role.\" The angel Gabriel at the moment of the annunciation salutes her as \"full of grace\". In fact, in order for Mary to be able to give the free assent of her faith to the announcement of her vocation, it was necessary that she be wholly borne by God's grace. - Catechism of the Catholic Church"

    fi

    if [ $isTodayAdventStart -eq 1 ]; then
        echo "                      Advent Starts Today"
    fi

    if [ $isAdventSeasion -eq 1 ]; then
        echo "                      This is the Advent Season, $abcAdvent"
    fi

    if [ $isTodayChristmas -eq 1 ]; then
        echo "                      Today is Christmas"
    fi

    if [ $isChristmasSeason -eq 1 ]; then
        echo "                      Today is the Christmas Season, $abcChristmas"
    fi

    if [ $isTodaySolemnityOfMary -eq 1 ]; then
        echo "                      Today is the Feast of the Solemnity of Mary:"
        echo "                          The honoring of Mary as the Mother of God"
    fi

    if [ $isTodayEpiphany -eq 1 ]; then
        echo "                      Today is the Feast of the Epiphany:"
        echo "                          Day that celebrates the revelation of God incarnate as Jesus Christ."
    fi

    if [ $isTodayAll_Saints -eq 1 ]; then
        echo "                      Today is All Saints Day"
    fi

    if [ $isOrdinaryTime -eq 1 ]; then
        echo "                      This is the Ordinary Time Season"
    fi

    echo "

    ${MODE_BEGIN_UNDERLINE}Basic UI Controlls:${MODE_EXIT_UNDERLINE}

        Right or Left Keys | Navigate forward or backwards.
        Down Key           | Open Language Translation Menu ( English NAB or Latin Vulgate )
        Up Key             | Open the Main Menu

        'q' or Esc Key     | terminate app ( or Ctrl + C )
        'm' Key            | toggles Latin prayer audio (plays prayer only once)

        Vim navigation keybindings will also work. ( h, j, k, l )


    ${MODE_BEGIN_UNDERLINE}Advice:${MODE_EXIT_UNDERLINE}

        Pause after navigating to allow a moment for text querying and display rendering to complete.
        Optimal Xterm Screen Dimensions: (Minimum) 140 cols x 40 lines
    "

    height=$( tput lines )
    if [ $height -ge 34 ]; then
        tput cup $[$( tput lines )-2]
    fi
    read -p "[Press Enter]" -s enterVar
}

function forceCrossBead {
    beadCounter=$(( $mysteryJumpPosition - 7 ))
    query_mysteryName=.mystery[$dayMysteryIndex].mysteryName
    prayerIndex=1
    query_prayerText=.prayer[$prayerIndex].prayerText
    return_prayerText=$(jq $query_prayerText $rosaryJSON)
    echo "${FG_NoColor}${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}"

    if pgrep -x "ogg123" &>/dev/null
    then
        killall ogg123 &>/dev/null
    fi
    clear
}

function howToPage {
    my_titlebar "bash-rosary (guidance)"

    kilall ogg123
    resizeWindow
    echo "${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}"
    clear

    str="Terminal Rosary using Jq and Bash"
    width=$( tput cols )
    length=${#str}
    centerText=$((( width / 2 )-( length / 2 )))
    tput cup 0 $centerText
    echo $str

    printf '%*s\n' "${COLUMNS:-$( tput cols )}" ' ' | tr ' ' "."

    instructionList="

    How to pray The Rosary:

    1.  Make the Sign of the Cross and say the Apostles Creed.
    2.  Say the Our Father.
    3.  Say three Hail Marys.
    4.  Say the Glory be to the Father.
    5.  Announce the first mystery; then say the Our Father.
    6.  Say ten Hail Marys, while meditating on the mystery.
    7.  Say the Glory be to the Father and the Fatima Prayer.
    8.  Announce the second mystery; then say the Our Father.
    9.  Repeat 6 and 7, and continue with third, fourth, and fifth mysteries in the same manner.
    10. Say the Hail Holy Queen.
    11. Say the Prayer After the Rosary.


    Reality Check (Usability):

    * This App is/was just a (personal) technical exercise.
    * This App is a linguistic and scriptural \"reference\".
    * Use a blessed rosary. Some blessed rosaries may be associated with additional benefits.
    * Take a moment at the beginning of each decade to reflect on the mystery it represents"

    echo "${instructionList}${FG_NoColor}${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}"

    height=$( tput lines )
    if [ $height -ge 34 ]; then
        tput cup $[$( tput lines )-7]
    fi
    echo "
    ${MODE_BEGIN_UNDERLINE}Select a Use Case Mode${MODE_EXIT_UNDERLINE}

    * Normal Mode                :: Press [ Enter or Right Arrow ]
    + Chant Audio Autopilot Mode :: Press [ a or A ]
    - Exit/Quit at any time      :: Press [ q, Q, or Esc ]"
    stty -echo

    while read -sN1 key
    do
        read -s -n1 -t 0.0001 k1 &>/dev/null
        read -s -n1 -t 0.0001 k2 &>/dev/null
        read -s -n1 -t 0.0001 k3 &>/dev/null

        key+=${k1}${k2}${k3} &>/dev/null

        case "$key" in
            "a" | "A" | "+"  ) ## Auto Pilot, Latin prayers
                rosaryJSON=`echo $hostedDirPath/json-db/rosaryJSON-vulgate.json`
                translationName="Vulgate (Latin)"
                autoPilot=1
                # inputTag='-a'
                #grep -v "autoPilot" source/main-script/temp/localFlags > temp && mv temp source/main-script/temp/localFlags
                #echo "autoPilot 1 $(date)" >> source/main-script/temp/localFlags
                setAutoPilotFlag
                forceCrossBead
                return
                ;;

            "q" | "Q" | "-" | $escKey )
                goodbyescreen
                exit
                ;;

            $arrowRt | $returnKey | * )
                ## Start the bead sequence
                if [ $autoPilot -ne 1 ]; then
                    autoPilot=0
                fi

                forceCrossBead
                return
                ;;

        esac
    done

}

function goodbyescreen {
    resizeWindow
    # echo "$CLR_ALL"
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

    read -t 3 -p "" exitVar
    echo "$CLR_ALL"
    reset
}

#
## Bead Display
#

function blank_transition_display {
    echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
    updateScreenSize
    transitionalTputStingVars
}

function tputBeadDisplay {
    echo ${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}
    updateScreenSize
    tputStingVars
}

#
## Progressbars
#

function progressbars {
    height=$( tput lines )
    width=$( tput cols )

    if [ $height -ge 34 ]; then

        tputAppPrayer=$( tput cup $[$( tput lines )-9] 0; printf "%${width}s" ""; tput cup 24 8; echo $return_prayerText)

        str=" PROGRESS BARS "
        progressBarDivider=$( tput cup $[$( tput lines )-9] 0; printf "%${width}s" ""; tput cup $[$( tput lines )-9] 0; printf '%*s\n' "${COLUMNS:-$( tput cols )}" ' ' | tr ' ' "." )
        length=${#str}
        centerText=$((( width/ 2 )-( length / 2 )))
        progressBarTitle=$( tput cup $[$( tput lines )-8] 0; printf "%${width}s" ""; tput cup $[$( tput lines )-8] $centerText; echo $BAR_BG$BAR_FG$str$BACKGROUNDCOLOR$FOREGROUNDCOLOR)

        ## Decade Bar

        if [ $thisDecadeSet -lt 10 ]; then
            decDisp=" $thisDecadeSet/10"
        else
            decDisp="$thisDecadeSet/10"
        fi

        ## Decade intro exception
        if [ $mysteryProgress -eq 0 ]; then
            if [ $initialHailMaryCounter -gt 0 ] && [ $initialHailMaryCounter -lt 4 ] ; then
                decDisp=" $initialHailMaryCounter/3 "
            else
                decDisp="intro"

                if [ $iconSequence -eq 2 ]; then
                    decDisp=" $thisDecadeSet/10"
                fi
            fi
        fi

        # iconSequence=2

        stringLength=${#return_prayerName}
        stringLength=$(( $stringLength + 1 ))
        tputDecadeBarLabel=$( tput cup $[$( tput lines )-7] 0; printf "%${width}s" ""; tput cup $[$( tput lines )-7] 0; echo " Decade:  $decDisp     $return_beadType" )$( tput cup $[$( tput lines )-7]  $[$( tput cols )-$stringLength]; echo $return_prayerName)
        proportion=$thisDecadeSet/10
        barWidth=$(( width*$proportion))
        barWidth=$((barWidth - 2 ))
        # barDecade=$(printf '%*s\n' "${COLUMNS:-$barWidth}" ' ' | tr ' ' '|')
        barDecade=$(printf '%*s\n' "$barWidth" ' ' | tr ' ' '|')
        tputDecadeBar=$( tput cup $[$( tput lines )-6] 0; printf "%${width}s" ""; tput cup $[$( tput lines )-6] 1; echo $BAR_BG$BAR_FG$barDecade$BACKGROUNDCOLOR$FOREGROUNDCOLOR)

        ## Mystery Bar

        if [ $mysteryProgress -lt 10 ]; then
            mystDisp=" $mysteryProgress/50"
        else
            mystDisp="$mysteryProgress/50"
        fi

        stringLength=${#return_decadeName}
        stringLength=$(( $stringLength + 1 ))
        tputMysteryBarLabel=$( tput cup $[$( tput lines )-4] 0; printf "%${width}s" ""; tput cup $[$( tput lines )-4] 0; echo " Mystery: $mystDisp   $return_mysteryName" )$( tput cup $[$( tput lines )-4] $[$( tput cols )-$stringLength]; echo $return_decadeName)
        proportion=$mysteryProgress/50
        barWidth=$(( width*$proportion))
        barWidth=$((barWidth - 2 ))
        # barMystery=$(printf '%*s\n' "${COLUMNS:-$barWidth}" ' ' | tr ' ' '/')
        barMystery=$(printf '%*s\n' "$barWidth" ' ' | tr ' ' '|')
        tputMysteryBar=$( tput cup $[$( tput lines )-2] 0; printf "%${width}s" ""; tput cup $[$( tput lines )-1] 0; printf "%${width}s" ""; tput cup $[$( tput lines )-3] 0; printf "%${width}s" ""; tput cup $[$( tput lines )-3] 1; echo $BAR_BG$BAR_FG$barMystery$BACKGROUNDCOLOR$FOREGROUNDCOLOR)

        ## Rendering
        echo "${STYLES_OFF}${BACKGROUNDCOLOR}${FOREGROUNDCOLOR}${progressBarDivider}${progressBarTitle}${tputDecadeBarLabel}${tputDecadeBar}${tputMysteryBarLabel}${tputMysteryBar}"
    fi

}

function beadProgress {
    case $beadID in

        2 )  ## small beads
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
                        initialHailMaryCounter=3
                    else
                        initialHailMaryCounter=$(($initialHailMaryCounter - 1))
                    fi
                fi
            fi

            stringSpaceCounter=0

            ;;

        3)  ## big bead
            stringSpaceCounter=0
            initialHailMaryCounter=0
            thisDecadeSet=0

            ## used to flag intro or outro icon loop
            ## fwd dir from cross
            # iconSequence=1
            if [ $iconSequence -eq 0 ]; then
                iconSequence=1
            fi

            ## reverse
            if [ $directionFwRw -ne 1 ]; then
                moddivision=$(( hailmaryCounter % 10 ))
                if [ $moddivision -gt 0 ]; then
                    hailmaryCounter=$(( $hailmaryCounter - 1 ))
                fi
            fi

            ;;

        4) ## string space
            thisDecadeSet=10

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
                    mysteryProgress=$(( mysteryProgress - 1 ))
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

        5)  ## Mary Icon
            if [ $iconSequence -ne 0 ]; then
                stringSpaceCounter=0
                iconSequence=2
            else
                initialHailMaryCounter=3
                hailmaryCounter=50
                stringSpaceCounter=3
                mysteryProgress=50
                thisDecadeSet=10
                iconSequence=1
            fi

            ;;
        6)  ## cross
            initialHailMaryCounter=0
            hailmaryCounter=0
            stringSpaceCounter=0
            mysteryProgress=0
            thisDecadeSet=0
            iconSequence=0

            ;;
        * )
            iconSequence=0
            ;;
      esac
}

function bundledDisplay {
    resizeWindow
    tputBeadDisplay
    beadProgress
    progressbars
}
