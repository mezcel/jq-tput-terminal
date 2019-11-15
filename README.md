# jq-tput-terminal

An English & Latin Scripture Rosary on BASH.

## Description

This is a BASH application which launches multiple "FLOSS" command line interface applications which perform the following tasks: *downloading dependencies, web scraping, file parsing, audio streaming, and rendering text display*.

### Feature Functionalities:

* Visual:
    - Liturgical Calendar (Paschal Full Moon) with Seasonal and Feast Day triggered events.
    - Vulgate Latin and NAB English Biblical translation database
* Audio:
    - A curated prayer chant soundtrack ( Ogg Audio provided by: [wikimedia.org](https://commons.wikimedia.org) | [archive.org](archive.org) )
* Network:
    - Daily Mass readings ( web scraped from [usccb.org/bible/readings/](usccb.org/bible/readings/) )

| | Version |
| --- | --- |
| Current development branch | v0.1.11.2 |
| Demo Preview | v0.1.11 |
| [![asciicast](https://asciinema.org/a/243201.svg)](https://asciinema.org/a/243201) | v0.1.11 |

## Install

### Makefile

* **make** : download software and audio prerequisites
* **make gnu** : download software prerequisites
* **make ogg** : download audio prerequisites
* **make clean** : remove application audio, temp files, and log files

## Runtime

This App will perform a requirements check and install necessary software. Xterm's minimum window size will be set at 140x40. The [alsa](http://alsa-project.org/main/index.php/Main_Page) or [pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) must already be configured on your system for audio to work.

### Launch Script:

- (Main) CLI App: ```./bash-rosary```

- Automatically verify and add needed software that is missing on your system. ```./source/gnu/download-gnu-software``` (Called automatically from within App or you can run it manually)

# Development Considerations:

## Recommended Use Cases:

- ["Busy Persons Retreat"](https://vocationscava.org/wp-content/uploads/2014/11/ONLINE_BPR_EDITED_October_2013.pdf) and or [Leccio Divina](https://ocarm.org/en/content/lectio/what-lectio-divina)
- Run locally in a background terminal session for audio room ambiance. Interactive Jukebox
- Host on a ssh/ssl network.
- For use as an educational quick reference (Catechism, linguistic, terminal cli, cultural history)

## Requirement Dependencies:

* Basic GNU Terminal Tools: [Bash](https://www.gnu.org/software/bash/), [ncurses/tput](https://ss64.com/bash/tput.html), wget, cal, bc, awk, & grep
* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [dialog / whiptail](http://linuxcommand.org/lc3_adv_dialog.php) is a terminal App for making dialog box style input prompts
* [ogg123](https://xiph.org/vorbis) is a [ogg](https://xiph.org/vorbis) audio player which can run within terminal environment
* [elinks](http://elinks.or.cz/) is a well-established feature-rich text mode web (HTTP/FTP/..) browser.

This App was built around a slimmed down json database which was initially ported from [electron-container](https://github.com/mezcel/electron-container).

# Test Environments:

| Test Distro's | Development Environment Notes |
| --- | --- |
| [Arch](https://wiki.archlinux.org/) | This App was developed on Arch Linux. I also tested it with [shellinabox](https://aur.archlinux.org/packages/shellinabox-git/) cross platform hosting.|
| Slackware | Tested on Salix ( legacy repo linux platform compatible ) |
| [Alpine](https://alpinelinux.org/about/) | OpenRC, Docker, BusyBox. Fastest install and setup process |
| Ubuntu | [Trisquel](https://trisquel.info), Tahrpup, and Mint. Average performance. |
| Debian | Jq/gcc performed the best on Debian resulting in fast query processing |
| [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) | All the GNU works, but other than testing, I did dot build it for WLS |
