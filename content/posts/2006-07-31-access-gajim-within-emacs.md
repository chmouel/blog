---
title: Access Gajim within Emacs
author: chmouel
type: post
date: 2006-07-31T09:28:56+00:00
url: /2006/07/31/access-gajim-within-emacs/
dsq_thread_id:
  - 418780508
tags:
  - Emacs
  - Programming

---
Here is some function to launch a gajim window from Emacs :

<pre lang="lisp">(defvar gajim-remote "/usr/bin/gajim-remote")
(defvar gajim-user-list ())

(defun my-gajim-get-list()
  (save-excursion
    (with-temp-buffer
      (call-process gajim-remote nil t nil "list_contacts")
      (goto-char (point-min))
      (while (re-search-forward "^jid[ ]*:[ ]*\\(.*\\)$" (point-max) t )
        (setq gajim-user-list (append gajim-user-list (list (match-string-no-properties 1)))))))
  gajim-user-list)

(defun my-gajim-talk()
  (interactive)
  (let* ((ff (if (not gajim-user-list)(my-gajim-get-list) gajim-user-list))
         (answer (completing-read "Jabber: " (mapcar (lambda (tt)(list tt)) ff))))
    (message answer)
    (start-process "*GAJIM*" nil gajim-remote "open_chat" answer)
    )
  )
(global-set-key '[(control x)(j)] 'my-gajim-talk)
</pre>

If Emacs had a dbus support that would have been cool.