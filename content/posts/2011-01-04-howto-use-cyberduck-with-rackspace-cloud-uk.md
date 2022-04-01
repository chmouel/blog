---
title: Howto use Cyberduck with Rackspace Cloud UK
author: chmouel
date: 2011-01-04T15:04:36+00:00
url: /2011/01/04/howto-use-cyberduck-with-rackspace-cloud-uk/
dsq_thread_id:
  - 252101045
tags:
  - Cloud
  - Rackspace

---
If you are wondering howto use a graphical client like Cyberduck to access the Rackspace Cloud UK this is how you do it. We are going to use the Swift OpenStack support in Cyberduck to access the UK CloudFiles instance.

You first Open Cyberduck and Click on open connection :

[<img loading="lazy" src="/wp-content/uploads/2011/01/Open-Window-300x257.png" alt="" title="Open Cyberduck" width="300" height="257" class="aligncenter size-medium wp-image-384" srcset="https://blog.chmouel.com/wp-content/uploads/2011/01/Open-Window-300x257.png 300w, https://blog.chmouel.com/wp-content/uploads/2011/01/Open-Window.png 678w" sizes="(max-width: 300px) 100vw, 300px" />][1]

In the Menu choose Swift (OpenStack Object Storage) and in Server field you specify :

lon.auth.api.rackspacecloud.com

and enter your Username and Api Key (in Password field) :

[<img loading="lazy" src="/wp-content/uploads/2011/01/New-Connection-300x246.png" alt="" title="Create a new connection" width="300" height="246" class="aligncenter size-medium wp-image-383" srcset="https://blog.chmouel.com/wp-content/uploads/2011/01/New-Connection-300x246.png 300w, https://blog.chmouel.com/wp-content/uploads/2011/01/New-Connection.png 746w" sizes="(max-width: 300px) 100vw, 300px" />][2]

You should just be able to press connect to get going, if it is asking for a Password again in the next screen (which is to store in your Apple Keychain) just specify your API Key again in there.

 [1]: /wp-content/uploads/2011/01/Open-Window.png
 [2]: /wp-content/uploads/2011/01/New-Connection.png