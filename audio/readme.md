# Audio

Enclosed are the open source Demo sounds used in this app.

In order to save space on Github and attribute source credits, audio is not included within this Git.

When the App starts, it will then check for installed audio files and then import as needed ```dl-app-audio.sh```

- I focused on Ogg for GNU sake, but .wav, .mp3, .midi is also compatable for this app.


## Source Audio:

[wikimedia.org](https://commons.wikimedia.org/wiki/Category:Ogg_files_of_Christian_music):

- [Schola_Gregoriana-Ave_Maria.ogg](https://en.wikipedia.org/wiki/File:Schola_Gregoriana-Ave_Maria.ogg)

- [Schola_Gregoriana-Pater_Noster.ogg](https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Pater_Noster.ogg)

- [JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg](https://commons.wikimedia.org/wiki/File:JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg)

- [Byrd_4-Part_Mass_-_Credo.ogg](https://commons.wikimedia.org/wiki/File:Byrd_4-Part_Mass_-_Credo.ogg)

---

play midi audio files
```sh
## midi player with soundfont
sudo pacman -S --needed fluidsynth
sudo pacman -S --needed soundfont-fluid
	
## audio requires fluidsynth and a midi soundfont
fluidsynth -a alsa -m alsa_seq -l -i -R 1 -C 1 /usr/share/soundfonts/FluidR3_GM.sf2 ./audio/*.mid
	
```

play .wav, .mp3, .ogg files
```sh
## multimedia player for video and audio
sudo pacman -S --needed mplayer
	
mplayer ./audio/*.ogg
```
