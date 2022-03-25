---
title: Building packages for multiple distros on launchpad with docker
author: chmouel
date: 2021-01-31T15:59:43+00:00
url: /2021/01/31/building-packages-for-multiple-distros-on-launchpad-with-docker/
---
I have been trying to build some packages for the ubuntu distros for a new program I have released, [gnome-next-meeting-applet][1]

In short, it what quite painful! if you are quite new to the launchpad and debian packaging ways (which I wasn't and yet It took me some time to figure out) you can get quite lost. I got to say that the [fedora copr][2] experience is much smoother. After a couple of frustrated google and stackoverflow searches and multiple tries I finally figured out a script that builds and upload properly to [launchpad][3] via docker to make it available to my users.

  1. The first rule of uploading to launchpad it's to properly setup your GPG key on your account making sure it match what you have locally.
  2. The second rule is making sure the new upload you make increase onto the precedent uloaded version or it will be rejected.
  3. The third rule is to be patient or work on week-end, because the queue can be quite slow.

Now the magic is happening in this script :

<https://github.com/chmouel/gnome-next-meeting-applet/blob/742dbe48795c0151411db69065fdd773762100e1/debian/build.sh#L20-L41>

We have a **[Dockerfile][4]** with all the dependencies we need for building the package in this file :

<https://github.com/chmouel/gnome-next-meeting-applet/blob/a2785314365c51200935ad63c38f490c597989c9/debian/Dockerfile>

When we launch the script in the main loop we modify the FROM to go to the distro docker tag targeted (here I have LTS and ROLLING) and we start the container build.

When it's done we mount our current source as a volume inside the container and mount our ~/.gnupg to the build user gnupg inside the container.

With <a href="https://manpages.debian.org/jessie/devscripts/dch.1.en.html" data-type="URL" data-id="https://manpages.debian.org/jessie/devscripts/dch.1.en.html">dch</a> we increase the targeted distro version and we add as well after the release number the distro target after the _"~"_ like this _"0.1.0-1~focal1"_.

We finish the upload with [dput][5] and launchpad \*should\* then send you an email it was accepted.

After waiting a bit your package should be built for the multiple distribution.

![](/wp-content/uploads/2021/01/image.png)

 [1]: https://github.com/chmouel/gnome-next-meeting-applet
 [2]: https://copr.fedorainfracloud.org/
 [3]: http://launchpad.net
 [4]: https://github.com/chmouel/gnome-next-meeting-applet/blob/a2785314365c51200935ad63c38f490c597989c9/debian/Dockerfile
 [5]: https://manpages.debian.org/stretch/dput-ng/dput.1.en.html
 [6]: /wp-content/uploads/2021/01/image.png
