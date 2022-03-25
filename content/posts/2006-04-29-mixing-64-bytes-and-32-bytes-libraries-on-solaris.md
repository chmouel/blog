---
title: Mixing 64 bytes and 32 Bytes Libraries on Solaris
author: chmouel
type: post
date: 2006-04-29T22:54:06+00:00
url: /2006/04/29/mixing-64-bytes-and-32-bytes-libraries-on-solaris/
dsq_thread_id:
  - 279102159
tags:
  - Solaris

---
Remind to myself to use the switch -64 on solaris with crle to tell  
the linker on solaris to get the linker 'seeing' 64 libraries.

I wonder why everything is not as simple as linux thought where we  
have everything in one place with /etc/ld.so.config