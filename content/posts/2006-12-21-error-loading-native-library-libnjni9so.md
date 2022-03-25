---
title: 'Error loading native library: libnjni9.so'
author: chmouel
type: post
date: 2006-12-22T00:29:57+00:00
url: /2006/12/21/error-loading-native-library-libnjni9so/
dsq_thread_id:
  - 252039325
tags:
  - Oracle

---
If you like me when running oracle on x86_64 get that damn :

Error loading native library: libnjni9.so

when launching dbca and you have googled the thousands five hundred useless answer. Just add the path of the libs $ORACLE\_HOME/lib and $ORACLE\_HOME/lib32 to your /etc/ld.so.conf (or /etc/ld.so.conf.d/oracle.conf on RH derivative) and rerun ldconfig.

If this is during install just jump to a console after you add this line before it launching dbca and run a ldconfig -v as root.

Damn oracle....