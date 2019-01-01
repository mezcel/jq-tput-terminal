# jq-tput-terminal

Scripture Rosary GUI on the Bash CLI.

### Dev Status:

* ```v0.1.4``` Demo Preview: [asciinema](https://asciinema.org/a/217793)

* ```v0.1.6.2``` added an option to automatically cycle though the Rosary while playing prayer music. The objective was to run this app a musical background room ambiance.

| Test Distro's | Development Environment Notes |
| --- | --- |
| [Arch](https://wiki.archlinux.org/) | This App was developed on Arch Linux. [Parabola](https://wiki.parabola.nu/Category:Migration) is a 'free' Arch alternative. |
| Slackware | Tested on Salix ( legacy linux platform ) |
| [Alpine](https://alpinelinux.org/about/) | OpenRC, Docker, BusyBox |
| Ubuntu | Jq/gcc running on [Trisquel](https://trisquel.info), Tahrpup, and Mint returned the fastest queries. |
| [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) | All the GNU works, but I did not build it for that target environment |

### About:

This is a CLI GUI App. This app's .json db is imported from [electron-container](https://github.com/mezcel/electron-container).

### Requirement Dependencies:

As of ```v0.1.6.1``` the audio and software used in this app are GNU

* [Bash](https://www.gnu.org/software/bash/), [ncurses/tput](https://ss64.com/bash/tput.html), wget, bc, awk & grep
* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [dialog / whiptail](http://linuxcommand.org/lc3_adv_dialog.php) is a terminal app for making dialog box style input prompts
* [mplayer](http://www.mplayerhq.hu/design7/info.html) a multimedia player which can run in terminal environment
* Cultural and scholarly perspective on the Catholic Marian ministry (debug, troubleshoot, security, validation)

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
