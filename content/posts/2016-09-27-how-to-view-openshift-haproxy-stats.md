---
title: How to view openshift router (haproxy) stats
author: chmouel
date: 2016-09-27T11:01:51+00:00
url: /2016/09/27/how-to-view-openshift-haproxy-stats/
---
After you have installed your fancy openshift install and that it kicked the haproxy router automatically after install you may want to see the stats of the router.

The HAproxy stats are exposed on the port 1936 where the router is located (usually on the master node) so first you need a way to access it. You can open it via your firewall (not ideal) or you can just port forward the port to your workstation via SSH :

<p style="padding-left: 30px;">
  $ ssh -L 1936:localhost:1936 master.openshift
</p>

<p style="text-align: left;">
  Now that it's done and you have 1936 tunelled you need to figure out the password of the haproxy stats. It's stored in its environment variables so you just do a oc describe to see it for example :
</p>

<p style="text-align: left;">
  <a href="/wp-content/uploads/2016/09/2016-09-27__12-58-57-15400.png"><img loading="lazy" class="aligncenter size-full wp-image-1037" src="https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__12-58-57-15400.png" alt="2016-09-27__12-58-57-15400" width="1266" height="248" srcset="https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__12-58-57-15400.png 1266w, https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__12-58-57-15400-300x59.png 300w, https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__12-58-57-15400-768x150.png 768w, https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__12-58-57-15400-1024x201.png 1024w" sizes="(max-width: 1266px) 100vw, 1266px" /></a>
</p>

<p style="text-align: left;">
  Now that you have the password (uo5LtC6mac in my case), you just point your workstation web browser to :
</p>

<p style="text-align: left; padding-left: 30px;">
  <a href="http://admin:password@localhost:1936">http://admin:password@localhost:1936</a>
</p>

<p style="text-align: left;">
  just make sure to replace the password with your own password and you should be all set.
</p>

<p style="text-align: left;">
  <a href="/wp-content/uploads/2016/09/2016-09-27__13-01-20-4942.png"><img loading="lazy" class="aligncenter size-full wp-image-1038" src="https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__13-01-20-4942.png" alt="2016-09-27__13-01-20-4942" width="2728" height="1336" srcset="https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__13-01-20-4942.png 2728w, https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__13-01-20-4942-300x147.png 300w, https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__13-01-20-4942-768x376.png 768w, https://blog.chmouel.com/wp-content/uploads/2016/09/2016-09-27__13-01-20-4942-1024x501.png 1024w" sizes="(max-width: 2728px) 100vw, 2728px" /></a>
</p>
