---
title: Howto revoke a token with keystone and PKI (v2.0 API)
author: chmouel
date: 2013-04-22T22:38:27+00:00
url: /2013/04/22/howto-revoke-a-token-with-keystone-and-pki-v2-0-api/
dsq_thread_id:
  - 1229480924
tags:
  - Openstack

---
This is something I have been asked and I was at first under impression it was only available in v3, digging a bit more into the code there is actually a way to do that in v2 when you are using PKI tokens. Since I could not find much documentation online here is a description of the steps how to do it.

Let first get a PKI token, you can do it the hard way by sending a json blob to the keystone url and parse the json results like this :

<pre>$ curl -s -d '{"auth": {"tenantName": "tenant", "passwordCredentials": {"username": "user", "password": "password"}}}' -H 'Content-type: application/json' http://localhost:5000/v2.0/tokens</pre>

or do the easy way by gettting my script available here :

<http://p.chmouel.com/ks>

and use it like that :

<pre>eval $(bash ks -s localhost tenant:user password)</pre>

it will give you a variable $TOKEN and a variable $STORAGE_URL that you can use further down.

now let's try to use it with our swift :

<pre>$ curl -i -H "X-Auth-Token: $TOKEN" ${STORAGE_URL}
HTTP/1.1 204 No Content
Content-Length: 0
Accept-Ranges: bytes
X-Timestamp: 1366666887.01151
X-Account-Bytes-Used: 0
X-Account-Container-Count: 0
Content-Type: text/html; charset=UTF-8
X-Account-Object-Count: 0
X-Trans-Id: tx5b50dc6d01d04923a40a1486c13dd94d
Date: Mon, 22 Apr 2013 22:01:00 GMT</pre>

all good here,

so now go inside your keystone.conf and get your admin/service token or use that friendly copy and paste command line :

<pre>$ ADMIN_TOKEN=$(sed -n '/^admin_token/ { s/.*=[ ]*//;p }' /etc/keystone/keystone.conf)</pre>

and use it to DELETE the token we do that request directly to our keystone which is localhost here point it wherever you want:

<pre>$ curl -X DELETE -i -H "X-Auth-Token: $ADMIN_TOKEN" http://localhost:5000/v2.0/tokens/$TOKEN
HTTP/1.1 204 No Content
Vary: X-Auth-Token
Content-Length: 0
Date: Mon, 22 Apr 2013 22:01:08 GMT</pre>

We can still use it because the token is still in the cache. By default tokens are cached in memcache as good as 5 minutes but the  
revocation list is fetched every seconds or so.

<pre>$ curl -i -H "X-Auth-Token: $TOKEN" ${STORAGE_URL}
204 No Content
Content-Length: 0
Accept-Ranges: bytes
X-Timestamp: 1366666887.01151
X-Account-Bytes-Used: 0
X-Account-Container-Count: 0
Content-Type: text/html; charset=UTF-8
X-Account-Object-Count: 0
X-Trans-Id: tx9018045ce1324203a91e882ec6d27ac3
Date: Mon, 22 Apr 2013 22:01:12 GMT</pre>

but after a bit (like over a minute or so) we are getting a proper denied:

<pre>$ curl -i -H "X-Auth-Token: $TOKEN" ${STORAGE_URL}
HTTP/1.1 401 Unauthorized
Content-Length: 131
Content-Type: text/html; charset=UTF-8
X-Trans-Id: tx9133daf949204f0facf45152a43836bb
Date: Mon, 22 Apr 2013 22:27:23 GMT

>h1<Unauthorized< 

<p>
  This server could not verify that you are authorized to access the document you requested.</html>
  </pre>
  
  
  <p>
    and from the log messages:
  </p>
  
  
  <pre>proxy-server Token 49d94a8ca068013b6efe79e3463627c8 is marked as having been revoked
proxy-server Token validation failure.#012Traceback (most recent call last):#012  File "/opt/stack/python-keystoneclient/keystoneclient/middleware/auth_token.py", line 689, in _validate_user_token#012    verified = self.verify_signed_token(user_token)#012  File "/opt/stack/python-keystoneclient/keystoneclient/middleware/auth_token.py", line 1045, in verify_signed_token#012    raise InvalidUserToken('Token has been revoked')#012InvalidUserToken: Token has been revoked

[..]
proxy-server Marking token MIIGogYJK...... as unauthorized in memcache
</pre>
  
  
  <p>
    bingo the token has been now revoked properly.
  </p>