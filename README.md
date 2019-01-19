# jq-tput-terminal

A Scripture Rosary GUI on the Bash CLI.

- Liturgical Calendar (Paschal Full Moon) with Seasonal and Feast Day triggered events.
- Vulgate Latin and NAB English Biblical translation database
- Daily Mass Readings (scraped from usccb.org)
- Prayer Chant Soundtrack ( Ogg Audio provided by [wikimedia.org](https://commons.wikimedia.org) / [archive.org](archive.org) )

---

### About:

This is a CLI GUI App. This App uses a slimmed down .json db which was ported from [electron-container](https://github.com/mezcel/electron-container).

__Recommended Use Cases:__

- "Busy Persons Retreat"
- Run locally in a background terminal session for audio room ambiance. Interactive Jukebox
- Host on a ssh/ssl network.
    - Recommendation 1: ssh -p 22 host-user@ip.addr
    - Recommendation 2: [shellinabox](https://code.google.com/archive/p/shellinabox/) service to any Firefox, Safari, Chrome, Edge, ect. client.
- For use as an educational quick reference (Catechism, linguistic, terminal cli, cultural history)

#### Feature Functionalities:

* Paschal Full Moon Liturgical Calendar calculations. (and Liturgical Cycles)
* Decorative color themes corresponding to Liturgical Calendar Seasons.
* Feast day triggered events.
* Play Traditional Latin Hymns (audio).
* Automatically install software dependencies.
* Retrieve daily Mass readings from the web.

#### Requirement Dependencies:

As of ```v0.1.8``` the audio and software used in this App are GNU

* Basic GNU Terminal Tools: [Bash](https://www.gnu.org/software/bash/), [ncurses/tput](https://ss64.com/bash/tput.html), wget, cal, bc, awk, & grep
* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [dialog / whiptail](http://linuxcommand.org/lc3_adv_dialog.php) is a terminal App for making dialog box style input prompts
* [ogg123](https://xiph.org/vorbis) is a [ogg](https://xiph.org/vorbis) audio player which can run within terminal environment
* [elinks](http://elinks.or.cz/) is a well-established feature-rich text mode web (HTTP/FTP/..) browser.
* Cultural and scholarly perspective on the Catholic Marian ministry (debug, troubleshoot, security, validation)

---

### Development Status and Milestones:

* ```v0.1.4``` Meaningful stop point with working functionalities. Demo Preview: [asciinema](https://asciinema.org/a/217793)

* ```v0.1.6.2``` added a music Autopilot to serve as spiritual room ambiance. It runs proximately +1.75 hours per 1 full mystery.

* ```v0.1.10.1``` release
    * Did a lot of refactoring since from v0.1.6.2
    * Right now the focus is going back and discovering bugs/inconsistencies when ran on the default configurations of of other Linux distros. ATM Debian performs the best despite being developed on an Arch.
    
* ```v0.1.10.2``` dev branch
    * Trying to make jq perform a bit better
    * The usual look and feel tweaks


| Test Distro's | Development Environment Notes |
| --- | --- |
| [Arch](https://wiki.archlinux.org/) | This App was developed on Arch Linux. [Parabola](https://wiki.parabola.nu/Category:Migration) is a 'free' Arch alternative. I also tested it with [shellinabox](https://aur.archlinux.org/packages/shellinabox-git/) hosting.|
| Slackware | Tested on Salix ( legacy repo linux platform compatible ) |
| [Alpine](https://alpinelinux.org/about/) | OpenRC, Docker, BusyBox. Fastest install and setup process |
| Ubuntu | [Trisquel](https://trisquel.info), Tahrpup, and Mint. Average performance. |
| Debian | Jq/gcc performed the best on Debian resulting in fast query processing |
| [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) | All the GNU works, but other than testing, I did dot build it for WLS |

---

### Run

This App will perform a requirements check and install Audio & Software, as needed, on startup. When possible, it will render in Xterm at 140x40. Your [alsa](http://alsa-project.org/main/index.php/Main_Page) or [pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) must already be configured on your system for audio to work.

(Main) CLI App: ```./bash-rosary```

- App Launcher for Desktop Environment: ```./xterm-launcher``` (it will call ```./bash-rosary```)

- Automatically verify and add needed software that is missing on your system. ```./source/gnu/download-gnu-software``` (Called automatically from within App or you can run it manually)
