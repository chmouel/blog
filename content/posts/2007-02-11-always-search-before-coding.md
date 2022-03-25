---
title: Always search before coding
author: chmouel
type: post
date: 2007-02-11T11:47:39+00:00
url: /2007/02/11/always-search-before-coding/
dsq_thread_id:
  - 262820810
tags:
  - Emacs

---
This is a annoying, even if it take 5mn to code thing like that :

<pre lang="lisp">(defun my-dired-rm-rf()
  "Rm -rf directories"
  (interactive)
  (let ((sel (selected-window)))
	(dolist (curFile (dired-get-marked-files))
	  (if (yes-or-no-p (concat "Do you want to remove \"" (file-name-nondirectory curFile) "\" ? "))
		  (progn
			(shell-command (concat "rm -rvf " curFile) 
"*Removing Directories*")
			(kill-buffer "*Removing Directories*")
			(select-window sel)
			(revert-buffer)
			)
		))
	))
</pre>

you discover after a litlle while that if you have did a lilt bit of searching before, you will have discovered a variable call **\`dired-recursive-deletes\`** that would do the thing in a much better way.