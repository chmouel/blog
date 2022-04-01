---
title: FTP server for Cloud Files
author: chmouel
date: 2009-10-29T14:38:14+00:00
url: /2009/10/29/ftp-server-for-cloud-files/
dsq_thread_id:
  - 252364451
tags:
  - Rackspace

---
I have just committed an experiment of a FTP Server answering to Cloud Files. It act completely transparently to be able to use any FTP Client to connect to cloud-files.

There is probably a couple of bugs there but the basis of it seems to be working, please let me know if you find any problems with it.

**Usage**

By default it will bind to port 2021 and localhost to be able to be launched by user which can be changed via the command line option -p. The username password are your API Username and key.

**Manual Install**

FTP-Cloudfs require the pyftpdlib which can be installed from here :

<http://code.google.com/p/pyftpdlib/>

and python-cloudfiles :

<http://github.com/rackspace/python-cloudfiles>

you can then checkout FTP-Cloudfs from here :

<http://github.com/chmouel/ftp-cloudfs>

The way to install python package is pretty simple, simply do a python  
setup.py install after uncompressing the tarball downloaded.

**Automatic Install:**

You can generate a debian package directly from the source if you have  
dpkg-buildpackage installed on your system. It will give you a nice  
initscripts as well to start automatically the ftp cloudfs process.

**Support**

Albeit I am working for Rackspace Cloud this is not supported by  
Rackspace but please feel free to send a comment here if you have any  
problems.