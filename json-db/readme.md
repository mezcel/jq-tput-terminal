# Json DB

The text database is the same ER used in [electron-container](https://github.com/mezcel/electron-container).

* The text content is mostly the same.
* I replaced decade info with content from www.how-to-pray-the-rosary-everyday.com
* I removed unused "about" meta data, but I kept a large amount of unused supplementary mystery data.
* I renamed the Fatima prayer name text.
* I kept everything the same on purpose. I just used regex workarounds for residual html markup text
* I wanted to embellish the concept of a reusable json db template. Ideally, I would have scaled everything down, but this app was just as much a recycling concept as it was a fun "show and tell app"

---

## Apply Jq on local or remote db's

JQ on a local db

```sh
rosaryJSON="local_machine_path"

beadIndex=$(jq $query_beadIndex $rosaryJSON)
```

JQ on an online db

```sh
rosaryJSONGithub="online_url"

beadIndex=$(curl -sS $rosaryJSONGithub | jq $query_beadIndex )
```

Import online db

```sh
rosaryJSONGithub="online_url"
rosaryJSON="local_machine_path"

wget $rosaryJSONGithub

beadIndex=$(jq $query_beadIndex $rosaryJSON)
```
