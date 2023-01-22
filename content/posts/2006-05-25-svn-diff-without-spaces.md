---
title: svn diff without spaces
author: chmouel
date: 2006-05-25T11:26:15+00:00
url: /2006/05/25/svn-diff-without-spaces/
tags:
  - Scripts

---
I am sic of spaces and having svn diff that does not get the spaces removed. So here is a simple script that does the stuff that you can use as your diff-cmd :


```bash
#!/bin/bash
for i in $@;do
echo $i |grep -q ")" && continue
echo $i |grep -q "(" && continue
t="$t $i"
done
diff -bBw $t
```
