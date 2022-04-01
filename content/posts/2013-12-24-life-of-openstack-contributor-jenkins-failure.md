---
title: The life of an OpenStack contributor checking for Jenkins failures
author: chmouel
date: 2013-12-24T20:36:40+00:00
url: /2013/12/24/life-of-openstack-contributor-jenkins-failure/
dsq_thread_id:
  - 2071331389
tags:
  - Openstack

---
We have all been there, we are committing a two character change in a project and send our review all happy and dandy with the review tool full of hope that our change is rock solid :

![](/wp-content/uploads/2013/12/Screenshot-2013-12-24-20.33.54.png)

You now that a two character change cannot fail. This is a tiny change in some arcane part of the [Swift][2] code that can never get passed by the tests launched in Jenkins and should just be a straightforward commit.

You are still anxious to see how it goes, so we fire our web browser and go to that beautiful page setup by our [infra team][3] and like that guy watching the tiny greeen progress bar hoping, well.. that it's stay green :

![](/wp-content/uploads/2013/12/stewart.gif)

You'd think to don't have to stress and you that you can just let it go do its job.

But after a couple of minutes (and that's if you are lucky) you are receiving an email from jenkins stating that the "Build has failed"? And this is where you start to feel like this guy thinking WHAT HAVE I DONE :

![](/wp-content/uploads/2013/12/whathaveidone.gif)

![](/wp-content/uploads/2013/12/Screenshot-2013-12-24-20.51.56.png)
There is a handy link near the failure giving you the full log in the console.html file there. But digging into that log is like looking for a needle in a haystack, you are spending at least at most 5 minutes looking for a FAIL until if you are lucky it finally popping up in front of your face :

![](/wp-content/uploads/2013/12/haystack.gif)

So now that you went by that effort you need to match the <span style="color: #ff0000;">FAILURE</span> to a real bug. Armed with your web browser you get into the recheck page <http://status.openstack.org/rechecks/> where you start hitting furiously your âŒ˜-F or Control-F key shortcut hoping to match to an existing bug report.

![](/wp-content/uploads/2013/12/computing.gif)

To be honest, it doesn't have to be so tedious. Since I like to save my time for stuff like browsing the internet for [OpenStack reactions][9] gifs, I just automate the thing.

I start to curl the console output of the failed job :

![](/wp-content/uploads/2013/12/Screenshot-2013-12-24-21.18.33.png)

and just use my trusty grep to grep the FAIL :

![](/wp-content/uploads/2013/12/Screenshot-2013-12-24-21.20.09.png)

I can just now go to the launchpad bug search page on <https://bugs.launchpad.net/> and just type the failed test in the search box to look for that bug :

![](/wp-content/uploads/2013/12/Screenshot-2013-12-24-21.23.20.png)

and just hit the _recheck bug bugnumber_ in the review box :

![](/wp-content/uploads/2013/12/yeehaw.gif.pagespeed.ce_.QK5Sy5pVZh.gif)

_PS: Go watch [Sean Dague][15] excellent summit talk:  [Jenkins Failed My Patch, What Do I Do.][16]_

 [1]: /wp-content/uploads/2013/12/Screenshot-2013-12-24-20.33.54.png
 [2]: http://swift.openstack.org/
 [3]: http://openstackreactions.enovance.com/2013/08/the-way-i-see-the-openstack-infra-team/
 [4]: /wp-content/uploads/2013/12/stewart.gif
 [5]: /wp-content/uploads/2013/12/whathaveidone.gif
 [6]: /wp-content/uploads/2013/12/Screenshot-2013-12-24-20.51.56.png
 [7]: /wp-content/uploads/2013/12/haystack.gif
 [8]: /wp-content/uploads/2013/12/computing.gif
 [9]: http://openstackreactions.enovance.com/
 [10]: /wp-content/uploads/2013/12/Screenshot-2013-12-24-21.18.33.png
 [11]: /wp-content/uploads/2013/12/Screenshot-2013-12-24-21.20.09.png
 [12]: /wp-content/uploads/2013/12/Screenshot-2013-12-24-21.23.20.png
 [13]: /wp-content/uploads/2013/12/Screenshot-2013-12-25-01.08.48.png
 [14]: /wp-content/uploads/2013/12/yeehaw.gif.pagespeed.ce_.QK5Sy5pVZh.gif
 [15]: http://twitter.com/sdague
 [16]: https://www.youtube.com/watch?v=qrzFuYyr8c4
