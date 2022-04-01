---
title: Toshiba Regza 32AV615DB blank screen HDMI Linux
author: chmouel
date: 2009-12-03T17:17:19+00:00
url: /2009/12/03/toshiba-regza-32av615db-blank-screen-hdmi-linux/
dsq_thread_id:
  - 254514789
tags:
  - Life
  - Linux

---
I have this nice Toshiba TV which is connected to a small Linux box which act as a media player. I have been some issue lately the things works fine under the 1920x1800 resolution most of the time. But once in a while I get a blank screen and the nvidia driver telling me this :

> (II) Dec 03 17:00:19 NVIDIA(0): "nvidia-auto-select"  
> (II) Dec 03 17:00:19 NVIDIA(0): Virtual screen size determined to be 640 x 480  
> (WW) Dec 03 17:00:19 NVIDIA(0): Unable to get display device CRT-0's EDID; cannot compute DPI  
> (WW) Dec 03 17:00:19 NVIDIA(0): from CRT-0's EDID.  
> (==) Dec 03 17:00:19 NVIDIA(0): DPI set to (75, 75); computed from built-in default  
> (==) Dec 03 17:00:19 NVIDIA(0): Enabling 32-bit ARGB GLX visuals.  
> (--) Depth 24 pixmap format is 32 bpp 

Spend a long time trying to debug the thing by the software but it seems that the TV has some kind of trouble and if I switch it to another HDMI connection it does detect fine which I do at about every week... not a biggie but still annoying.