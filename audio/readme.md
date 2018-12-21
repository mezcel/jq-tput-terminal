# Audio

I recommend importing and curating audio which is appropriate to your own tastes.

Enclosed are open source Demo sounds used in this app.

In order to both save space on Github and attribute source credits, audio can be installed independent of App ```dl-app-audio.sh```

- It is also faster than hosting on Github


## Source Audio:

https://commons.wikimedia.org/wiki/Category:Ogg_files_of_Christian_music

- [Schola_Gregoriana-Ave_Maria.ogg](https://en.wikipedia.org/wiki/File:Schola_Gregoriana-Ave_Maria.ogg)

- [Schola_Gregoriana-Pater_Noster.ogg](https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Pater_Noster.ogg)

- [JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg](https://commons.wikimedia.org/wiki/File:JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg)

- [Byrd_4-Part_Mass_-_Credo.ogg](https://commons.wikimedia.org/wiki/File:Byrd_4-Part_Mass_-_Credo.ogg)

---

midi audio files
```sh
## audio requires fluidsynth and a midi soundfont
fluidsynth -a alsa -m alsa_seq -l -i -R 1 -C 1 /usr/share/soundfonts/FluidR3_GM.sf2 ./audio/*.mid
	
```

.wav, .mp3, .ogg files
```sh
mplayer ./audio/*.ogg
```
