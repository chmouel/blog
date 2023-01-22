---
title: Get size of Postgres DB from filesystem
author: chmouel
date: 2006-06-05T08:26:55+00:00
url: /2006/06/05/get-size-of-postgres-db-from-filesystem/
tags:
  - postgres
  - Scripts

---
Get the size accurately from postgres local filesystem, i guess there is some sql stuff that can do that but that does the job as well for me :


```bash
#!/bin/bash
/usr/lib/postgresql/8.1/bin/oid2name  -U postgres|while read -a e;do
name=${e[1]}
oid=${e[0]}
[[ $oid == "All" || $oid == "Oid" || -z $oid || -z $name ]] && continue
typeset -a size
size=(`du -s /var/lib/postgresql/8.1/main/base/$oid`)
size=${size[0]}
printf "%-20s %-20s\n" ${name} ${size}
done | sort -n -r -k 2 |awk '{printf "%-20s%20d Mb\n", $1, $2 / 1024}'
```
