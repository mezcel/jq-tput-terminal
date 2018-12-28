# jq-tput-terminal

Scripture Rosary GUI on the Bash CLI.

```v0.1.4``` Demo Preview: [asciinema](https://asciinema.org/a/217793) and [Youtube](https://youtu.be/PceKrX4uI-I)

### Dev Status:

```v0.1.6.1``` added notes on ABC Cycles Years

| Test Distro's | Development Environment Notes |
| --- | --- |
| [Arch](https://wiki.archlinux.org/) | This App was primarily developed for Arch Linux. [Parabola](https://wiki.parabola.nu/Category:Migration) is a free Arch option. |
| Slackware | Tested on Salix ( traditional linux ) |
| [Alpine](https://alpinelinux.org/about/) | OpenRC with BusyBox (the most light weight in cpu and installation) |
| Ubuntu | Jq running on [Trisquel](https://trisquel.info), Tahrpup, and Mint returned the fastest query response.  |

### About:

This is a CLI GUI App. This app's .json db is imported from [electron-container](https://github.com/mezcel/electron-container).

Dependency Requirements:

* [Bash](https://www.gnu.org/software/bash/), [ncurses/tput](https://ss64.com/bash/tput.html), wget, bc, awk & grep
* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [dialog / whiptail](http://linuxcommand.org/lc3_adv_dialog.php) is a terminal app for making dialog box style input prompts
* [mplayer](http://www.mplayerhq.hu/design7/info.html) a multimedia player which can run in terminal environment

### Feature Functionalities:

* Paschal Full Moon Liturgical Calendar calculations. (and Liturgical Cycles)
* Decorative color themes corresponding to Liturgical Calendar Seasons.
* Feast day triggered events.
* Traditional Latin Hymns (audio).
* Automatically install software dependencies.

---

### Run

This app will perform a requirements check and install Audio & Software, as needed, on startup.

(Main) Terminal App: ```./bash-rosary.sh```

- Desktop Terminal Emulator App: ```./xterm-launcher.sh```
