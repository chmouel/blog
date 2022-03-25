---
title: Getting a letsencrypt SSL certificate for the OpenShift console and API
author: chmouel
date: 2016-09-29T08:22:48+00:00
url: /2016/09/29/getting-a-letsencrypt-ssl-certificate-for-the-openshift-console-and-api/
tags:
  - OpenShift

---
By default when you install an OpenShift install it would automatically generate its own certificates.

It uses those certificates for communication between nodes and as well to automatically auth the admin account. By default those same certificates are the one provided for the OpenShift console and API.

Since it is auto generated you will when connecting  to the website with you webbrowser get an ugly error message :

![](/wp-content/uploads/2016/09/2016-09-28__23-40-01-20126.png)

and as the error message says that's not very secure #sadpanda.

There is an easy way to generate certificate these days and it is to use [letsencrypt][2], so let's see how to connect it to the openshift console.

There is something to understand first here,  when you want to use an alternate SSL certificates for your console and API you can't do that on your default (master) URL, it has to be another url. Phrased in another way here is a quote from the [official documentation][3]  :

![](/wp-content/uploads/2016/09/2016-09-28__23-55-03-27531.png)

with that in mind let's assume you have setup a domain being a CNAME to your default domain. For myself here since this is a test install I went to use the easy way and I will use the xp.io service as [I have documented in an earlier post][5]. This give me easily a domain which would look like this :

<p style="padding-left: 30px;">
  lb.198.154.189.125.xip.io
</p>

So now that you have defined it, you need first to generate the letsencrypt certificate usually you would use [certbot][6]from RHEL EPEL to generate them but unfortunately at the time of writing this blog post the package was  uninstallable for me which probably would get fixed soon. In the meantime I have used letsencrypt from git directly as like this:

<p style="padding-left: 30px;">
  $ git clone https://github.com/letsencrypt/letsencrypt
</p>

before you do anything, you need to understand the letsencrypt  process, usually you would have an apache or nginx (etc...) serving the generated files for verifications  (the /.well-known/ thing) since we can't do that for us in openshift you can use the letsencrypt builtin webserver for that.

But to start the builtin webserver you need to be able to do it to bind it on port 80  but for us on master there is the router running which bind to it (and 443), so you would need to make sure it's down and the most elegant way to do that with openshift is like this :

<p style="padding-left: 30px;">
  $ oc scale --replicas=0 dc router
</p>

now that you have nothing on port 80 you can tell letsencrypt to do its magic with this command line :

<p style="padding-left: 30px;">
  $ ./letsencrypt-auto --renew-by-default -a standalone --webroot-path /tmp/letsencrypt/ --server https://acme-v01.api.letsencrypt.org/directory --email email@email.com --text --agree-tos --agree-dev-preview -d lb.198.154.189.125.xip.io auth
</p>

change the _lb.198.154.189.125.xip.io_ here to your own domain as the email address, if everything goes well you should get something like this :

![](/wp-content/uploads/2016/09/2016-09-29__00-08-22-10578.png)

now you should have all the certificates needed in /etc/letsencrypt/live/${domain}

So there is a little caveat here, there is a bug in openshift-ansible currently with symlinks and certificates and the way it operates. I have filled the bug [here][8] and it has already been fixed in GIT so hopefully by the time you will read this article this would be fixed in the openshift-ansible rpm if it's not you can directly use the GIT openshift-ansible instead of the package.mber (3) here is going to change so you would have to adjust.

now you just need to some configuration in your /etc/ansible/hosts file :

<pre>openshift_master_cluster_public_hostname=lb.198.154.189.125.xip.io
openshift_master_named_certificates=[{"certfile": "/etc/letsencrypt/live/lb.198.154.189.125.xip.io/full.pem", "keyfile": "/etc/letsencrypt/live/lb.198.154.189.125.xip.io/privkey.pem", "names":["lb.198.154.189.125.xip.io"]}]
openshift_master_overwrite_named_certificates=true
</pre>

after you run your playbook (with ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml) you should have it running properly and now when accessing by the console you should the reassuring secure lock :

![](/wp-content/uploads/2016/09/2016-09-29__10-11-32-12477.png)

**NB**:

* If you need to renew the certs just do the steps where you oc scale the router quickly and renew the certificate with the letsencrypt auto command line mentioned earlier.
* There is probably a way more elegant way to do that with a container and a route. I saw [this][10] on dockerhub but this seems to be tailored to apps (and kube) and I don't think this could be used for the OpenShift console.
* Don't forget to _oc scale --replicas=1 dc/router_(even tho the ansible rerun should have done for you.

 [1]: /wp-content/uploads/2016/09/2016-09-28__23-40-01-20126.png
 [2]: https://letsencrypt.org
 [3]: https://access.redhat.com/documentation/en/openshift-enterprise/3.1/paged/installation-and-configuration/chapter-2-installing#advanced-install-custom-certificates
 [4]: /wp-content/uploads/2016/09/2016-09-28__23-55-03-27531.png
 [5]: https://blog.chmouel.com/2016/09/28/easily-test-your-openshift-applications-exposed-by-the-router/
 [6]: https://certbot.eff.org/#centosrhel7-other
 [7]: /wp-content/uploads/2016/09/2016-09-29__00-08-22-10578.png
 [8]: https://github.com/openshift/openshift-ansible/issues/2526
 [9]: /wp-content/uploads/2016/09/2016-09-29__10-11-32-12477.png
 [10]: https://hub.docker.com/r/sjenning/kube-nginx-letsencrypt/
