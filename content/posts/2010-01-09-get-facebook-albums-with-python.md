---
title: Get Facebook albums with python
author: chmouel
type: post
date: 2010-01-09T14:42:19+00:00
url: /2010/01/09/get-facebook-albums-with-python/
dsq_thread_id:
  - 253929144
tags:
  - Python

---
Since I haven't see much script like this around the web here is a quick script to suck bunch of albums from facebooks (your own) nothing fancy just something to get you started with pyfacebook.

<pre lang="python">#!/usr/bin/python
import os
import urllib
from facebook import Facebook

# see http://developers.facebook.com/get_started.php
# Your API key
API_KEY="YOUR_API_KEY"
# Application secret key
SECRET_KEY="YOUR_SECRET_KEY"

cnx = Facebook(API_KEY, SECRET_KEY)
cnx.auth.createToken()
cnx.login()
cnx.auth.getSession()

def choose_albums(cnx):
    cnt = 1
    ret={}
    bigthing=cnx.photos.getAlbums(cnx.uid)
    
    for row in bigthing:
        ret[cnt] = row['name'], row['aid'], row['link']
        print "%d) %s - %s" % (cnt, row['name'], row['link'])
        cnt += 1
    ans = raw_input("Choose albums (separated by ,): ")
    return [ret[int(row)] for row in ans.split(', ') ]

chosen_albums = choose_albums(cnx)
for album in chosen_albums:
    name, aid, _ =  album
    print "Album: ", (name)
    ddir = "fbgallery/%s" % name
    if not os.path.exists(ddir):
        os.makedirs(ddir)
    for photo in cnx.photos.get(aid=aid):
        url = photo['src_big']
        dest="%s/%s.jpg" % (ddir, photo['pid'])
        if not os.path.exists(dest):
            print "Getting: ", url
            urllib.urlretrieve(url, dest)
</pre>