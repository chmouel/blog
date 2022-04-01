---
title: Avoiding race conditions between containers with docker and fig
author: chmouel
date: 2014-11-04T20:18:01+00:00
url: /2014/11/04/avoiding-race-conditions-between-containers-with-docker-and-fig/
dsq_thread_id:
  - 3191896827
tags:
  - Docker

---
[<img loading="lazy" src="/wp-content/uploads/2014/11/figs.jpg" alt="figs" width="1076" height="720" class="aligncenter size-full wp-image-840" srcset="https://blog.chmouel.com/wp-content/uploads/2014/11/figs.jpg 1076w, https://blog.chmouel.com/wp-content/uploads/2014/11/figs-300x200.jpg 300w, https://blog.chmouel.com/wp-content/uploads/2014/11/figs-1024x685.jpg 1024w, https://blog.chmouel.com/wp-content/uploads/2014/11/figs-900x602.jpg 900w" sizes="(max-width: 1076px) 100vw, 1076px" />][1]

I have been playing with docker quite a lot lately. The advantage for me is to be able to run functional tests easily and be able to document how deployment should be done of my software as a developer for my endusers (i.e: operators/admins).

The advantage of this method is probably an article of its own which I won't dig into today but just to give a tip for the existing users of <a href="http://fig.sh" target="_blank">fig</a>/docker

It's easy to get race conditions with fig and docker. Take for example, if you have a common pattern when you have a web and a DB, the DB will start before the Web server as orchestrated by fig and link to each others; but since the DB server didn't have time to configure itself and web has already started it would just fail connecting for it.

In an ideal world the app should wait for DB to be up and setup before starting to connect to it but that's not something easy all the time.

People of docker and fig have noticed that and there is some proposal for that from a fig dev :

<a href="https://github.com/docker/docker/issues/7445" target="_blank">https://github.com/docker/docker/issues/7445</a>

The idea there is to have docker waiting that the exposed port is open and listening to be able to set that said container as started. This is not something easy to do since docker would have an hard time to figure out if (and how) that port is open.

Until there is a resolution that comes up you can always resort to the shell script to get it done. There is multiple tool that can check if a port is open  
from ping to netcat or curl etc. It really depend of what you are allowing to have into your base container.

Since most of my devs involved Python, I do always have them in my containers so  
I came up with some built-in python solution, that looks like this :



and in my start.sh of my app server I use it like this before starting my app server:

    check_up "DB Server" ${DB_PORT_3306_TCP_ADDR} 3306
    

the advantage of this method is that it's pretty fast to just look over the  
opening the socket until it's getting open and fail fast.

Hope this helps.

 [1]: /wp-content/uploads/2014/11/figs.jpg