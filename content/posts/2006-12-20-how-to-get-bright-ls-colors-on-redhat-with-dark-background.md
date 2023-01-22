---
title: How to get bright LS colors on Redhat with dark background
author: chmouel
date: 2006-12-21T02:52:01+00:00
url: /2006/12/20/how-to-get-bright-ls-colors-on-redhat-with-dark-background/
dsq_thread_id:
  - 252777929
tags:
  - RedHat

---
Something that i haven't find via goole. By default on RedHat (and derivatives) if you get a dark background the colored ls will be seen really humm bold from a xterm (since i guess there default gnome-terminal has been configured to have a white background ). 

The solution is to 


```bash
cp /etc/DIR_COLORS /etc/DIR_COLORS.xterm

```


or to redefine your dircolors to get the /etc/DIR\_COLORS files instead of /etc/DIR\_COLORS.xterm in your shell init configuration.