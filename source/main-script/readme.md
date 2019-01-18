# source scripts

This app was once a single and long ```bash``` text file. I have since broke it down into modular sections.

The source ```.txt``` script is intended to be read as a ```source``` to be called by a bash script acting as a bash file executable.

### Load Sequence

A load sequence is not necessary, but if one were necessary, the following would apply.

| ```.``` source | description |
| --- | --- |
|```ui-appearance.txt```  | # audio visual settings |
|```jq-parsing.txt``` | # calling jq to query a json db |
|```paschal-full-moon.txt``` | # PFM Liturgical Calendar calculations |
|```tput-formatting.txt``` | # text display layout rendering |
|```webscrape.txt``` | # web scraping and formatting scraped data |
|```menu-dialog.txt``` | # menu options using dialog/whiptail |
|```ui-keybinding.txt``` | # user keyboard interface/input instructions |

then

* ```initialize-sources.txt``` # Script which loads all the scripts into the Bash Process instance

### Run

The bash file, ```bash-rosary```, in the app's root dir, is the primary bash ```./``` executable.

The bash file, ```xterm-launcher```, if called, will launch ```bash-rosary```
