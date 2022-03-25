---
title: swift.common.client library and swift CLI has moved to its own project
author: chmouel
type: post
date: 2012-06-13T12:50:56+00:00
url: /2012/06/13/swift-common-client-library-and-swift-cli-has-moved-to-its-own-project/
dsq_thread_id:
  - 724244723
tags:
  - Openstack

---
Historically if you wanted to write software in python against OpenStack swift, people would have use the python-cloudfiles library or swift.common.client shipped with Swift.

[python-cloudfiles][1] was made mostly for Rackspace CloudFiles before even Swift existed and does a lot of extra stuff not needed for OpenStack Swift (i.e: CDN).

swift.common.client was designed for OpenStack Swift from the ground up but is included with Swift which made people having to download the full Swift repository if they wanted to use or tests against it. (i.e: OpenStack glance).

As yesterday we have now removed swift.common.client wth the bin/swift CLI and moved it to its own repository available here :

[https://github.com/openstack/python-swiftclient][2]

This should be compatible with swift.common.client with only difference being to import swiftclient instead of importing swift.common.client

At this time we are using the same launchpad project as swift so feel free to send bugs/feature request under the swift  project in launchpad :

<https://bugs.launchpad.net/swift/+filebug>

and add the tag python-swiftclient there.

 [1]: https://github.com/rackspace/python-cloudfiles
 [2]: https://github.com/chmouel/python-swiftclient