---
title: Building RPM with Docker images
author: chmouel
date: 2014-12-31T11:24:36+00:00
url: /2014/12/31/building-rpm-with-docker-images/
dsq_thread_id:
  - 3376650052
tags:
  - Docker
  - Linux

---
![](/wp-content/uploads/2014/12/dockerrpm-175x300.jpg)

For an internal project at work I have been thinking about more how to generate RPMs out of our CI. I wanted to have them produced as artifacts of the build so I can test how if they can be installed and properly working with some smoketests.

Since we are using Docker for most of the things in our CI, I have been thinking about more about how to do that with docker images and RPM.

Ideally what I would love to have from RPM is to be able to integrate with Docker so when you build your RPM you are building in a docker images. Basically the %prep section will be spined-up in a special docker images and the rpm output would be back to the host.

The advantages outside of making sure you are building your RPMs in a confined and reproducible enthronement is that you would be able to say from the same rpm build that I want to build the RPMs for centos/fedora/rhel/etc.. in whatever flavours.

I am sure there is some workaround way to do that with chroot and such but it would be nice if this mechanism is built-in inside RPM (be it an abstracted system to do that as chroot/docker or whatever container technology).

Since we are not there yet, I have ended-up just the straightforward way of constructing an image with my build dependences.

It's a python project which use <a href="http://docs.openstack.org/developer/pbr/" target="_blank">PBR</a> for generating the version so I have to generate first a tarball in my build directory and get the generated version.

I modify the spec file with that version and start to build the image with the new tarball and new spec file.

I run the image and mount a volume to a local directory on the host and start running the image which run the start.sh script in the container.

The start.sh script is pretty straightforward, it builds the rpm and copy them to the volume directory as root (since there is no other way) so they can be copied from the host to the artifact output directory.

I could have not copying and uploading to a object storage system (like Swift obviously) but since I needed to be available in the CI I ended-up up with the local file copy system.

Here is my scripts, in SPECS/project.spec and SOURCES/* there is the spec and sources/patches as a standard rpm, the only thing is to make sure to use a %define _version VERSION and use that macro for Version in your spec file.

The main **build.sh** which get run from the CI



The **DockerFile** which try to be optimised a bit for Docker caching :

and the script **start.sh** that gets run inside the container :



It probably would not fit straight to your environement but at least that may get you the idea.

 [1]: /wp-content/uploads/2014/12/dockerrpm.jpg
