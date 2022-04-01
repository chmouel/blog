---
title: Howto use backtrack4 from hard disk with Grub2
author: chmouel
date: 2010-03-08T12:00:18+00:00
url: /2010/03/08/howto-use-backtrack4-from-hard-disk-with-grub2/
dsq_thread_id:
  - 252039410
tags:
  - Linux

---
If you want to boot backtrack4 from time to time on your Linux desktop/laptop but don't want to carry it on a USB drive (or CDROM) on you then this guide may help.

I am using Debian unstable on my laptop but I am sure you can adapt it to anything you want. I am using another partition (/dev/sda6) as my backtrack partition but it's possible to copy the full thing in / as well on your main partition.

Download backtrack4 from backtrack website :

<http://www.backtrack-linux.org/downloads/>

  * mount the iso image locally :

> sudo mount -o loop bt4-final.iso /mnt

  * copy the content of the iso to the root of the chosen partition (mounted in /media/part6 for me) :

> cd /mnt;sudo rsync --progress -avu * /media/part6/

  * Configure grub :

> sudo su -  
> cat < /etc/grub.d/50_Backtrack  
> #!/bin/sh  
> exec tail -n +3 $0  
> menuentry "Backtrack" {  
> linux (hd0,6)/boot/vmlinuz BOOT=casper boot=casper nopersistent rw quiet vga=0x317  
> initrd (hd0,6)/boot/initrd.gz  
> }  
> EOF  
> chmod +x /etc/grub.d/50_Backtrack

  * Update grub

> sudo update-grub

And you should be able to boot the Backtrack menu, make sure this point to the right partition for me it's (hd0,6) because my backtrack copied CD is on /dev/sda6 but your mileage may differ.