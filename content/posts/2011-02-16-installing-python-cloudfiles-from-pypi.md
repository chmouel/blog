---
title: Installing python-cloudfiles from pypi
author: chmouel
date: 2011-02-16T05:41:33+00:00
url: /2011/02/16/installing-python-cloudfiles-from-pypi/
dsq_thread_id:
  - 253268351
tags:
  - Cloud
  - Programming
  - Python
  - Rackspace

---
I have just uploaded [python-cloudfiles][1] to pypi available [here][2] 

This make things easy to add as a dependence of your project like you can have something like this in your setup.py :

`requirements = ['python-cloudfiles']`

and it will automatically download it as part of the dependence with easy_install or pip. 

cool kids on latest debian/ubuntu can do stuff like this (from [python-stdeb][3] package) :

`pypi-install python-cloudfiles`

which would automatically download the tarball from pypi and install it as a packages (like the way it should be for prod machine!)

If you have a virtualenv environment you can easily do a (needs [python-pip][4] package) :

`pip -E /usr/local/myvirtualenvroot install python-cloudfiles<br />
` 

and magic would be done to get you on latest python-cloudfiles.

As a bonus side you can browse online the python-cloudfiles library :

[http://packages.python.org/python-cloudfiles/][5]

**  
[Update] This has been renamed back to python-cloudfiles please update your setup.py or scripts.**

 [1]: https://github.com/rackspace/python-cloudfiles
 [2]: http://pypi.python.org/pypi/python-cloudfiles/
 [3]: http://packages.debian.org/sid/python-stdeb
 [4]: http://packages.debian.org/sid/python-pip
 [5]: http://packages.python.org/cloudfiles/