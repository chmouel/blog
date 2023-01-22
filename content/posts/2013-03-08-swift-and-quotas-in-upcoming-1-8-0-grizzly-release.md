---
title: Swift and quotas in upcoming 1.8.0 (Grizzly) release.
author: chmouel
date: 2013-03-08T20:45:44+00:00
url: /2013/03/08/swift-and-quotas-in-upcoming-1-8-0-grizzly-release/
dsq_thread_id:
  - 1125741716
tags:
  - Cloud

---
There is two new nifty middlewares for doing quotas in upcoming Swift release 1.8.0 called container\_quotas and account\_quotas.

Those are two different middlewares because they are actually addressing different use cases.

container_quotas is typically used by end users the use case here is to let user to specify a limit on one of their container.

Why would you want to restrict yourself you may ask ? This is because when you allow a public upload to a container for example with tempurl or/and formpost you want to make sure people are not uploading a unlimited amount of datas.

The headers to configure for the container quota are :

**X-Container-Meta-Quota-Bytes** - The Maximum size of the container, in bytes.  
**X-Container-Meta-Quota-Count** - Maximum object count of the

The account_quotas is more the typical quota implementation. A "super  
user" with the reselleradmin group/role can set a byte limit for  
an account and the account will not be able to have new  
objects/containers until someone cleanups his account to get under the  
limited quotas.

The headers to configure the account quotas are :

**X-Account-Meta-Quota-Bytes** - The Maximum size of the account in bytes.

The commit for the container quotas is here :

[Basic container quotas][1]

and account quotas commit :

[Account quotas][1]

Enjoy.

 

 [1]: https://github.com/openstack/swift/commit/28c75db0e7103603e89e0a5ba3c32b7505e4d89e