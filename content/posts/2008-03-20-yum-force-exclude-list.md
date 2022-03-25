---
title: Yum Force Exclude List
author: chmouel
type: post
date: 2008-03-20T09:36:06+00:00
url: /2008/03/20/yum-force-exclude-list/
dsq_thread_id:
  - 252100421
tags:
  - Programming
  - Python
  - RedHat

---
While talking with my fellow colleague Darren Birkett about what seems a design limitation  
of yum to not be able to force listing the excludes from yum. I had a  
shoot to make a yum plugin to force listing the excludes.

Here is how it works :

> root@centos5:~> grep exclude /etc/yum.conf  
> exclude=rpm*  
> root@centos5:~> yum install rpm-devel  
> Loading "installonlyn" plugin  
> Loading "changelog" plugin  
> Loading "chmouel" plugin  
> Loading "priorities" plugin  
> Setting up Install Process  
> Setting up repositories  
> Reading repository metadata in from local files  
> Excluding Packages in global exclude list  
> Finished  
> 0 packages excluded due to repository priority protections  
> Parsing package install arguments  
> Nothing to do

rpm* is excluded, but if we use the environment variable **FORCE_EXCLUDE**  
it will force it.

>  root@centos5:~> FORCE_EXCLUDE=true yum install rpm-devel  
> Loading "installonlyn" plugin  
> Loading "changelog" plugin  
> Loading "chmouel" plugin  
> Loading "priorities" plugin  
> Setting up Install Process  
> Setting up repositories  
> Reading repository metadata in from local files  
> 0 packages excluded due to repository priority protections  
> Parsing package install arguments  
> Resolving Dependencies  
> --> Populating transaction set with selected packages. Please wait.  
> \---> Downloading header for rpm-devel to pack into transaction set.  
> rpm-devel-4.4.2-47.el5.i3 100% |=========================| 17 kB 00:00  
> \---> Package rpm-devel.i386 0:4.4.2-47.el5 set to be updated  
> --> Running transaction check  
> [.....]

It will allow you to list the excluded rpm as well :

>  root@centos5:~> FORCE_EXCLUDE=true yum list|grep rpm  
> rpm.i386 4.4.2-47.el5 installed  
> rpm-libs.i386 4.4.2-47.el5 installed  
> rpm-python.i386 4.4.2-47.el5 installed  
> redhat-rpm-config.noarch 8.0.45-22.el5.centos base  
> rpm-build.i386 4.4.2-47.el5 base  
> rpm-devel.i386 4.4.2-47.el5 base  
> root@centos5:~> yum list|grep rpm  
> rpm.i386 4.4.2-47.el5 installed  
> rpm-libs.i386 4.4.2-47.el5 installed  
> rpm-python.i386 4.4.2-47.el5 installed  
> redhat-rpm-config.noarch 8.0.45-22.el5.centos base

See the README.txt in the rpm file to see how to use/install it.

You can download the rpm [here][1] and the src.rpm [here][2]

>

 [1]: http://www.chmouel.com/blog/wp-content/uploads/2008/03/yum-forceexclude-02-1noarch.rpm "Yum Force Exclude Plugin"
 [2]: http://www.chmouel.com/blog/wp-content/uploads/2008/03/yum-forceexclude-02-1src.rpm "Yum Force Exclude Plugin src.rpm"