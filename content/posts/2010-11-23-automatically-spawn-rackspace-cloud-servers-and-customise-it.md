---
title: Automatically spawn Rackspace Cloud Servers and customise it.
author: chmouel
type: post
date: 2010-11-23T12:36:00+00:00
url: /2010/11/23/automatically-spawn-rackspace-cloud-servers-and-customise-it/
dsq_thread_id:
  - 252039413
tags:
  - Cloud
  - Rackspace

---
Lately I had to spawn some cloud servers and automatically customise them. 

I have used the  [python-cloudservers][1] library and installed it automatically with pypi (works for Debian/Ubuntu you may want to check for other distros):

<pre lang="bash">pypi-install python-cloudservers
</pre>

From there writing the script was pretty straight forward, I needed to know what type of CloudServers I wanted which in my case the smallest was good enough which is number 1 for me. 

If you want to see all flavours you can do something like that from python command prompt  
:

<pre lang="python">import cloudservers
cs = cloudservers.CloudServers("API_USERNAME", "API_PASSWORD")
for i in cs.flavors.list():
    print "ID: %s = %s" % (i.id, i.name)
</pre>

which should output something like this at the time this article has  
been written :

<pre>ID: 1 - 256 server
ID: 2 - 512 server
ID: 3 - 1GB server
ID: 4 - 2GB server
ID: 5 - 4GB server
ID: 6 - 8GB server
ID: 7 - 15.5GB server
</pre>

You need to figure out the image type as well which is basically the Operating System, in this case I wanted Ubuntu Maverick which is 69. If you want to see all image type you can do :

<pre lang="python">import cloudservers
cs = cloudservers.CloudServers("API_USERNAME", "API_PASSWORD")
for i in cs.images.list():
    print "ID: %s = %s" % (i.id, i.name)
</pre>

which print something like this for me at this time :

<pre>ID: 29 = Windows Server 2003 R2 SP2 x86
ID: 69 = Ubuntu 10.10 (maverick)
ID: 41 = Oracle EL JeOS Release 5 Update 3
ID: 40 = Oracle EL Server Release 5 Update 4
ID: 187811 = CentOS 5.4
ID: 4 = Debian 5.0 (lenny)
ID: 10 = Ubuntu 8.04.2 LTS (hardy)
ID: 23 = Windows Server 2003 R2 SP2 x64
ID: 24 = Windows Server 2008 SP2 x64
ID: 49 = Ubuntu 10.04 LTS (lucid)
ID: 14362 = Ubuntu 9.10 (karmic)
ID: 62 = Red Hat Enterprise Linux 5.5
ID: 53 = Fedora 13
ID: 17 = Fedora 12
ID: 71 = Fedora 14
ID: 31 = Windows Server 2008 SP2 x86
ID: 51 = CentOS 5.5
ID: 14 = Red Hat Enterprise Linux 5.4
ID: 19 = Gentoo 10.1
ID: 28 = Windows Server 2008 R2 x64
ID: 55 = Arch 2010.05
ID: 6719676 = Backup-Image
</pre>

Now to make stuff going automatic we send our ~/.ssh/id\_rsa to '/root/.ssh/authorized\_keys' and assuming you have a properly  
configured ssh-agent which was already identified you have a passwordless access and you can launch command.

I have a script that does basic customisations at :

http://chmouel.com/pub/bootstrap.sh

but you get the idea from there to launch the command the way you want, you can as well scp and ssh it after if you wanted to have some non public stuff in the script.

Here is the full script you need to adjust a few variable at the top of the file and customize it the way you want but that should get you started :

 [1]: https://github.com/jacobian/python-cloudservers