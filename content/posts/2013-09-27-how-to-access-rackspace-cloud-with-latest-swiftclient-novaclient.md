---
title: How to access Rackspace Cloud with latest novaclient/swiftclient
author: chmouel
date: 2013-09-27T03:50:51+00:00
url: /2013/09/27/how-to-access-rackspace-cloud-with-latest-swiftclient-novaclient/
dsq_thread_id:
  - 1800930423
tags:
  - Openstack
  - Rackspace

---
I spent too much time trying to figure out how to use the latest swiftclient/novaclient with Rackspace Cloud that I thought I would have to document it somewhere to avoid the pain for others.

Assuming you don't want to use [pyrax][1] and no [OS\_AUTH\_SYSTEM][2] plugin but just pure OpenStack python-novaclient/swiftclient on Rackspace cloud then you just need to export those variables in your shell :


```sh
export OS_REGION_NAME=ORD
export OS_USERNAME=username
export OS_TENANT_NAME=" "
export OS_PASSWORD=password
export OS_AUTH_URL=https://identity.api.rackspacecloud.com/v2.0/

```


so now the region is ORD here (Chicago) but this can be SYD/IAD/DFW or whatever new datacenter/region from Rackspace. If you wanted to use the UK region you would need **another** username/password which is tighted to the LON datacenter (yes that's an another legacy weirdness).

In your username and password set your real username and password the one you use to log into the control panel **not the API Keys** since the API key is a RAX extension of their Keystone implementation.

And for the real trick of the day here is to set export OS\_TENANT\_NAME=" " (yes that's a space inside) because the behaviour of the identity on Rackspace Cloud is a bit weird (from what I understand username is the first class citizen and tenant_name is binded to a service) you **don't** want to set a TENANT_NAME so we set a space (just empty does not work) and the service would just strip it and not set it to get our full service catalog and happily use our pure OpenStack nova or swift client

 [1]: https://github.com/rackspace/pyrax
 [2]: https://blog.chmouel.com/2012/08/17/using-python-novaclient-against-rackspace-cloud-next-generation-powered-by-openstack/