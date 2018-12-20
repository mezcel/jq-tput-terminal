# jq-tput-terminal

Terminal Rosary using Jq and Bash

Demo Preview:

* outdated video from an early stage stop point (recorded on ansiinema): [video link](https://asciinema.org/a/N8DVeuG2VmirEsymnMtbmqF3T)

## Status:

```v0.1.5``` is focused on playing with changing my tput technique and screen rendering

### About:

This is an app which runs within a CLI GUI. I prefer either the login terminal or a desktop Xterm bash emulator. This app's text content is provided by the same json db used in my [Electron Rosary App](https://github.com/mezcel/electron-container).

The algorithm is pretty much the same as the [Electron Rosary App](https://github.com/mezcel/electron-container). There are far less features in this version though.

The db query is slow because JQ is parsing a json file using the longest 1N rout. There are ways to optimize it, like not even doing queries on non changing values, or just 2N or 3N Indexing. But... I havent gone back and optimized.

* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [tput](https://ss64.com/bash/tput.html) is a tool for formatting text display in a command line terminal
* ```dialog / whiptail``` is a terminal app for making dialog box style input prompts
* Bash is a command line terminal shell interface commonly associated with Unix derived OS's


### Feature Highlight:

* Paschal Full Moon Liturgical Calendar Calculations
* Color Themes
* Calendar triggered Mysteries
* Midi music (Demo). I recommend a proper MPlayer .mp3 or .wav music file.

---

### Run

(Main) Terminal App: ```./bash-rosary.sh```

- Destop Terminal Emulator App: ```./xterm-launcher.sh```

- (Optional) Install Dependancies: ```./install-dependancies.sh```
