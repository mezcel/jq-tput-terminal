# asciinema

asciinema is a terminal recorder. I used this to make a demo preview for this app.

enclosed is a ```.cast``` file demo

[Live asciinema link](https://asciinema.org/a/217793) Quick preview demo

install
```sh
## install on arch linux

sudo pacman -S --needed asciinema
```

record
```sh
## start recording terminal session
## recommended file name extensions (.cast or .json)

asciinema record <filename-and-destination>
```

play
```sh
## playback recorded session

asciinema play <filename.cast>
```

publish
```sh
## upload to the asciinema.org web server

asciinema upload <filename.cast>
```

authorize
```sh
## authorize uploads with your computer, UUIDv4
## ~/.config/asciinema/install-id

asciinema auth
```
