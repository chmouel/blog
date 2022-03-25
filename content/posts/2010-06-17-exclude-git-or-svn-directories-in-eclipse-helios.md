---
title: Exclude .git or .svn directories in Eclipse (Helios)
author: chmouel
type: post
date: 2010-06-17T04:48:42+00:00
url: /2010/06/17/exclude-git-or-svn-directories-in-eclipse-helios/
dsq_thread_id:
  - 253620398
tags:
  - Eclipse
  - Java

---
If  you are using Ctrl+Shift+T in Eclipse and have .git or .svn directory showing up it is easy to fix it without having to use another plugin for eclipse like subeclipse or egit.

Open the Properties of your project go to _Resource_=>_Resource Filters_ and click on Add to add a new filter.

Now just do like this ScreenShot :

<figure id="attachment_314" aria-describedby="caption-attachment-314" style="width: 521px" class="wp-caption aligncenter">[<img loading="lazy" class="size-full wp-image-314 " title="Edit Resource Filter" src="/wp-content/uploads/2010/06/EditResourceFilter.png" alt="Edit Resource Filter for .svn or .git exclude" width="521" height="409" srcset="https://blog.chmouel.com/wp-content/uploads/2010/06/EditResourceFilter.png 651w, https://blog.chmouel.com/wp-content/uploads/2010/06/EditResourceFilter-300x235.png 300w" sizes="(max-width: 521px) 100vw, 521px" />][1]<figcaption id="caption-attachment-314" class="wp-caption-text">Edit Resource Filter for .svn or .git exclude</figcaption></figure>

Change the \*.git\* to \*.svn\* if you like for subversion.

 [1]: /wp-content/uploads/2010/06/EditResourceFilter.png