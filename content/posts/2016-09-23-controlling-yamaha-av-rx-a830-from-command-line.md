---
title: Controlling Yamaha AV RX-A830 from command line
author: chmouel
date: 2016-09-23T09:06:25+00:00
url: /2016/09/23/controlling-yamaha-av-rx-a830-from-command-line/
---
At home I have been using a [Yamaha AV RX-A380][1], it's an home teather audio video solution where you can plug about everything you need (like 7 hdmi channel, spoiler alert there is something wrong with you if you have that many devices) and output to two other hdmi channel (like a tv and a projector).

It has integration for spotify, airplay, netradio and billions of connection to everything, just look at the damn back of this device :

[<img loading="lazy" class="aligncenter wp-image-1031 size-full" src="/wp-content/uploads/2016/09/yamaha.jpg" width="1050" height="525" srcset="https://blog.chmouel.com/wp-content/uploads/2016/09/yamaha.jpg 1050w, https://blog.chmouel.com/wp-content/uploads/2016/09/yamaha-300x150.jpg 300w, https://blog.chmouel.com/wp-content/uploads/2016/09/yamaha-768x384.jpg 768w, https://blog.chmouel.com/wp-content/uploads/2016/09/yamaha-1024x512.jpg 1024w" sizes="(max-width: 1050px) 100vw, 1050px" />][2]Since I wanted to control it from the command line to automate it for home automation, I firebugged the web interface and reversed some of the REST calls in a nice bash script.

Here it is at your convenience to using or hack it :

This doesn't support multi-zone and assume the web interface is resolvable to <http://yamaha.local/> (it should be by default) so be aware. This may support other Yamaha AV devices but since I don't have it I can't say and you may have try, if it does kindly add a comment here soother would know :)

 [1]: https://www.amazon.com/Yamaha-RX-A830-7-2-Channel-AVENTAGE-Receiver/dp/B00BQHCCQQ
 [2]: /wp-content/uploads/2016/09/yamaha.jpg
