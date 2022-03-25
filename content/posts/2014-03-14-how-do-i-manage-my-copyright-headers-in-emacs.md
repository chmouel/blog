---
title: How do I manage my copyright headers in Emacs
author: chmouel
type: post
date: 2014-03-14T07:07:41+00:00
url: /2014/03/14/how-do-i-manage-my-copyright-headers-in-emacs/
tags:
  - Emacs
  - Openstack

---
My day to day being work or personal is to create [OpenSource][1] code. As an habit I have taken lately I am adding licenses to all new files I am creating.

I have historically used the [\`auto-insert-mode][2] with a default template. For example for my newly created python files I would have this for configration :

```lisp
;AutoInsert
(auto-insert-mode 't)
(setq auto-insert-alist '((python-mode . "python.py")))
```


and in my <span style="color: #808080;"><em>`auto-insert-directory</em></span> directory there would be a python.py template with my license files.

But that's not so smart, since I wanted to find a mechanism to switch between work email and personal emails for my copyright I needed those templates to be more dynamic.

Things with auto-insert templates taken from a directory they are not so dynamics and reading through the always excellent [emacswiki page][3] it seems that you need to <span style="color: #808080;">`define-auto-insert</span> the templates to get dynamic variables.

I didn't want to go to the define-auto-insert because I am always using the yasnippet package for my snippets which has a great expansion support and a nice [templating language][4].

As it's mostly always the case if you have a problem you can be sure it's already resolved by others, so a quick search on the internet leaded me to a gist file written by a guy three years ago that does exactly what I wanted :



So now that I had my header loaded from yasnippet I could add some smartness into it. I have first written this function :

```lisp
(defun yas--magit-email-or-default ()
  "Get email from GIT or use default"
  (if (magit-get-top-dir ".")
      (magit-get "user.email")
      user-mail-address))
```

this function would check if we are in a git directory and get the user.email git configuration, if we are not it would just reply by the standard emacs variable <span style="color: #808080;"><em>`user-mail-address</em></span>.

I have just to plug that in my template like this :


```bash
# -*- mode: snippet -*-
# name: header
# --
# -*- coding: utf-8 -*-
# Author: Chmouel Boudjnah &lt; `(yas--magit-email-or-default)`>
```


and depending of my local configuration of my git repo it will add my license email according to that.

If I really needed to override the user-mail-address without using git I could always just drop a [.dir-locals.el][5] with something like this :

```lisp
((nil . ((user-mail-address . "chmouel@othercompany.com"))))
```


which would override the default user-mail-address to whatever I want.

 [1]: http://openstack.org
 [2]: https://www.gnu.org/software/emacs/manual/html_node/autotype/Autoinserting.html
 [3]: http://www.emacswiki.org/emacs/AutoInsertMode
 [4]: http://capitaomorte.github.io/yasnippet/snippet-development.html
 [5]: http://www.gnu.org/software/emacs/manual/html_node/emacs/Directory-Variables.html
