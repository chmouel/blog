---
title: Emacs transparency with mouse wheel
author: chmouel
date: 2009-09-16T02:52:22+00:00
url: /2009/09/16/emacs-and-transparency-mouse-wheel/
dsq_thread_id:
  - 252039403
tags:
  - Emacs

---
Emacs is playing fancy on the latest version (since emacs 23) it has now support for transparency at least on Linux when you have a [composited Windows Manager.][1]

As explained on the Emacs wiki [here][2] everything is controlled by this frame parameter like this :

<pre lang="lisp">(set-frame-parameter (selected-frame) 'alpha '(85 50))
</pre>

I have automated the thing to allow the transparency to increase or decrease when combined with the alt key just put this code somewhere in your $HOME/.emacs or $HOME/.emacs.d/init.el :

<pre lang="lisp">(defun my-increase-opacity()
  (interactive)
  (let ((increase (+ 10 (car (frame-parameter nil 'alpha)))))
    (if (> increase 99)(setq increase 99))
    (set-frame-parameter (selected-frame) 'alpha (values increase 75)))
)

(defun my-decrease-opacity()
  (interactive)
  (let ((decrease (- (car (frame-parameter nil 'alpha)) 10)))
    (if (&lt; decrease 20)(setq decrease 20))
    (set-frame-parameter (selected-frame) 'alpha (values decrease 75)))
)

(global-set-key (kbd "M-&lt;mouse-4>") 'my-increase-opacity)
(global-set-key (kbd "M-&lt;mouse -5>") 'my-decrease-opacity)
&lt;/mouse></pre>

 [1]: http://en.wikipedia.org/wiki/Compositing_window_manager
 [2]: http://www.emacswiki.org/emacs/TransparentEmacs