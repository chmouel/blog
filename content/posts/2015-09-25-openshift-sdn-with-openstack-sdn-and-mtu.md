---
title: openshift-sdn with OpenStack SDN and MTU
author: chmouel
date: 2015-09-25T14:16:12+00:00
url: /2015/09/25/openshift-sdn-with-openstack-sdn-and-mtu/
dsq_thread_id:
  - 4164919665
tags:
  - OpenShift

---
I am lucky enough to have a cloud available to me for free it obviously runs OpenStack and I can kick VM like I want.

Since I am playing with OpenShift a lot lately I have seen issues in that cloud where pushing an image to the internal registry was just randomly failing.

Networking is definitely not my pedigree but I could definitely sense it was a networking issue. Since I could nost just blame the underlying cloud (hey it's free!) I had to investigate a bit.

Using the "[access to internal docker registry][1]" feature of OpenShift, I could definitively push from the master (where the registry was) in 2s but not from the node where it was completely stucks at the end while it could only push some bits at first and after waiting forever there.

I came back to our internal mailing list and the local experts there pointed me to the file :


```
/etc/sysconfig/openshift-node

```


and the interesting part is this :


```
# The $DOCKER_NETWORK_OPTIONS variable is used by sdn plugins to set
# $DOCKER_NETWORK_OPTIONS variable in the /etc/sysconfig/docker-network
# Most plugins include their own defaults within the scripts
# TODO: More elegant solution like this
# https://github.com/coreos/flannel/blob/master/dist/mk-docker-opts.sh
# DOCKER_NETWORK_OPTIONS='-b=lbr0 --mtu=1450'

```


I uncommented and adjusted my MTU to 1400 since 1450 wasn't working for me and after a reboot I could push properly my images from the nodes to the internal registry.

_Thanks to [sdodson][2] and [Erik][3] for pointing me to this_

 [1]: https://docs.openshift.com/enterprise/3.0/install_config/install/docker_registry.html#access
 [2]: https://twitter.com/sdodson
 [3]: https://twitter.com/ErikonOpen
