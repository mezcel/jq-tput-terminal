## Makefile (Automated Build)

all: gnu ogg manpage

gnu:
	## download gnu software dependency
	bash source/gnu/download-gnu-software
	#

ogg:
	## Download app audio
	bash source/ogg/download-ogg-media
	#

manpage:
	## Convert Rmarkdown to man using pandoc
	## global man page
	# pandoc .manpage.md -s -t man > /usr/bin/jq-tput-terminal
	## local man page
	pandoc .manpage.md -s -t man > jq-tput-terminal
	#

clean:
	## remove any ogg audio, logs, temporary flags, and webscrape files
	rm -rf source/ogg/*.ogg
	rm -f source/gnu/installationLog
	rm -f source/html/visitUsccbLog.txt
	rm -f source/main-script/temp/localFlags
	rm -f source/html/mass-readings.html
	rm -f jq-tput-terminal
	rm -f /usr/bin/jq-tput-terminal
	#
