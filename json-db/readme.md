# Json DB

Enclosed are JSON Database Files

This is the same DB used in my html rosary projects. I may fave fixed a word or two, but its ER is the same.

Because it is the same DB there is a lot of bloat. This bloat can be incorperated into this App, but I have not done so.

---

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
