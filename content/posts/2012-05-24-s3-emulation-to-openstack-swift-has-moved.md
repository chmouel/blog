---
title: S3 emulation to OpenStack Swift has moved
author: chmouel
type: post
date: 2012-05-24T15:09:59+00:00
url: /2012/05/24/s3-emulation-to-openstack-swift-has-moved/
dsq_thread_id:
  - 702196779
tags:
  - Openstack

---
A little note about swift3 the S3 emulation layer to OpenStack Swift

As from this [review][1] we have removed it from Swift since the decision[1] was made that only the official OpenStack API would be supported in Swift. The development will be continued in fujita's repository on github at this URL :

<https://github.com/fujita/swift3>

Feel free to grab the middle-ware or report issue from fujita's repository.

[1] Globally for OpenStack not just for Swift.

 [1]: https://review.openstack.org/#/c/7628/