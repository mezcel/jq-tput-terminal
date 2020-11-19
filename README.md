# jq-tput-terminal

An English & Latin Scripture Rosary for BASH, using jq and vorbis-tools.

## Description

This is a BASH application which launches multiple "FLOSS" command line interface applications which perform the following tasks: *downloading dependencies, web scraping, file parsing, audio streaming, window scaling, and rendering text display*.

This application aims to serve as: a casual, meditative, intellectual, and auditory experience.

## Primary Features:

| Content | Functionality |
| :--- | :--- |
| Calendar Calculations | Liturgical Calendar (Paschal Full Moon) with Seasonal and Feast Day triggered events. |
| Liturgical Library | Vulgate Latin and NAB English Biblical translation database |
| Audio | A curated prayer chant soundtrack ( Ogg Audio provided by: [wikimedia.org](https://commons.wikimedia.org) & [archive.org](archive.org) ) |
| Network | Daily Mass readings ( web scraped from [usccb.org/bible/readings](usccb.org/bible/readings/) ) |

| Project Status | Development Version |
| :--- | :--- |
| Current development branch | v0.1.12 |
| Outdated Demo Preview ( rushed UI mechanics ) | v0.1.11 |
| [![asciicast](https://asciinema.org/a/243201.svg)](https://asciinema.org/a/243201) | v0.1.11 |

## Installation

### Install using a Makefile:

* **make** : download software and audio prerequisites
* **make gnu** : download software prerequisites
* **make ogg** : download audio prerequisites
* **make clean** : remove application audio, temp files, and log files

### Install using launch script:

- (Main) CLI App: ```./bash-rosary``` or ```exec bash-rosary```
    - Start the application in "audio autopilot Latin" mode: ```./bash-rosary -a``` or ```exec bash-rosary -A```
    - Start the application in "Latin" mode: ```./bash-rosary -l``` or ```exec bash-rosary -L```
- Automatically verify and add needed software that is missing on your system. ```./source/gnu/download-gnu-software``` (Called automatically from within App or you can run it manually)

### Run-time (builtin dependency installer):

* This application will perform a software update and a dependency requirements check upon startup and it will also automatically install any missing necessary software (internet is required). Xterm's minimum window size will be set at 140x40.
* There is a deliberate and pronounced screen flicker and delay between bead transitions.
* The [alsa](http://alsa-project.org/main/index.php/Main_Page) or [pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) must already be configured on your system for audio to work. (Audio may Require manual intervention.)
* In audio autopilot mode, the default language will be Latin in order to match the Latin audio prayer chants.

---

# Development Considerations

## Use Case

- ["Busy Persons Retreat"](https://vocationscava.org/wp-content/uploads/2014/11/ONLINE_BPR_EDITED_October_2013.pdf) and or [Leccio Divina](https://ocarm.org/en/content/lectio/what-lectio-divina)
- Run locally in a background terminal session for audio room ambiance. Interactive Jukebox
- Host on a ssh/ssl network.
- For use as an educational quick reference (Catechism, linguistic, terminal cli, cultural history)

## GNU Dependency

* Basic GNU Terminal Tools: [Bash](https://www.gnu.org/software/bash/), [ncurses, tput](https://ss64.com/bash/tput.html), wget, cal, bc, awk, & grep
* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [dialog / whiptail](http://linuxcommand.org/lc3_adv_dialog.php) is a terminal App for making dialog box style input prompts
* [ogg123](https://xiph.org/vorbis) is a [ogg](https://xiph.org/vorbis) audio player which can run within terminal environment
* [elinks](http://elinks.or.cz/) is a well-established feature-rich text mode web (HTTP/FTP/..) browser.

> This App was built around a slimmed down json database which was initially ported from [electron-container](https://github.com/mezcel/electron-container).

## Test cases & run-time environments:

| Test Distro's | Development Environment Notes | Relative Performance |
| :--- | :--- | :--- |
| [Arch](https://wiki.archlinux.org/) | This App was developed on Arch Linux. I also tested it with [shellinabox](https://aur.archlinux.org/packages/shellinabox-git/) cross platform hosting.| slowest |
| Slackware | Tested on Salix ( legacy repo linux platform compatible ) | average |
| [Alpine](https://alpinelinux.org/about/) | OpenRC, Docker, BusyBox. Fastest install and setup process | fast |
| Ubuntu | [Trisquel](https://trisquel.info), Tahrpup, and Mint. Average performance. | average |
| Debian | Jq/gcc performed the best on Debian resulting in fast query processing | best |
| [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) | All the GNU works, but other than testing, I did dot build it for WLS | slow |

> **Note:** GCCv6 performed a lot faster than newer GCC versions back when this app first started being developed.
