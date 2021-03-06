#!/bin/bash
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

	beadIndex=$( jq $query_beadIndex $rosaryJSON )
	decadeIndex=$( jq $query_decadeIndex $rosaryJSON )
	mysteryIndex=$( jq $query_mysteryIndex $rosaryJSON )
	prayerIndex=$( jq $query_prayerIndex $rosaryJSON )
	scriptureIndex=$( jq $query_scriptureIndex $rosaryJSON )
	messageIndex=$( jq $query_messageIndex $rosaryJSON )

	query_beadID=.bead[$beadIndex].beadID
	query_beadType=.bead[$beadIndex].beadType
	query_decadeName=.decade[$decadeIndex].decadeName
	query_decadeInfo=.decade[$decadeIndex].decadeInfo
	query_mysteryName=.mystery[$mysteryIndex].mysteryName
	query_prayerName=.prayer[$prayerIndex].prayerName
	query_prayerText=.prayer[$prayerIndex].prayerText
	query_scriptureText=.scripture[$scriptureIndex].scriptureText
	query_mesageText=.message[$messageIndex].mesageText

	return_beadID=$( jq $query_beadID $rosaryJSON )
	return_beadType=$( jq $query_beadType $rosaryJSON )
	return_decadeName=$( jq $query_decadeName $rosaryJSON )
	return_decadeInfo=$( jq $query_decadeInfo $rosaryJSON )
	return_mysteryName=$( jq $query_mysteryName $rosaryJSON )
	return_prayerText=$( jq $query_prayerText $rosaryJSON )
	return_prayerName=$( jq $query_prayerName $rosaryJSON )
	return_scriptureText=$( jq $query_scriptureText $rosaryJSON )
	return_mesageText=$( jq $query_mesageText $rosaryJSON )

	beadID=$return_beadID
	beadType=$return_beadType
}

############

function jqQuery_all {
	## The longest rout for query, 1N DB Query

	# query_beadIndex=.rosaryBead[$rosaryBeadID].beadIndex
	query_decadeIndex=.rosaryBead[$rosaryBeadID].decadeIndex
	query_mysteryIndex=.rosaryBead[$rosaryBeadID].mysteryIndex
	query_prayerIndex=.rosaryBead[$rosaryBeadID].prayerIndex
	query_scriptureIndex=.rosaryBead[$rosaryBeadID].scriptureIndex
	query_messageIndex=.rosaryBead[$rosaryBeadID].messageIndex

	# beadIndex=$( jq $query_beadIndex $rosaryJSON )
	decadeIndex=$( jq $query_decadeIndex $rosaryJSON )
	mysteryIndex=$( jq $query_mysteryIndex $rosaryJSON )
	prayerIndex=$( jq $query_prayerIndex $rosaryJSON )
	scriptureIndex=$( jq $query_scriptureIndex $rosaryJSON )
	messageIndex=$( jq $query_messageIndex $rosaryJSON )

	# query_beadID=.bead[$beadIndex].beadID
	# query_beadType=.bead[$beadIndex].beadType
	query_decadeName=.decade[$decadeIndex].decadeName
	query_decadeInfo=.decade[$decadeIndex].decadeInfo
	query_mysteryName=.mystery[$mysteryIndex].mysteryName
	query_prayerName=.prayer[$prayerIndex].prayerName
	query_prayerText=.prayer[$prayerIndex].prayerText
	query_scriptureText=.scripture[$scriptureIndex].scriptureText
	query_mesageText=.message[$messageIndex].mesageText

	return_beadID=$( jq $query_beadID $rosaryJSON )
	return_beadType=$( jq $query_beadType $rosaryJSON )
	return_decadeName=$( jq $query_decadeName $rosaryJSON )
	return_decadeInfo=$( jq $query_decadeInfo $rosaryJSON )
	return_mysteryName=$( jq $query_mysteryName $rosaryJSON )
	return_prayerText=$( jq $query_prayerText $rosaryJSON )
	return_prayerName=$( jq $query_prayerName $rosaryJSON )
	return_scriptureText=$( jq $query_scriptureText $rosaryJSON )
	return_mesageText=$( jq $query_mesageText $rosaryJSON )

	# beadID=$return_beadID
	# beadType=$return_beadType
}

