---
title: Emacs and nosetests
author: chmouel
type: post
date: 2012-10-14T14:19:07+00:00
url: /2012/10/14/emacs-and-nosetests/
dsq_thread_id:
  - 884757827
tags:
  - Emacs
  - Openstack
  - Python

---
Sometime you just need a long trans atlantic flight and a stupidly long stop-over in a random city to do some of those task that can improve your day to day but you never take some time to do it.

When using emacs I wanted a simple way to launch a nosetests on the current function my cursor is in Emacs. The syntax on nosetests is a bit tricky and I actually always have to look at my shell history to know the proper syntax (nosetests directory/filename.py:Class.function).

I created a simple wrapper for emacs for  that which allow to just hit a key to copy the nosetests command to feed to your shell or to use it for the compile buffer.

It's available from here :

<https://github.com/chmouel/emacs-config/blob/master/modes/nosetests.el>

I have binded those keys for my python mode hook :

<pre lang="lisp">(local-set-key (kbd "C-S-t") 'nosetests-copy-shell-comand)
(local-set-key (kbd "C-S-r") 'nosetests-compile)
</pre>

Happy [TDD][1]!!!!

**UPDATE**: There was an another nose mode already that does much more available here : <https://bitbucket.org/durin42/nosemacs/>

 [1]: http://en.wikipedia.org/wiki/Test-driven_development