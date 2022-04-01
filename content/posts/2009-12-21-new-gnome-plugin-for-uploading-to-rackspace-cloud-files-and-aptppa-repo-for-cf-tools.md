---
title: New GNOME plugin for uploading to Rackspace Cloud Files and APT/PPA repo for CF tools.
author: chmouel
date: 2009-12-21T15:50:37+00:00
url: /2009/12/21/new-gnome-plugin-for-uploading-to-rackspace-cloud-files-and-aptppa-repo-for-cf-tools/
dsq_thread_id:
  - 252039389
tags:
  - Rackspace

---
[<img loading="lazy" src="/wp-content/uploads/2009/12/Screenshot-300x218.png" alt="" title="Upload to Rackspace Cloud Files" width="300" height="218" class="aligncenter size-medium wp-image-266" align="right" srcset="https://blog.chmouel.com/wp-content/uploads/2009/12/Screenshot-300x218.png 300w, https://blog.chmouel.com/wp-content/uploads/2009/12/Screenshot.png 900w" sizes="(max-width: 300px) 100vw, 300px" />][1]

Sometime ago I made a shell script to upload directly to Rackspace CF using the script capability of nautilus. While working well it did not offer the progress bar and was hard to update. I have made now as a proper python nautilus plugin which offer these features.

The code is available here :

<http://github.com/chmouel/nautilus-cloud-files-plugin>

The old version is here, which is still a good example for uploading to Rackspace CF via the shell :

[http://github.com/chmouel/nautilus-shell-script-rackspace-cloud-files  
][2] 

To make it easier for people to install all the tools I have made for Rackspace Cloud Files I have made available a PPA repository for ubuntu karmic which should work in debian unstable :

[https://launchpad.net/~chmouel/+archive/rackspace-cloud-files  
][3]  
it contains as well the API packaged until they are going to be uploaded to the official debian/ubuntu repositories.

 [1]: /wp-content/uploads/2009/12/Screenshot.png
 [2]: http://github.com/chmouel/nautilus-shell-script-rackspace-cloud-files
 [3]: https://launchpad.net/~chmouel/+archive/rackspace-cloud-files