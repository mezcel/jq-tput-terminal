# Audio

When this App starts, it will call ```./source/ogg/download-ogg-media``` which will download GNU Audio Oggs.

- I focused on Ogg for GNU sake. ogg123 is a vorbis-tools audio player which will play audio from within the terminal console using pulseaudio

## Source Audio:

Taken from [wikimedia.org](https://commons.wikimedia.org/wiki/Category:Ogg_files_of_Christian_music)

- [Schola_Gregoriana-Ave_Maria.ogg](https://en.wikipedia.org/wiki/File:Schola_Gregoriana-Ave_Maria.ogg)

- [Schola_Gregoriana-Pater_Noster.ogg](https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Pater_Noster.ogg)

- [JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg](https://commons.wikimedia.org/wiki/File:JOHN_MICHEL_CELLO-BACH_AVE_MARIA.ogg)

- [Byrd_4-Part_Mass_-_Credo.ogg](https://commons.wikimedia.org/wiki/File:Byrd_4-Part_Mass_-_Credo.ogg)

- [Petits_Chanteurs_de_Passy_-_Salve_Regina_de_Hermann_Contract.ogg](https://commons.wikimedia.org/wiki/File:Petits_Chanteurs_de_Passy_-_Salve_Regina_de_Hermann_Contract.ogg)

- [Schola_Gregoriana-Antiphona_et_Magnificat.ogg](https://commons.wikimedia.org/wiki/File:Schola_Gregoriana-Antiphona_et_Magnificat.ogg)

- [The_Tudor_Consort_-_J_S_Bach_-_Magnificat_BWV_243_-_Gloria_Patri.ogg](https://commons.wikimedia.org/wiki/File:The_Tudor_Consort_-_J_S_Bach_-_Magnificat_BWV_243_-_Gloria_Patri.ogg)


Taken from [archive.org](archive.org)

* [Beep.ogg](https://archive.org/details/kkkfffbird_yahoo_Beep_201607)

* [01SignOfTheCross.ogg](https://archive.org/details/01SignOfTheCross)

* [WindChime.ogg](WindChimeCellPhoneAlert/WindChime.ogg)

---

### Audio Software:

This app uses Ogg audio files.

I use ogg123 media player

* [ogg123](https://xiph.org/vorbis) is a [ogg](https://xiph.org/vorbis) audio player which can run within terminal environment

```sh
## Debian
apt-get install vorbis-tools

## Arch
pacman -S vorbis-tools

## Alpine
apk add vorbis-tools

## Slackware
slapt-get --install vorbis-tools
```
