---
title: How to launch the Swift functional test suite with Keystone
author: chmouel
date: 2013-06-14T15:46:19+00:00
url: /2013/06/14/how-to-launch-the-swift-functional-test-suite-with-keystone/
dsq_thread_id:
  - 1401546245
tags:
  - Keystone
  - Openstack

---
It is easy to launch the swift functional tests with v2 auth (Keystone). 

Assuming you have a recent version of python-swiftclient, python-keystoneclient and swift you need to first add a few users which is easily done with this script :



Assuming you have already your OS_* variables configured with an admin, you can just launch it and it will :

  * add a tenant/user named test/tester.
  * add a tenant/user name test2/tester2.
  * add a user tester3 belonging to test2 but not operator on that tenant.

and it will create a /etc/swift/swift.conf for testing. You can adjust the keystone host in auth_host there (default to 127.0.0.1)

You can now just go to your swift directory and launch the script :


```
$ ./.functests

```


and the functional tests will run against a keystone server (or a auth v2 api compatible server).