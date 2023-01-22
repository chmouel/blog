---
title: Xterm like Control-L in Eshell
author: chmouel
date: 2006-12-28T00:00:15+00:00
url: /2006/12/27/xterm-like-control-l-in-eshell/
dsq_thread_id:
  - 260973158
tags:
  - Emacs

---
If you want to emulate Control-L in Eshell (the Emacs Shell) like in Xterm, you can use this :</p> 


```lisp
(defun eshell-show-minimum-output ()
  (interactive)
  (goto-char (eshell-beginning-of-output))
  (set-window-start (selected-window)
		    (save-excursion
		      (goto-char (point-max))
		      (line-beginning-position)))
  (eshell-end-of-output))

```


And add a key bind to it in your custom hook :


```lisp
(local-set-key "\C-l" 'eshell-show-minimum-output)</p>

<p>
  
```

</p>