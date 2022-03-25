---
title: Customize face at point in Emacs
author: chmouel
type: post
date: 2009-12-22T16:58:02+00:00
url: /2009/12/22/customize-face-at-point-in-emacs/
dsq_thread_id:
  - 253888723
tags:
  - Emacs

---
[<img loading="lazy" src="/wp-content/uploads/2009/12/Screenshot-1-300x270.png" alt="" title="Emacs customize-face" width="300" height="270" class="alignright size-medium wp-image-270" srcset="https://blog.chmouel.com/wp-content/uploads/2009/12/Screenshot-1-300x270.png 300w, https://blog.chmouel.com/wp-content/uploads/2009/12/Screenshot-1.png 731w" sizes="(max-width: 300px) 100vw, 300px" />][1]

It's probably interesting only for the hardcore Emacs users but the last CVS version of emacs (2009-12-17) get a nifty new improvement if you need to customize a face property.

If you point on the text where you want to customize it will detect it automatically which face point you are on and ask you if this is what you want to customize (after launching the command M-x customize-face). No guessing around with list-face-displays anymore.

I am just mentioning that because it does not seems to me mentioned in the CHANGES file.

 [1]: /wp-content/uploads/2009/12/Screenshot-1.png