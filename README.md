# jq-tput-terminal

Scripture Rosary GUI on the Bash CLI. Built in Liturgical Calendar with Seasonal and Feast Day triggered events.

Religious audio jukebox with [GNU](https://www.gnu.org/home.en.html) & [Public Domain](https://en.wikipedia.org/wiki/Public_domain#Definition) Ogg Audio provided by ( [wikimedia.org](https://commons.wikimedia.org) / [archive.org](archive.org) ).

### Development Status and Milestones:

* ```v0.1.4``` Meaningful stop point with working functionalities. Demo Preview: [asciinema](https://asciinema.org/a/217793)

* ```v0.1.6.2``` added a music Autopilot to serve as spiritual room ambiance. It runs proximately +1.75 hours per 1 full mystery.

* ```v0.1.8``` current dev branch release. Added Daily Mass Reading from the internet feature.

| Test Distro's | Development Environment Notes |
| --- | --- |
| [Arch](https://wiki.archlinux.org/) | This App was developed on Arch Linux. [Parabola](https://wiki.parabola.nu/Category:Migration) is a 'free' Arch alternative. |
| Slackware | Tested on Salix ( legacy repo linux platform compatible ) |
| [Alpine](https://alpinelinux.org/about/) | OpenRC, Docker, BusyBox. Fastest install and setup process |
| Ubuntu | [Trisquel](https://trisquel.info), Tahrpup, and Mint. Average performance. |
| Debian | Jq/gcc performed the best on Debian resulting in fast query processing |
| [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) | All the GNU works, but I did not build it for that target environment |

### About:

This is a CLI GUI App. This App's .json db is imported from [electron-container](https://github.com/mezcel/electron-container).

### Requirement Dependencies:

As of ```v0.1.6.1``` the audio and software used in this App are GNU

* Basic GNU: [Bash](https://www.gnu.org/software/bash/), [ncurses/tput](https://ss64.com/bash/tput.html), wget, cal, bc, awk, & grep
* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [dialog / whiptail](http://linuxcommand.org/lc3_adv_dialog.php) is a terminal App for making dialog box style input prompts
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

This App will perform a requirements check and install Audio & Software, as needed, on startup. It will not configure [pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/), my App assumes your machine either has compatible hardware configs or it doesn't.

(Main) Terminal App: ```./bash-rosary.sh```

- Desktop Terminal Emulator App: ```./xterm-launcher.sh``` (Optional but recommended, it will call ```./bash-rosary.sh```)

- Add needed software that is missing on your system: ```download-dependencies.bash``` (Called within App)
