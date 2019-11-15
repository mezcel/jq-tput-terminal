## Makefile (Automated Build)

all: gnu

gnu: 
	## download gnu software dependency
	bash source/gnu/download-gnu-software
	#

clean:
	## removing any ogg and logs
	rm -rf source/ogg/*.ogg 
	rm -f source/gnu/installationLog
	rm -f source/gnu/installationLog
	#