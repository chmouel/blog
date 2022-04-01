---
title: Accessing to Rackspace Cloud Files via servicenet (update)
author: chmouel
date: 2009-10-20T18:47:49+00:00
url: /2009/10/20/accessing-to-rackspace-cloud-files-via-servicenet-update/
dsq_thread_id:
  - 252364214
tags:
  - Programming
  - Python
  - Rackspace

---
Last week I have posted an article explaining how to connect to Rackspace Cloud Files via Rackspace ServiceNET but I actually got it wrong as pointed by my great colleague [exlt][1] so I had to take it down until figured out how to fix it.

I have add that feature properly to the PHP and Python API in version 1.5.0 to add a 'servicenet' argument to the connection and updated the blog post here :

[https://blog.chmouel.com/2009/10/14/how-to-connect-to-rackspace-cloud-files-via-servicenet/  
][2]  
It should give you all the information for the howto use that feature.

I have released as well a minor update in 1.5.1 to allow you to define the environment variable RACKSPACE_SERVICENET to force the use of the Rackspace ServiceNET this allow you to don't have to modify the tools and have a clean code between prod and testing.

 [1]: http://12.am/
 [2]: https://blog.chmouel.com/2009/10/14/how-to-connect-to-rackspace-cloud-files-via-servicenet/