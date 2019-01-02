# Audio

When this App starts, it will call ```dl-app-audio.sh``` which will download GNU Audio Oggs.

- I focused on Ogg for GNU sake, but .wav, .mp3, .midi is also compatible for this app.

## Source Audio:

The following files are used in this app and taken from [wikimedia.org](https://commons.wikimedia.org/wiki/Category:Ogg_files_of_Christian_music)

- [Schola_Gregoriana-Ave_Maria.ogg](https://en.wikipedia.org/wiki/File:Schola_Gregoriana-Ave_Maria.ogg)

- [Schola_Gregoriana-Pater_Noster.ogg](https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Pater_Noster.ogg)

- [JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg](https://commons.wikimedia.org/wiki/File:JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg)

- [Byrd_4-Part_Mass_-_Credo.ogg](https://commons.wikimedia.org/wiki/File:Byrd_4-Part_Mass_-_Credo.ogg)

- [Petits_Chanteurs_de_Passy_-_Salve_Regina_de_Hermann_Contract.ogg](https://commons.wikimedia.org/wiki/File:Petits_Chanteurs_de_Passy_-_Salve_Regina_de_Hermann_Contract.ogg)

- [Schola_Gregoriana-Antiphona_et_Magnificat.ogg](https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Antiphona_et_Magnificat.ogg)

- [The_Tudor_Consort_-_J_S_Bach_-_Magnificat_BWV_243_-_Gloria_Patri.ogg](https://commons.wikimedia.org/wiki/File:The_Tudor_Consort_-_J_S_Bach_-_Magnificat_BWV_243_-_Gloria_Patri.ogg)


The following files are used in this app and taken from [archive.org](archive.org)

* [Beep.ogg](https://archive.org/details/kkkfffbird_yahoo_Beep_201607)

* [01SignOfTheCross.ogg](https://archive.org/details/01SignOfTheCross)

* [WindChime.ogg](WindChimeCellPhoneAlert/WindChime.ogg)

---

Potential audio candidates:

* [SalveRegina.ogg](https://archive.org/details/SalveRegina_889) [link](https://archive.org/download/SalveRegina_889/SalveRegina.ogg)

* [Litany_of_Loreto.ogg](https://archive.org/details/LitanyOfLoreto) [link](https://archive.org/download/LitanyOfLoreto/Litany_of_Loreto.ogg)

* [HolyRosaryPrayer.zip](https://archive.org/details/HolyRosaryPrayer) [link](https://archive.org/compress/HolyRosaryPrayer/formats=OGG%20VORBIS&file=/HolyRosaryPrayer.zip)

---

### Audio Software:

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
