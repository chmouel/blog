---
title: Using python-novaclient against Rackspace Cloud next generation (powered by OpenStack)
author: chmouel
type: post
date: 2012-08-17T10:09:42+00:00
url: /2012/08/17/using-python-novaclient-against-rackspace-cloud-next-generation-powered-by-openstack/
dsq_thread_id:
  - 808748220
tags:
  - Cloud
  - Openstack

---
With the [modular auth plugin system][1] merged into python-novaclient it is now very easy to use nova CLI against the Rackspace Public Cloud powered by OpenStack.

we even have a metapackage that would install all the needed bits. This should be easy as doing this :

<p style="padding-left: 30px;">
  pip install rackspace-novaclient
</p>

and all dependencies and extensions will be installed. To actually use the CLI you just need to specify the right arguments (or via env variable see nova --help) like this :

<p style="padding-left: 30px;">
  nova --os_auth_system rackspace --os_username $USER --os_tenant_name $USER --os_password $KEY
</p>

on RAX cloud, usually the username is the tenant name so this should match.

For the UK Cloud you just need to change the auth\_system to rackspace\_uk like this :

<p style="padding-left: 30px;">
  nova --os_auth_system rackspace_uk --os_username $USER --os_tenant_name $USER --os_password $KEY
</p>

 [1]: https://github.com/openstack/python-novaclient/commit/86c713b17ac8984b54ff767d83ab41037e7a7833