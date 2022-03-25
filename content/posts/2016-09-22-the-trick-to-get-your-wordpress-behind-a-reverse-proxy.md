---
title: The trick to get your wordpress behind a reverse proxy
author: chmouel
date: 2016-09-22T10:27:27+00:00
url: /2016/09/22/the-trick-to-get-your-wordpress-behind-a-reverse-proxy/
tags:
  - Misc
  - Programming
  - Scripts

---
I have been meaning to get this blog SSL protected for a while and since solution like [letsencrypt][1] makes it easy I have generated some SSL keys for my domain  and configured it in apache.

So far so good, but the thing is my VM at my hosting provider is pretty small and I have been using [varnish][2] for quite some time or I would get out of memory quickly some the kernel OOM killer kicking[1] it.

Varnish don't do SSL so you have to do something else, I went ahead and used Nginx to provide my SSL endpoint which then would look like this :

[<img loading="lazy" class="aligncenter size-full wp-image-1019" src="/wp-content/uploads/2016/09/NGINX-Varnish-Apache.png" alt="nginx-varnish-apache" width="960" height="720" srcset="https://blog.chmouel.com/wp-content/uploads/2016/09/NGINX-Varnish-Apache.png 960w, https://blog.chmouel.com/wp-content/uploads/2016/09/NGINX-Varnish-Apache-300x225.png 300w, https://blog.chmouel.com/wp-content/uploads/2016/09/NGINX-Varnish-Apache-768x576.png 768w" sizes="(max-width: 960px) 100vw, 960px" />][3]

I could have done it with apache virtualhosts which look like this :

[<img loading="lazy" class="aligncenter size-full wp-image-1020" src="/wp-content/uploads/2016/09/Apache-VirtualHosts-Varnish-SSL.png" alt="apache-virtualhosts-varnish-ssl" width="960" height="720" srcset="https://blog.chmouel.com/wp-content/uploads/2016/09/Apache-VirtualHosts-Varnish-SSL.png 960w, https://blog.chmouel.com/wp-content/uploads/2016/09/Apache-VirtualHosts-Varnish-SSL-300x225.png 300w, https://blog.chmouel.com/wp-content/uploads/2016/09/Apache-VirtualHosts-Varnish-SSL-768x576.png 768w" sizes="(max-width: 960px) 100vw, 960px" />][4]

I went finally for nginx since most people seems to say that it was more lean and quick for those kick of ssl accelerator job.

So far so good for the configuration, you can find those informations all over the internet, the nginx ssl configuration was a bit special so I can have the higher secure end of SSL encryption :

Now the thing didn't work very well when accessing the website, I could not see any of th medias including JS and SSL since they were served on the old non ssl url. I tried to force the wordpress configuration to serve SSL but I would end up in a http redirect loop.

Finally I stumbled on [this guy blog][5] and looked at a hack to put in the wp-config.php file. I streamlined it to :

```php
if ( (!empty( $_SERVER['HTTP_X_FORWARDED_HOST'])) ||
     (!empty( $_SERVER['HTTP_X_FORWARDED_FOR'])) ) {
    $_SERVER['HTTPS'] = 'on';
}
```

and that's it, wordpress would then understand it would serve as HTTPS and would add its https url properly.

Hope this helps

[1] I had even a cron sometime ago to mysqlping my mysql server and restart it automatically if it was down since I was so sick of it

 [1]: https://letsencrypt.org
 [2]: https://varnish-cache.org/
 [3]: /wp-content/uploads/2016/09/NGINX-Varnish-Apache.png
 [4]: /wp-content/uploads/2016/09/Apache-VirtualHosts-Varnish-SSL.png
 [5]: https://cmanios.wordpress.com/2014/04/12/nginx-https-reverse-proxy-to-wordpress-with-apache-http-and-different-port/
