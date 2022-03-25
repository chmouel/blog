---
title: Automatic best resolution with xrandr
author: chmouel
type: post
date: 2007-07-31T22:23:32+00:00
url: /2007/07/31/automatic-best-resolution-with-xrandr/
dsq_thread_id:
  - 253934881
tags:
  - Life
  - Scripts

---
If you like me you have a big screen with your laptop and wants to automate when your X session start to get the best resolution, you can use that script :

[code lang="bash"]  
#!/bin/bash

function get_resolutions() {  
xrandr|while read -a line;do  
RES="${line[1]}x${line[3]} "  
[[ ${RES} != [0-9]* ]] && continue  
echo ${RES}  
done  
}

\_BEST\_RES=0  
BEST_RES=  
for res in $(get_resolutions);do  
_res=${res/x/}  
[[ $\_res -ge ${\_BEST_RES} ]] && {  
BEST_RES=${res}  
\_BEST\_RES=${_res}  
}  
done  
xrandr -s ${BEST_RES}  
[/code]