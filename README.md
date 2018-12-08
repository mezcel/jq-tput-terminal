# jq-tput-terminal

Termainal Rosary using Jq and Bash

### About:

This is an app which runs within a command line terminal GUI. Text content is provided by a json db which I ported in from my [Electron Rosary App](https://github.com/mezcel/electron-container), as text content.

It is pretty much the same app as the [Electron Rosary App](https://github.com/mezcel/electron-container); even the logic is the same. There are far less features in this version though. The "longest rout" query approach was intentional. I want to monitor and experience the difference in performance between this app and the jquery/electron version.

* [JQ](https://stedolan.github.com) is a cross-platform C program which parses json script via command line terminal
* [tput](https://ss64.com/bash/tput.html) is a tool for formatting text display in a command line terminal
* Bash is a comman line terminal shell interface commonly associated with Unix derived OS's

---

### Run

(Main) Terminal App: ```./bash-rosary.sh```

- Destop Terminal Emulator App: ```./desktop-terminal.sh```

- (Optional) Install Dependancies: ```./install-dependancies.sh```
