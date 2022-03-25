---
title: Debugging python-novaclient on the command line.
author: chmouel
type: post
date: 2011-09-02T03:00:13+00:00
url: /2011/09/02/debugging-python-novaclient-on-the-command-line/
dsq_thread_id:
  - 402425630
categories:
  - Uncategorized
tags:
  - Openstack
  - Python
  - Uncategorized

---
I have done lately quite a bit of work with <a href="https://github.com/rackspace/python-novaclient" target="_blank">python-novaclient</a> the (nova/keystone) openstack client. I often experiment it with <a href="http://ipython.org/" target="_blank">ipython</a> in the console.

There is a nice debugging facility in novaclient which you can see while using --debug argument on the command line and if you wanted to use it with ipython you could have that at the beginning of your session :



This would give you the details of the session showing you the REST requests and responses including the headers. It even show you the curl commands that you can use on the command line to experiment with it.