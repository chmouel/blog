---
title: 'Quick Swift Tip: How to remove a header with Curl'
author: chmouel
type: post
date: 2013-07-17T10:07:50+00:00
url: /2013/07/17/quick-swift-tip-how-to-remove-a-header-with-curl/
dsq_thread_id:
  - 1506099799
tags:
  - Openstack

---
curl is obviously an extremely popular way to experiment a REST API. Unfortunately one of its shortcoming is not able to remove a custom header but just to modify or add it. In swift if you prefix your Meta header with **X-remove** it would then just do that and remove the header. 

For example when I wanted to remove the [account quota][1] header from an account with a reseller admin token I had just to do that :

`curl -X POST -H 'X-Remove-Account-Meta-Quota-Bytes: 0' -H "x-auth-token: ${RESELLER_TOKEN}" http://localhost:8080/v1/AUTH_accountId`

and the **X-Account-Meta-Quota-Bytes** header was removed.

 [1]: https://blog.chmouel.com/2013/03/08/swift-and-quotas-in-upcoming-1-8-0-grizzly-release/