---
title: Better output from sqlite3 command line
author: chmouel
date: 2009-07-15T23:47:55+00:00
url: /2009/07/16/better-output-from-sqlite3-command-line/
dsq_thread_id:
  - 252691139
tags:
  - Programming

---
That weird output from sqlite3 command line is annoying you as well ? Just set this up to get something better :


```bash
cat &lt; &lt;EOF>~/.sqliterc
.mode "column"
.headers on
.explain on
EOF
```
