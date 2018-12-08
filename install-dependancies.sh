#!/bin/sh

## Install dependancies if needed

function arch_linux() {
	sudo pacman -S --needed xterm
	sudo pacman -S --needed dialog
	sudo pacman -S --needed jq

	## not sure if this is needed, it is just a C compiler
	sudo pacman -S --needed gcc
}

arch_linux
