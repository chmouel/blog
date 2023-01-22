---
title: Keystone and PKI tokens overview
author: chmouel
date: 2013-05-02T08:00:15+00:00
url: /2013/05/02/keystone-pki-tokens-overview/
dsq_thread_id:
  - 1247322183
tags:
  - Keystone
  - Openstack

---
PKI tokens has been implemented in keystone by [Adam Young][1] and others and was shipped for the OpenStack grizlly release. It is available since the version 2.0 API of keystone.

PKI is a beautiful acronym to [Public-key infrastructure][2] which according to wikipedia defines it like this :

> Public-key cryptography is a cryptographic technique that enables users to securely communicate on an insecure public network, and reliably verify the identity of a user via digital signatures.

As described more lengthy on this IBM [blog post][3] keystone will start to generate a public and a private key and store it locally.

When getting the first request the service (i.e: [Swift][4]) will go get the public certificate from keystone and store it locally for later use.

When the user is authenticated and a PKI token needs to be generated, keystone will take the private key and encrypt the token and the metadata (i.e: roles, endpoints, services).

The service by the mean of the auth_token middleware will decrypt the token with the public key and get the info to pass on to the service it set the \*keystone.identity\* WSGI environement variable to be used by the other middleware of the service in the paste pipeline.

The PKI tokens are then much more secure since the service can trust where the token is coming from and much more efficient since it doesn't have to validate it on every request like done for UUID token.

## Auth token

This bring us to the auth_token middleware. The auth token middleware is a central piece of software of keystone to provide a generic middleware for other python WSGI services to integrate with keystone.

The auth_token middleware was moved in grizzly to the python-keystoneclient package, this allows us to don't have to install a full keystone server package to use it (remember this is supposed to be integrated directly in services).

You usually would add the auth\_token middleware in your paste pipeline at the begining of it (there may be other middlewares before like logging, catch\_errors and stuff so not quite the first one).

<pre class="example">[filter:authtoken]
signing_dir = /var/cache/service
paste.filter_factory = keystoneclient.middleware.auth_token:filter_factory
auth_host = keystone_host
auth_port = keystone_public_port
auth_protocol = keystone_public_port
auth_uri = http://keystone_host:keystone_admin_port/
admin_tenant_name = service
admin_user = service_user
admin_password = service_password

```


There is much more options to the auth\_token middleware, I invite you to refer to your service documentation and read a bit the top of the auth\_token file [here][5].

When the service get a request with a **X-Auth-Token** header containing a PKI token the auth middleware will intercept it and start to do some works.

It will validate the token by first md5/hexdigesting it, this is going to be the key in memcache as you may have seen the PKI token since containing all the metadatas can be very long and are too big to server as is for memcache.

It will check if we have the key in memcache and if not start verify the signed token.

Before everything the token is checked if it was revoked (see my previous article about [PKI revoked tokens][6]). The way it's getting the revoked token is to first check if the token revocation list is expired (by default it will do a refresh for it every seconds).

If it need to be refreshed it will do a request to the url '_/v2.0/tokens/revoked_' with an admin token to the keystone admin interface and get the list of revoked tokens.

The list get stored as well on disk for easy retrieval.

If the token is not revoked it will convert the token to a proper CMS format and start verifying it.

Using the signing cert filename and the ca filename it will invoke the command line openssl CLI to do a cms -verify which will decode the cms token providing the decoded data. If the cert filename or the ca filename was missing it will fetch it again.

Fetching the signing cert will be done by doing a non authenticated query to the keystone admin url '_/v2.0/certificates/signing_'. Same goes for the ca making a query to the keystone url '_/v2.0/certificates/ca_'.

When we have the decoded data we can now build our environement variable for the other inside the environement variable call keystone.token_info this will be used next by the other services middleware. Bunch of new headers will be added to the request with for example the User Project ID Project Name etc..

The md5/hexdigest PKI token is then stored with the data inside memcache.

And that's it, there is much more information on the IBM blog post and on Adam's blog I am mentionning earlier.

 [1]: http://adam.younglogic.com/
 [2]: http://en.wikipedia.org/wiki/Public-key_infrastructure
 [3]: https://www.ibm.com/developerworks/community/blogs/e93514d3-c4f0-4aa0-8844-497f370090f5/entry/openstack_keystone_workflow_token_scoping?lang%3Den
 [4]: http://github.com/openstack/swift
 [5]: https://github.com/openstack/python-keystoneclient/blob/master/keystoneclient/middleware/auth_token.py
 [6]: https://blog.chmouel.com/2013/04/22/howto-revoke-a-token-with-keystone-and-pki-v2-0-api/