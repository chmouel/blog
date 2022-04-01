---
title: Get latest lyrics of a scrobbled LastFM song
author: chmouel
date: 2010-10-09T07:56:05+00:00
url: /2010/10/09/get-latest-lyrics-of-a-scrobbled-lastfm-song/
dsq_thread_id:
  - 264031077
tags:
  - Programming

---
All my music players (Spotify, XBMC, Rythmbox etc...) are [scrobbling][1] over [lastfm][2] but not all of them display song lyrics properly so I came up with a quick Google AppEngine app that grab the latest or current song scrobbled over  last.fm and display its lyrics. No fancy HTML or javascript just the lyrics displayed for your enjoyment.

This is available here :

<http://getlastlastfmlyrics.appspot.com/>

for the scripter around you can just get (via curl or other) :

http://getlastlastfmlyrics.appspot.com/?u=username

and it will automatically display it for that username.

 [1]: http://www.last.fm/help/faq?category=Scrobbling
 [2]: http://www.last.fm