---
title: Dox a tool that run python (or others) tests in a docker container
author: chmouel
type: post
date: 2014-09-08T00:56:43+00:00
url: /2014/09/08/dox-a-tool-that-run-python-or-others-tests-in-a-docker-container/
dsq_thread_id:
  - 2997437586
tags:
  - Docker
  - Openstack
  - Python

---
[<img loading="lazy" class="alignright size-full wp-image-810" src="/wp-content/uploads/2014/09/dox-diagram-fix.png" alt="dox-diagram-fix" width="203" height="570" />][1]

Sometime there is some ideas that are just obvious that they are good ideas. When <a href="https://twitter.com/e_monty" target="_blank">Monty</a> <a href="http://article.gmane.org/gmane.comp.cloud.openstack.devel/34675" target="_blank">started to mention</a> on the OpenStack development mailing list about a tool he was hacking on allowing to integrate docker containers to do the testing it was obvious it was those ideas that everybody was thinking about that it would be awesome if it was implemented and started to get used.

The idea of dox is like the name imply is to slightly behave like the <a href="https://pypi.python.org/pypi/tox" target="_blank">tox</a> tool but instead of running virtualenvs you are using docker containers.

The testing in the OpenStack world is a bit different than the other unit testing. Since OpenStack is inherently working with the local system components we have to get abstracted from the local developer box to match exactly the system components. In other words if we run our testing against a zookeeper daemon of a specific version we want to make it sure and easy that this version has been installed.

And that's where <a href="http://docker.io/" target="_blank">docker</a> can help, since you can easily specify different images and how to build them making sure we have those tools installed when we run our testing targets.

There are other issues with tox that we have encountered in our extensive use of it in the OpenStack world we are hoping to solve here. virtualenv has been slow for us and we have come up with all sorts of hacks to get around it. And as monty mention in his mailing list post docker itself does an EXCELLENT job at handling caching and reuse where we easily see in the future those standard image built by the openstack-infra folks that we know works and validated in upstream  
openstack-ci published on <a href="https://registry.hub.docker.com/" target="_blank">dockerhub</a> that everyone else (and dox) can use to run tests.

The tool is available here in <a href="http://ci.openstack.org/stackforge.html" target="_blank">stackforge</a> here :

<a href="https://git.openstack.org/cgit/stackforge/dox" target="_blank">https://git.openstack.org/cgit/stackforge/dox</a>

with an handy README that would get you started :

<https://git.openstack.org/cgit/stackforge/dox/tree/README.rst>

Its not quite ready yet but you can start running tests using it. If you want a fun project to work on that can help the whole Python development community (and not just OpenStack) come hack with us. We are as well on Freenode servers in IRC on channel #dox.

If you are not familiar with the contribution process of Stackforge/OpenStack see this wiki page which should guide through it :

<a href="http://wiki.openstack.org/HowToContribute" target="_blank">http://wiki.openstack.org/HowToContribute</a>

 [1]: /wp-content/uploads/2014/09/dox-diagram-fix.png