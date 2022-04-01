---
title: python syntax warning in emacs
author: chmouel
date: 2009-08-31T05:04:28+00:00
url: /2009/08/31/python-syntax-warning-in-emacs/
dsq_thread_id:
  - 253592079
tags:
  - Emacs
  - Python

---
One of the best feature to have with Emacs when doing python development is to have a real time syntax error/warning check highlighted in your code to avoid many errors or superfluous code.

This code is taken from the brillant Emacswiki [python page][1].

You need to install pyflakes first which should be available on your linux distro by default in a package or for the other OS you may follow the procedure from the [pyflakes webpage][2].

and add this configuration to your .emacs :

<pre lang="lisp">(when (load "flymake" t)
(defun flymake-pyflakes-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "pyflakes" (list local-file))))
(add-to-list 'flymake-allowed-file-name-masks
             '("\\.py\\'" flymake-pyflakes-init)))
</pre>

make sure pyflakes is in your path and enable flymake-mode by default if you like for all python mode :

`<br />
(add-hook 'python-mode-hook 'my-python-mode-hook)`

go by M-x customize flymake as well if you like to customise some variables.

 [1]: http://www.emacswiki.org/cgi-bin/wiki/PythonMode
 [2]: http://www.divmod.org/trac/wiki/DivmodPyflakes