function jQuery_smallbeads {
	## The longest rout for query, 1N DB Query

	# query_beadIndex=.rosaryBead[$rosaryBeadID].beadIndex
	# query_decadeIndex=.rosaryBead[$rosaryBeadID].decadeIndex
	# query_mysteryIndex=.rosaryBead[$rosaryBeadID].mysteryIndex
	query_prayerIndex=.rosaryBead[$rosaryBeadID].prayerIndex
	query_scriptureIndex=.rosaryBead[$rosaryBeadID].scriptureIndex
	# query_messageIndex=.rosaryBead[$rosaryBeadID].messageIndex

	# beadIndex=$( jq $query_beadIndex $rosaryJSON )
	# decadeIndex=$( jq $query_decadeIndex $rosaryJSON )
	# mysteryIndex=$( jq $query_mysteryIndex $rosaryJSON )
	prayerIndex=$( jq $query_prayerIndex $rosaryJSON )
	scriptureIndex=$( jq $query_scriptureIndex $rosaryJSON )
	# messageIndex=$( jq $query_messageIndex $rosaryJSON )

	# query_beadID=.bead[$beadIndex].beadID
	# query_beadType=.bead[$beadIndex].beadType
	# query_decadeName=.decade[$decadeIndex].decadeName
	# query_decadeInfo=.decade[$decadeIndex].decadeInfo
	# query_mysteryName=.mystery[$mysteryIndex].mysteryName
	query_prayerName=.prayer[$prayerIndex].prayerName
	query_prayerText=.prayer[$prayerIndex].prayerText
	query_scriptureText=.scripture[$scriptureIndex].scriptureText
	# query_mesageText=.message[$messageIndex].mesageText

	# return_beadID=$( jq $query_beadID $rosaryJSON )
	# return_beadType=$( jq $query_beadType $rosaryJSON )
	# return_decadeName=$( jq $query_decadeName $rosaryJSON )
	# return_decadeInfo=$( jq $query_decadeInfo $rosaryJSON )
	# return_mysteryName=$( jq $query_mysteryName $rosaryJSON )
	return_prayerText=$( jq $query_prayerText $rosaryJSON )
	return_prayerName=$( jq $query_prayerName $rosaryJSON )
	return_scriptureText=$( jq $query_scriptureText $rosaryJSON )
	# return_mesageText=$( jq $query_mesageText $rosaryJSON )

	# beadID=$return_beadID
	# beadType=$return_beadType
	
}

function determine_what_to_query {
	query_beadIndex=.rosaryBead[$rosaryBeadID].beadIndex
	beadIndex=$( jq $query_beadIndex $rosaryJSON )
	
	query_beadID=.bead[$beadIndex].beadID
	query_beadType=.bead[$beadIndex].beadType
	
	return_beadID=$( jq $query_beadID $rosaryJSON )
	return_beadType=$( jq $query_beadType $rosaryJSON )
	
	beadID=$return_beadID
	beadType=$return_beadType
	
	if [ $mysteryProgress -ne 0 ]; then
	
		if [ $beadID -eq 2 ]; then
			jQuery_smallbeads
		else
			jqQuery_all
		fi
		
	else
		
		jqQuery_all
	
	fi
}

#
## Format text for terminal display
#

function formatJqText {
	## Undo formatting and modify Jq generated text

	## Remove Quotes from vars
	temp="${return_mysteryName%\"}"; temp="${temp#\"}"
	return_mysteryName=$temp
	temp="${return_mesageText%\"}"; temp="${temp#\"}"
	return_mesageText=$temp
	temp="${return_decadeName%\"}"; temp="${temp#\"}"
	return_decadeName=$temp
	temp="${return_decadeInfo%\"}"; temp="${temp#\"}"
	return_decadeInfo=$temp
	temp="${return_beadType%\"}"; temp="${temp#\"}"
	return_beadType=$temp

	## STANDOUT <p></p>
	htmlPstart="\<p\>"
	htmlPend="\<\/p\>"
	bashEcho="${MODE_ENTER_STANDOUT}"
	return_decadeInfo=${return_decadeInfo//$htmlPstart/$bashEcho}
	temp="${return_decadeInfo%\"}"; temp="${temp#\"}"
	return_decadeInfo=$temp
	bashEcho="${MODE_EXIT_STANDOUT}"
	return_decadeInfo=${return_decadeInfo//$htmlPend/$bashEcho}
	temp="${return_decadeInfo%\"}"; temp="${temp#\"}"
	return_decadeInfo=$temp

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
	first2letters=$( echo $return_prayerText | grep -Po "^.." )

	## Break up prayers into 2 segments for social readability
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
