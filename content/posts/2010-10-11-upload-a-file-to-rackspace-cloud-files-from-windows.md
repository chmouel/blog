---
title: Upload a file to Rackspace Cloud Files from Windows
author: chmouel
date: 2010-10-11T21:40:05+00:00
url: /2010/10/11/upload-a-file-to-rackspace-cloud-files-from-windows/
dsq_thread_id:
  - 252041210
tags:
  - Cloud
  - Rackspace

---
I don't have to use much of the Windows Operating System except when I have to  synchronize my Garmin GPS to use the excellent [SportsTrack][1] software for my fitness training.

I wanted to get safe and backup my SportsTrack 'logbook' directly to Rackspace Cloud Files; while this is easy to do from Linux using some other [script][2] I made but I haven't had anything at hand for Windows without having to install bunch of Unix tools.

So I made a quick C# CLI binary to allow just do that and do my backups via a 'Scheduler Task' (or whatever cron is called on Windows).

It's available here :

<http://github.com/chmouel/upload-to-cf-cs>

and note that you will need [nant][3] to compile it.

 [1]: http://www.zonefivesoftware.com/sporttracks/
 [2]: http://gist.github.com/440304
 [3]: http://nant.sourceforge.net