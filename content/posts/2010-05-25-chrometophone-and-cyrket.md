---
title: chrometophone and cyrket
author: chmouel
type: post
date: 2010-05-25T01:14:38+00:00
url: /2010/05/25/chrometophone-and-cyrket/
dsq_thread_id:
  - 292766240
tags:
  - Android

---
Latest Froyo for Android have a nice feature for pushing messages to a Android phone, it's called Android Cloud to [Device Messaging Framework][1].

Someone at google has developped a nice extensions/apps for sending URL directly from google chrome web browser to your phone, it is called chrometophone and available [here][2].

I often use [cyrket][3] for browsing and installing new apps. I thought it could be nice to add support to chrome2phone when sending a cyrknet URL to my Nexus one to popup a market link to install the app sent.

So here is a [patch][4] against the android APP or directly the [APK][5] to install manually.

 [1]: http://code.google.com/android/c2dm/
 [2]: http://code.google.com/p/chrometophone/
 [3]: http://www.cyrket.com/p/android/
 [4]: http://dl.dropbox.com/u/323635/cyrkNet-for-chrometophone/cyrkNet-for-chrometophone.patch
 [5]: http://dl.dropbox.com/u/323635/cyrkNet-for-chrometophone/chrometophone-android-chmou1.apk