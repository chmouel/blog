---
title: Upload to OpenStack Swift via CORS/HTML5 request.
author: chmouel
date: 2013-02-01T12:06:23+00:00
url: /2013/02/01/swift-with-cors-request/
dsq_thread_id:
  - 1058883420
tags:
  - Openstack

---
One of our client at [eNovance][1] had a need to be able to upload to Swift directly from a web browser without going via a PHP proxy.

Things in browser-land are not exactly the same as what we have in user-land, it is a bit more restricted to ensure the end-user security and there is a few hoops to jump through to get it working.

To be able to do a xmlrpc upload to another server (swift in this case) there is a 'standard/recommendation' document made by W3C about it located here :

<http://www.w3.org/TR/2013/CR-cors-20130129/>

Basically what happen when in Javascript we do :


```javascript
request.open("POST", "http://swift/AUTH_account/container/");
request.setRequestHeader('X-Auth-Token', myToken);
request.send();
```


The browser just before the request will send an OPTIONS request to check with the server if the request is allowed by the server. This look like this when uploading to Swift :

<p style="text-align: center;">
  <a href="/wp-content/uploads/2013/02/Screen-Shot-2013-02-01-at-12.29.50.png"><img loading="lazy" class="aligncenter  wp-image-575" alt="Screen Shot 2013-02-01 at 12.29.50" src="/wp-content/uploads/2013/02/Screen-Shot-2013-02-01-at-12.29.50.png" width="678" height="459" srcset="https://blog.chmouel.com/wp-content/uploads/2013/02/Screen-Shot-2013-02-01-at-12.29.50.png 968w, https://blog.chmouel.com/wp-content/uploads/2013/02/Screen-Shot-2013-02-01-at-12.29.50-300x203.png 300w" sizes="(max-width: 678px) 100vw, 678px" /></a>
</p>

The Options request that the browser does is literally asking for the server (swift) to know if this domain where it's uploading from is allowed to upload directly via xmlrpc. The request looks like this :

<p style="text-align: left;">
  <a href="/wp-content/uploads/2013/02/Screen-Shot-2013-02-01-at-12.39.50.png"><img loading="lazy" class="aligncenter  wp-image-576" alt="Screen Shot 2013-02-01 at 12.39.50" src="/wp-content/uploads/2013/02/Screen-Shot-2013-02-01-at-12.39.50.png" width="564" height="340" srcset="/wp-content/uploads/2013/02/Screen-Shot-2013-02-01-at-12.39.50.png 806w, /wp-content/uploads/2013/02/Screen-Shot-2013-02-01-at-12.39.50-300x180.png 300w" sizes="(max-width: 564px) 100vw, 564px" /></a>It says, hello there: my Origin: is this IP and I want to be able to access with this method 'PUT', can I do it ? The server will reply something along (if it's allowed), yeah sure please feel free to send this headers along and those methods and Origin are actually what I am allowing.
</p>

Thanks to the work of [Adrian Smith][2] this is supported since Swift version 1.7.5 (and improved in 1.7.6), you can do  at server level config or with headers on container easily see the full detailled documentation here:

<http://docs.openstack.org/developer/swift/cors.html>

While working on this I could not find a clear example to test it, I only found a great article on this page :

[http://www.ioncannon.net/programming/1539/direct-browser-uploading-amazon-s3-cors-fileapi-xhr2-and-signed-puts/][3]

that was targetted to amazon s3 and I adapted it to use with OpenStack Swift.

You can find it here and use it as an example for your application :

<https://github.com/chmouel/cors-swift-example>

 [1]: http://enovance.com
 [2]: http://www.17od.com/
 [3]: ttp://www.ioncannon.net/programming/1539/direct-browser-uploading-amazon-s3-cors-fileapi-xhr2-and-signed-puts/
