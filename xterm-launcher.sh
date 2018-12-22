#!/bin/sh

function splashScreen() {
	echo "$CLR_ALL"
	clear
	width=$(tput cols)
	height=$(tput lines)
	str="Terminal Rosary using Jq and Bash"
	length=${#str}
	tput cup $((height/2)) $(((width/ 2)-(length/2)))
	echo $MODE_BEGIN_UNDERLINE$str$MODE_EXIT_UNDERLINE
	str="( A new 140x40 Xterm window will popup )"
	length=${#str}
	tput cup $height $(((width/ 2)-(length/2)))
	echo $str

	read -s -t 1 -p "Audio will autoplay in a looped sequence untill 'M' key is pressed." exitVar &>/dev/null
}

function launch_new_window() {
	hostedDirPath=$(dirname $0)

	## most linux systems have xterm
	# XTerm*geometry: 140x40
	xterm -geometry 140x40+0+0 $hostedDirPath/bash-rosary.sh

	## presume tty login terminal if error
	if [ $? -eq 1 ];then
		sh $hostedDirPath/bash-rosary.sh
	fi

}

function startMidiDemo() {
	hostedDirPath=$(dirname $0)
	## audio requires fluidsynth and a midi soundfont
	fluidsynth -a alsa -m alsa_seq -l -i -R 1 -C 1 /usr/share/soundfonts/FluidR3_GM.sf2 $hostedDirPath/audio/*.mid &>/dev/null &
}

function startMPlayerDemo() {
	hostedDirPath=$(dirname $0)
	mplayer -loop 0 $hostedDirPath/audio/*.ogg </dev/null >/dev/null 2>&1 &
}

startMPlayerDemo
splashScreen
launch_new_window
