#!/bin/sh

hostedDirPath=$(dirname $0)

## most linux systems have xterm
# XTerm*geometry: 115x25
xterm -geometry 120x40+0+0 $hostedDirPath/bash-rosary.sh
