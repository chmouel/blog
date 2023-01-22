---
title: emacs daemon and Xdefaults
author: chmouel
date: 2009-08-11T09:27:21+00:00
url: /2009/08/11/emacs-daemon-and-xdefaults/
dsq_thread_id:
  - 252039381
tags:
  - Emacs

---
It does not seems that emacs started with --daemon read the .Xdefauls resource it seems that the only way setting it is by the _default-frame-alist_ variable. 

I have my setup like this :


```lisp
(setq default-frame-alist '((font-backend . "xft")
                            (font . "Inconsolata-14")
                            (vertical-scroll-bars)
                            (left-fringe . -1)
                            (right-fringe . -1)
                            (fullscreen . fullboth)
                            (menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            ))
```


PS: inconsolata font can be installed from the package ttf-inconsolata