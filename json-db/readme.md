# Json DB

These are the same DBs used in [electron-container](https://github.com/mezcel/electron-container).

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
