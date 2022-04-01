---
title: Vmware vmplayer and kernel 2.6.32
author: chmouel
date: 2009-12-05T01:35:01+00:00
url: /2009/12/05/vmware-vmplayer-and-kernel-2-6-32/
dsq_thread_id:
  - 252800666
tags:
  - Linux

---
So you have a shiny new linux-2.6.32 kernel installed but your VMPlayer does not work anymore since the vmnet module does not compile by throwing this error :

> CC [M] /tmp/vmware-root/modules/vmnet-only/vnetEvent.o  
> CC [M] /tmp/vmware-root/modules/vmnet-only/vnetUserListener.o  
> /tmp/vmware-root/modules/vmnet-only/vnetUserListener.c: In function â€˜VNetUserListenerEventHandlerâ€™:  
> /tmp/vmware-root/modules/vmnet-only/vnetUserListener.c:240: error: â€˜TASK_INTERRUPTIBLEâ€™ undeclared (first use in this function)  
> /tmp/vmware-root/modules/vmnet-only/vnetUserListener.c:240: error: (Each undeclared identifier is reported only once  
> /tmp/vmware-root/modules/vmnet-only/vnetUserListener.c:240: error: for each function it appears in.)  
> /tmp/vmware-root/modules/vmnet-only/vnetUserListener.c: In function â€˜VNetUserListenerReadâ€™:  
> /tmp/vmware-root/modules/vmnet-only/vnetUserListener.c:282: error: â€˜TASK_INTERRUPTIBLEâ€™ undeclared (first use in this function)  
> /tmp/vmware-root/modules/vmnet-only/vnetUserListener.c:282: error: implicit declaration of function â€˜signal_pendingâ€™  
> /tmp/vmware-root/modules/vmnet-only/vnetUserListener.c:282: error: implicit declaration of function â€˜scheduleâ€™  
> make[2]: \*** [/tmp/vmware-root/modules/vmnet-only/vnetUserListener.o] Error 1  
> make[1]: \*** [\_module\_/tmp/vmware-root/modules/vmnet-only] Error 2  
> make[1]: Leaving directory \`/opt/temp/linux-2.6.32'  
> make: \*** [vmnet.ko] Error 2

Just do the following to fix it :

make sure first you have installed the latest vmplayer (VMware-Player-3.0.0-203739.i386.bundle) at this time for me.

  * cd /tmp

  * tar xf /usr/lib/vmware/modules/source/vmnet.tar

  * cd vmnet-only

  * vim vnetUserListener.c

  * go to line 37 (after the last include)

  * add this line #include "compat_sched.h"

  * exit your editor

  * cd /tmp

  * sudo tar cf /usr/lib/vmware/modules/source/vmnet.tar vmnet-only

  * restart vmplayer

When recompiling the kernel module it should get it built properly and working it seems.....