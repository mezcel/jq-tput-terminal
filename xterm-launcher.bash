#!/bin/bash

function splashScreen {
	echo "$CLR_ALL"
	clear
	width=$(tput cols)
	height=$(tput lines)
	str="Terminal Rosary using Jq and Bash"
	length=${#str}
	centerText=$(( (width / 2)-(length / 2) ))
	tput cup $((height/2)) $centerText
	echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
	str="( A new 140x40 Xterm window will popup )"
	length=${#str}
	centerText=$(( (width / 2)-(length / 2) ))
	tput cup $height $centerText
	echo $str

	read -s -t 1 -p "Audio will autoplay in a looped sequence untill 'M' key is pressed." exitVar &>/dev/null
}

function launch_new_windowBackup {
	## presume tty login terminal if error
	#if [ $? -eq 1 ];then
	#	hostedDirPath=$(dirname $0)
	#	bash $hostedDirPath/bash-rosary.bash
	#else
	#	## most linux systems have xterm
	#	# XTerm*geometry: 140x40
	#	hostedDirPath=$(dirname $0)
	#	xterm -geometry 140x40+0+0 -e "$hostedDirPath/bash-rosary.bash"
	#fi

	processPidName=$(echo $TERM)

	if [ $processPidName != "linux" ]; then
		## most linux systems have xterm
		# XTerm*geometry: 140x40
		hostedDirPath=$(dirname $0)
		xterm -geometry 140x40+0+0 -e "$hostedDirPath/bash-rosary.bash"
	else
		hostedDirPath=$(dirname $0)
		bash $hostedDirPath/bash-rosary.bash
	fi

}

function launch_new_window {
	hostedDirPath=$(dirname $0)
	processPidName=$(echo $TERM)

	case $processPidName in
		"linux" )	## login terminal
					isLinuxTerminal=1
					bash "$hostedDirPath/bash-rosary.bash"
					;;
		* ) ## launch app through a new xterm
			## most linux systems have xterm
			# XTerm*geometry: 140x40
			xterm -geometry 140x40+0+0 -e "$hostedDirPath/bash-rosary.bash"
			;;
	esac

}

function startMidiDemo {
	hostedDirPath=$(dirname $0)
	## audio requires fluidsynth and a midi soundfont
	fluidsynth -a alsa -m alsa_seq -l -i -R 1 -C 1 /usr/share/soundfonts/FluidR3_GM.sf2 $hostedDirPath/audio/*.mid &>/dev/null &
}

function startMPlayerDemo {
	hostedDirPath=$(dirname $0)

	## Set initial pulseaudio system volume
	amixer set Master 25% </dev/null >/dev/null 2>&1

	# mplayer $hostedDirPath/audio/chime.ogg </dev/null >/dev/null 2>&1 &ep 5 ; echo quit >/tmp/mi1 ;echo quit >/tmp/mi2)&
	ogg123 $hostedDirPath/audio/chime.ogg </dev/null >/dev/null 2>&1 &
}

function download_dependencies {
	echo "checking github for latest update ..."
	git pull 2>&1

	currentDirPath=$(dirname $0)
	bash "$currentDirPath/download-dependencies.bash"
}

download_dependencies
startMPlayerDemo
splashScreen
launch_new_window
