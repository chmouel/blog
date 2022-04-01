---
title: Uploading to Rackspace Cloud Files via FTP
author: chmouel
date: 2011-04-06T13:05:44+00:00
url: /2011/04/06/uploading-to-rackspace-cloud-files-via-ftp/
dsq_thread_id:
  - 272564463
tags:
  - Cloud
  - Rackspace

---
[Sometime ago][1] I wrote a [FTP proxy][2] to RackSpace Cloud Files which expose Rackspace Cloud Files as a FTP server acting as a proxy. 

Thanks to the OpenSource community a user on github took it and add support [OpenStack][3] and all the latest features available in Cloud Files.

It is now pretty robust and works pretty well via nautilus even with the [pseudo hierarchical folder feature][4]. The fun part here is that it allow you to effectively have a Cloud Drive where you can easily store your files/backup from your Linux desktop via nautilus built-in ftp support.

I have made a video that show how it works :



[Upload to the Cloud via FTP][5] from [Chmouel Boudjnah][6] on [Vimeo][7].

 [1]: https://blog.chmouel.com/2009/10/29/ftp-server-for-cloud-files/
 [2]: https://github.com/chmouel/ftp-cloudfs/
 [3]: http://www.openstack.org/
 [4]: http://docs.openstack.org/openstack-object-storage/developer/content/ch03s02.html#d5e527
 [5]: http://vimeo.com/22024058
 [6]: http://vimeo.com/user4559588
 [7]: http://vimeo.com