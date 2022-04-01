---
title: Debian Lenny on Dell Optiplex 760
author: chmouel
date: 2009-06-16T21:15:30+00:00
url: /2009/06/16/debian-lenny-on-dell-optiflex-760/
dsq_thread_id:
  - 252039372
tags:
  - Debian

---
So if you get that shiny new Dell desktop and ACPI spit bunch of message at the install time and the network driver does not get detected you can follow these steps to have it working.

- Continue the install without the network until you reboot to grub.

- Add hpet=disable at the end of the boot kernel parameter and get into the system.

- Download the latest kernel for your architecture on :

<http://kernel-archive.buildserver.net/debian-kernel/pool/main/l/linux-2.6/>

- Transfer it on a USB key and dpkg -i it.

- Make sure you add the hpet=disable at the kopt option of /boot/grub/menu.lst and launch a update-grub.

- On reboot you should now have the network you can do the standard tasksel to install a Desktop etc....