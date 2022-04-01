---
title: How to view openshift router (haproxy) stats
author: chmouel
date: 2016-09-27T11:01:51+00:00
url: /2016/09/27/how-to-view-openshift-haproxy-stats/
---
After you have installed your fancy openshift install and that it kicked the haproxy router automatically after install you may want to see the stats of the router.

The HAproxy stats are exposed on the port 1936 where the router is located (usually on the master node) so first you need a way to access it. You can open it via your firewall (not ideal) or you can just port forward the port to your workstation via SSH :

```console
ssh -L 1936:localhost:1936 master.openshift
```

 Now that it's done and you have 1936 tunelled you need to figure out the password of the haproxy stats. It's stored in its environment variables so you just do a oc describe to see it for example :

![](/wp-content/uploads/2016/09/2016-09-27__12-58-57-15400.png)

Now that you have the password (uo5LtC6mac in my case), you just point your workstation web browser to :

<http://admin:password@localhost:1936>

just make sure to replace the password with your own password and you should be all set.

![](/wp-content/uploads/2016/09/2016-09-27__13-01-20-4942.png)
