---
title: Deploying minishift on a remote laptop.
author: chmouel
date: 2017-06-09T13:31:28+00:00
url: /2017/06/09/deploying-minishift-on-a-remote-laptop/
tags:
  - OpenShift

---
Part of my new job working with Fabric8 is to having it deployed via minishift.  
Everything is nice and working (try it it's awesome <https://fabric8.io/guide/getStarted/gofabric8.html>) as long you deploy it on your local workstation.

The thing is that my desktop macosx laptop has only 8GB of RAM and is not very well up to the task to get all the services being deployed when I have my web browser and other stuff hogging the memory. I would not do on a remote VM since I want to avoid the nested virtualisationt part that may slow down things even more.

Thanksfully I have another linux laptop with 8GB of RAM which I use for my testing and wanted to deploy minishift on it and access it from my desktop laptop.

This is not as trivial as it sounds but thanks to minishift flexibility there is way to set this up.

So here is the magic command line :

`minishift start --public-hostname localhost --routing-suffix 127.0.0.1.nip.io`

What do we do here? We bind everyting to localhost and 127.0.0.1, what for you may ask? Cause we then are going to use it via SSH. First you need to get the minishift IP :

`<br />
$ minishift ip<br />
192.168.42.209<br />
`

and now since in my case it's the 192.168.42.209 IP I am going to forward SSH it :

`<br />
sudo ssh -L 443:192.168.42.209:443 -L 8443:192.168.42.209:8443 username@host<br />
`

Change the username@host and the 192.168.42.209 to your IP. I use sudo here since to be able to forward the privileged 443 port need root access,

When this is done if the stars was aligned in the right direction when you typed those commands you should be able to see the fabric8 login page :

[<img loading="lazy" src="/wp-content/uploads/2017/06/2017-06-09__15-29-11-31857-1024x511.png" alt="" width="648" height="323" class="aligncenter size-large wp-image-1115" srcset="https://blog.chmouel.com/wp-content/uploads/2017/06/2017-06-09__15-29-11-31857-1024x511.png 1024w, https://blog.chmouel.com/wp-content/uploads/2017/06/2017-06-09__15-29-11-31857-300x150.png 300w, https://blog.chmouel.com/wp-content/uploads/2017/06/2017-06-09__15-29-11-31857-768x383.png 768w" sizes="(max-width: 648px) 100vw, 648px" />][1]

 [1]: /wp-content/uploads/2017/06/2017-06-09__15-29-11-31857.png
