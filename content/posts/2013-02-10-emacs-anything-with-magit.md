---
title: emacs anything with magit
author: chmouel
type: post
date: 2013-02-10T21:48:33+00:00
url: /2013/02/10/emacs-anything-with-magit/
dsq_thread_id:
  - 1075935897
tags:
  - Emacs
  - Programming

---
I have been using quite a bit the [anything-mode][1] for Emacs, it's basically a [Quicksilver][2]/[Alfred][3] or [Gnome-do][4] for Emacs and allow to configure a lot of different sources to complete some chosen 'source'with different actions.

With my work on [OpenStack][5] I have found myself jumping a lot between git directories and due configured the variable **'magit-repo-dirs** for easy access to most of them easily.

Plugging those two just seemed natural I had already this in my emacs to quickly open those magit repository directories :

<pre lang="&quot;lisp">(global-set-key (read-kbd-macro "C-S-o") '(lambda ()(interactive) (dired (magit-read-top-dir nil))))</pre>

But going with anything is much nicer and I can add another action for openning the source to  magit so I quickly came up with this magit source :

[gist id="4751125" file="anything-magit.el"]

so now I open my different [OpenStack Swift][6] projects quickly with only a few keyboard touch (I bind my custom anything function to C-z) which shows graphically like this :

[<img loading="lazy" class="aligncenter size-full wp-image-586" alt="anything switch to magit dirs." src="/wp-content/uploads/2013/02/Screen-Shot-2013-02-10-at-22.18.56.png" width="1091" height="840" srcset="https://blog.chmouel.com/wp-content/uploads/2013/02/Screen-Shot-2013-02-10-at-22.18.56.png 1091w, https://blog.chmouel.com/wp-content/uploads/2013/02/Screen-Shot-2013-02-10-at-22.18.56-300x230.png 300w, https://blog.chmouel.com/wp-content/uploads/2013/02/Screen-Shot-2013-02-10-at-22.18.56-1024x788.png 1024w" sizes="(max-width: 1091px) 100vw, 1091px" />][7]

as always my full emacs config is available here:

<http://github.com/chmouel/emacs-config>

 [1]: http://www.emacswiki.org/emacs/Anything
 [2]: http://qsapp.com/ "Quicksilver"
 [3]: www.alfredapp.com
 [4]: http://do.cooperteam.net/ "Gnome-do"
 [5]: http://openstack.org
 [6]: http://swift.openstack.org/
 [7]: /wp-content/uploads/2013/02/Screen-Shot-2013-02-10-at-22.18.56.png