## Makefile (Automated Build)

all: gnu ogg

gnu:
	## download gnu software dependency
	bash source/gnu/download-gnu-software
	#

ogg:
	## Download app audio
	bash source/ogg/download-ogg-media
	#

clean:
	## remove any ogg audio, logs, temporary flags, and webscrape files
	rm -rf source/ogg/*.ogg
	rm -f source/gnu/installationLog
	rm -f source/html/visitUsccbLog.txt
	rm -f source/main-script/temp/localFlags
	rm -f source/html/mass-readings.html
	#
