#!/bin/sh

## Install dependancies if needed

function arch_linux() {
	sudo pacman -S --needed xterm
	sudo pacman -S --needed dialog
	sudo pacman -S --needed jq

	## not sure if this is needed, it is just a C compiler
	sudo pacman -S --needed gcc
}

function debian_linux() {
	sudo apt-get install xterm
	sudo apt-get install dialog
	sudo apt-get install jq

	## not sure if this is needed, it is just a C compiler
	sudo apt-get install gcc
}

# debian_linux
arch_linux
