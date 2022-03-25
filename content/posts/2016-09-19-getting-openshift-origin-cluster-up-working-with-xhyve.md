---
title: Getting openshift origin “cluster up” working with xhyve
author: chmouel
date: 2016-09-19T06:00:54+00:00
url: /2016/09/19/getting-openshift-origin-cluster-up-working-with-xhyve/
tags:
  - OpenShift

---
In latest openshift client (oc) there is a nifty (relatively) new feature to get you a OpenShift cluster starting (very) quickly. It's a pretty nice way to get you a new openshift origin environment on your laptop  without the hassle.

On macosx there is a (as well relatively) new lightweight virtualization solution called [xhyve][1] it's a bit like KVM in the sense of being lightweight and does not need like virtualbox or vmware to get a UI running. It seemed to be a perfect fit to try those two together.

xhyve docker machine driver needed to be installed first so I just went on its website here :

<https://github.com/zchee/docker-machine-driver-xhyve>

and followed the installation instruction from the README which I could see everything was working :

![](/wp-content/uploads/2016/09/2016-09-18__21-27-28-10262.png)

I then fired up the "oc cluster up --create-machine" command and to my disappointment it was starting by default the virtualbox and I could not see anything in the options how to specify the "--driver xhyve" option to docker-machine which is what the oc cluster feature is using on the backend to bootstrap a docker environment.

Digging into the code it seems that the oc cluster has those feature set in static as virtualbox :

<https://github.com/openshift/origin/blob/85eb37b34f0657631592356d020cef5a58470f8e/pkg/bootstrap/docker/dockermachine/helper.go#L56-L79>

since there was no way to pass other options I first looked in the github issues to see if there was nothing reported about it and sent a feature request [here][3],

I started to think a little bit more about a workaround going from modifying to my liking and recompiling the oc client or to just give up on xhyve but in fact the solution is actually much simplier.

Since there is the ability to specify to "oc cluster up" an already configured docker-machine environment with the " --docker-machine" option. We just had to configured previously properly first (which is with the option --engine-insecure-registry 172.30.0.0/16) :

![](/wp-content/uploads/2016/09/2016-09-18__21-05-12-14647.png)

and after a bit the new docker should be setup which can be easily used with the command eval $(docker-machine env xhyve)

I then just have to start my oc cluster up with the option  --docker-machine="xhyve" and I would get my nicely setuped openshift origin cluster to play with in mere seconds :

![](/wp-content/uploads/2016/09/2016-09-18__21-04-47-3802.png)

 [1]: https://github.com/mist64/xhyve
 [2]: /wp-content/uploads/2016/09/2016-09-18__21-27-28-10262.png
 [3]: https://github.com/openshift/origin/issues/10982
 [4]: /wp-content/uploads/2016/09/2016-09-18__21-05-12-14647.png
 [5]: /wp-content/uploads/2016/09/2016-09-18__21-04-47-3802.png
