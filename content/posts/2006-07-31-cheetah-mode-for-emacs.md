---
title: Cheetah Mode for Emacs
author: chmouel
date: 2006-07-31T23:35:09+00:00
url: /2006/07/31/cheetah-mode-for-emacs/
dsq_thread_id:
  - 252039318
tags:
  - Emacs
  - Python

---
Here is a simple html derived mode for [Cheetah][1] templates files. The font-locking regexp can be improved thought but thatâ€™s a start.

<pre lang="lisp">(define-derived-mode cheetah-mode html-mode "Cheetah"
  (make-face 'cheetah-variable-face)
  (font-lock-add-keywords
   nil
   '(
     ("\\(#\\(from\\|else\\|include\\|set\\|import\\|for\\|if\\|end\\)+\\)\\>" 1 font-lock-type-face)
     ("\\(#\\(from\\|for\\|end\\)\\).*\\&lt;\\(for\\|import\\|if\\|in\\)\\>" 3 font-lock-type-face)
     ("\\(\\$\\(?:\\sw\\|}\\|{\\|\\s_\\)+\\)" 1 font-lock-variable-name-face))
   )
  (font-lock-mode 1)
  )
(setq auto-mode-alist (cons '( "\\.tmpl\\'" . cheetah-mode ) auto-mode-alist ))
</pre>

 [1]: http://www.cheetahtemplate.org/