# jq-tput-terminal

A Scripture Rosary GUI on the Bash CLI.

- Liturgical Calendar with Seasonal and Feast Day triggered events.
- Daily Mass Readings (scraped from usccb.org)
- Chant Soundtrack ( Ogg Audio provided by [wikimedia.org](https://commons.wikimedia.org) / [archive.org](archive.org) )

Recommended Use Cases:

- "Busy Persons Retreat"
- Run locally in a background terminal session for audio room ambiance or for use as an educational quick reference.
- Host on a ssh/ssl network. (compatible, but not included in app)
    - ssh -p 22 host-user@ip.addr
    - [shellinabox](https://code.google.com/archive/p/shellinabox/) service to any Firefox, Chrome, Edge, ect. client.

### Development Status and Milestones:

* ```v0.1.4``` Meaningful stop point with working functionalities. Demo Preview: [asciinema](https://asciinema.org/a/217793)

* ```v0.1.6.2``` added a music Autopilot to serve as spiritual room ambiance. It runs proximately +1.75 hours per 1 full mystery.

* ```v0.1.8.4``` current branch release.

* ```v0.1.9-deb``` current dev branch. (because Deb translates well with WLS)
    * WIP
    * Redoing the dir tree and trimming the bloat, but keeping the same algorithm.
    * Nothing works here yet
    * I am developing on debian since, I messed up my arch computers and don't want to mess with troubleshooting other problems at the moment.


| Test Distro's | Development Environment Notes |
| --- | --- |
| [Arch](https://wiki.archlinux.org/) | This App was developed on Arch Linux. [Parabola](https://wiki.parabola.nu/Category:Migration) is a 'free' Arch alternative. I also tested it with [shellinabox](https://aur.archlinux.org/packages/shellinabox-git/) hosting.|
| Slackware | Tested on Salix ( legacy repo linux platform compatible ) |
| [Alpine](https://alpinelinux.org/about/) | OpenRC, Docker, BusyBox. Fastest install and setup process |
| Ubuntu | [Trisquel](https://trisquel.info), Tahrpup, and Mint. Average performance. |
| Debian | Jq/gcc performed the best on Debian resulting in fast query processing |
| [WSL](https://docs.microsoft.com/en-us/windows/wsl/about) | All the GNU works, but other than testing, I did dot build it for WLS |

### About:

This is a CLI GUI App. This App uses a slimmed down .json db which was ported from [electron-container](https://github.com/mezcel/electron-container).

### Requirement Dependencies:

As of ```v0.1.8``` the audio and software used in this App are GNU

* Basic GNU Terminal Tools: [Bash](https://www.gnu.org/software/bash/), [ncurses/tput](https://ss64.com/bash/tput.html), wget, cal, bc, awk, & grep
* [JQ](https://stedolan.github.io/jq) is a cross-platform C program which parses json script via command line terminal
* [dialog / whiptail](http://linuxcommand.org/lc3_adv_dialog.php) is a terminal App for making dialog box style input prompts
* [ogg123](https://xiph.org/vorbis) is a [ogg](https://xiph.org/vorbis) audio player which can run within terminal environment
* [elinks](http://elinks.or.cz/) is a well-established feature-rich text mode web (HTTP/FTP/..) browser.
* Cultural and scholarly perspective on the Catholic Marian ministry (debug, troubleshoot, security, validation)

### Feature Functionalities:

* Paschal Full Moon Liturgical Calendar calculations. (and Liturgical Cycles)
* Decorative color themes corresponding to Liturgical Calendar Seasons.
* Feast day triggered events.
* Play Traditional Latin Hymns (audio).
* Automatically install software dependencies.
* Retrieve daily Mass readings from the web.

---

### Run

This App will perform a requirements check and install Audio & Software, as needed, on startup. When possible, it will render in Xterm at 140x40. Your [alsa](http://alsa-project.org/main/index.php/Main_Page) or [pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) must already be configured on your system for audio to work.

(Main) CLI App: ```./bash-rosary```

- App Launcher for Desktop Environment: ```./xterm-launcher``` (it will call ```./bash-rosary```)

- Add needed software that is missing on your system: ```./download-dependencies``` (Called automatically from within App or you can run it manually)
