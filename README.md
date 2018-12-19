# jq-tput-terminal

Terminal Rosary using Jq and Bash

Demo Preview:

* outdated video from an early stage stop point

* (recorded on ansiinema): [video link](https://asciinema.org/a/N8DVeuG2VmirEsymnMtbmqF3T)

## Status:

```v0.1.5``` is focused on changing my tput technique and screen rendering

### About:

This is an app which runs within a CLI GUI. Text content is provided by a json db which I ported in from my [Electron Rosary App](https://github.com/mezcel/electron-container), as text content.

It is pretty much the same app as the [Electron Rosary App](https://github.com/mezcel/electron-container); even the logic is the same. There are far less features in this version though. The "longest rout" query approach was intentional. I want to monitor and experience the difference in performance between this app and the jquery/electron version.

* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [tput](https://ss64.com/bash/tput.html) is a tool for formatting text display in a command line terminal
* ```dialog / whiptail``` is a terminal app for making dialog box style input prompts
* Bash is a command line terminal shell interface commonly associated with Unix derived OS's

---

### Run

(Main) Terminal App: ```./bash-rosary.sh```

- Destop Terminal Emulator App: ```./desktop-terminal.sh```

- (Optional) Install Dependancies: ```./install-dependancies.sh```
