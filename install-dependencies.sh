#!/bin/sh

## Install dependancies if needed

function arch_linux() {
	## xorg shell emulator
	sudo pacman -S --needed xterm
	
	## bash gui menu
	sudo pacman -S --needed dialog
	
	## json parser
	sudo pacman -S --needed jq

	## midi player with soundfont
	sudo pacman -S --needed fluidsynth
	sudo pacman -S --needed soundfont-fluid

	## multimedia player for video and audio
	sudo pacman -S --needed mplayer
	
	## c ompiler
	sudo pacman -S --needed gcc
}

function debian_linux() {
	## xorg shell emulator
	sudo apt-get install xterm
	## bash gui menu
	sudo apt-get install dialog
	## json parser
	sudo apt-get install jq

	## c ompiler
	sudo apt-get install gcc
}

# debian_linux
arch_linux
