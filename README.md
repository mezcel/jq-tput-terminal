# jq-tput-terminal

Terminal Rosary using Jq and Bash

v0.1.4 Demo Preview: [asciinema](https://asciinema.org/a/217793) and [Youtube](https://youtu.be/PceKrX4uI-I)

## Status:

```v0.1.6``` is now cross distro compatable

Tested on:

* [Arch](https://wiki.archlinux.org/) & [Parabola](https://wiki.parabola.nu/Category:Migration)
* Slackware Salix 
* [Alpine](https://alpinelinux.org/about/)
* Ubuntu [Trisquel](https://trisquel.info) (***Jq is fast on Ubuntu distros, tested on Tahrpup and Mint***)

### About:

This is a CLI GUI App. This app's json db is imported from [electron-container](https://github.com/mezcel/electron-container).

* [Bash](https://www.gnu.org/software/bash/), [ncurses/tput](https://ss64.com/bash/tput.html), wget, bc, awk & grep
* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [dialog / whiptail](http://linuxcommand.org/lc3_adv_dialog.php) is a terminal app for making dialog box style input prompts
* [mplayer](http://www.mplayerhq.hu/design7/info.html) a multimedia player which can run in terminal environment

### Feature:

* Paschal Full Moon Liturgical Calendar Calculations
* Color Themes
* Calendar triggered event features
* Traditional Latin Hymns (audio)
* Dependency installers

---

### Run

This app will perform a requirements check and install Audio & Software, as needed, on startup.

(Main) Terminal App: ```./bash-rosary.sh```

- Desktop Terminal Emulator App: ```./xterm-launcher.sh```
