# source scripts

This app was once a single ```bash``` text file. I have since broke it down into modular sections.

The source ```.txt``` script is intended to be read as a ```source``` to be called by a bash script acting as a bash file executable.

Basically... Im just injecting text, compartmentalized by function var names, to be ran within bash script.

### Load Sequence

A load sequence is not necessary, but if it were...

* ```ui-appearance.txt```
* ```jq-parsing.txt```
* ```paschal-full-moon.txt```
* ```tput-formatting.txt```
* ```webscrape.txt```
* ```menu-dialog.txt```
* ```ui-keybinding.txt```

### Script which loads all the scripts into the Bash Process instance

* ```initialize-sources.txt```

### Run

The bash file, ```bash-rosary```, in the app's root dir, is the primary bash executable.
