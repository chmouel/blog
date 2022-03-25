---
title: Easily test your OpenShift applications exposed by the router
author: chmouel
date: 2016-09-28T11:43:49+00:00
url: /2016/09/28/easily-test-your-openshift-applications-exposed-by-the-router/
---
OpenShift integrate[1] a router based on HAproxy to expose your services to the outside world. Whenever your do a :

<p style="padding-left: 30px;">
  oc expose servicename
</p>

it would expose by default the servicename this URL :

<p style="padding-left: 30px;">
  <strong><em>servicename</em></strong><em>-<strong><span style="color: #ff6600;">projectname</span>.<span style="color: #33cccc;">defaultSubDomain</span></strong></em>
</p>

<span style="color: #000000;">The defaultSubdomain is usually a <a href="https://en.wikipedia.org/wiki/Wildcard_DNS_record">wildcard DNS record</a> that you have configured in your domain server by your system administrator. </span>

Now for your openshift testing if you don't want to ask your system administrator to configure a new CNAME going to your testing environement you can just use the free service [xp.io][1]

The XP.IO service is a special DNS service which would take a an IP address and xp.io and report back the IP of this IP address to itself and to all subdomain so that the IP:

<p style="padding-left: 30px;">
  blah.1.2.3.4.xp.io
</p>

will go to 1.2.3.4 same goes for foo.1.2.3.4, bar.1.2.3.4 etc...

You just then need to configure it in OpenShift by editing the value (assuming 1.2.3.4 is your public IP which come back to your router) :

```yaml
routingConfig:
subdomain: "1.2.3.4.xip.io"
```


Or if you use the openshift-ansible scripts to add this your /etc/ansible/hosts

<p style="padding-left: 30px;">
  osm_default_subdomain=1.2.3.4.xip.io
</p>

and then you get all your route exposed properly without bother your always busy system admin.

[1] Which lately got merged into kubernetes as the "[ingress][2]" feature

 [1]: http://xp.io
 [2]: http://kubernetes.io/docs/user-guide/ingress/
