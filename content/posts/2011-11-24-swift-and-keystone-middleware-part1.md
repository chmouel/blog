---
title: Swift and Keystone middleware
author: chmouel
date: 2011-11-24T09:20:39+00:00
url: /2011/11/24/swift-and-keystone-middleware-part1/
dsq_thread_id:
  - 482265099
tags:
  - Keystone
  - Openstack

---
<span style="color: #ff0000;">[NB: Much things has changed since I have written this article but keeping it here for info]</span>

It seems that integrating <a href="http://swift.openstack.org/" target="_blank">Swift</a> and <a href="http://keystone.openstack.org/" target="_blank">Keystone</a> together present some challenges to people and this is absolutely normal as there is a lot of changes going on. This is my attempt to document how everything is plugged together.

I am not going to explain how a middleware is supposed to work as this is nicely documented on Wikipedia :

<a href="http://en.wikipedia.org/wiki/Middleware" target="_blank">http://en.wikipedia.org/wiki/Middleware</a>

or how the auth middlewares works on Swift :

<a href="http://swift.openstack.org/development_auth.html" target="_blank">http://swift.openstack.org/development_auth.html<br /> </a>  
or even how this is plugged inside Keystone :

<a href="http://keystone.openstack.org/middleware_architecture.html" target="_blank">http://keystone.openstack.org/middleware_architecture.html<br /> </a>

At first let's get some of the wordings right :

  * A **tenant** in keystone is an **account** in swift.
  * A **user** in keystone is also a **user** in swift.
  * A **role** in keystone is a **group** in swift.

Now that you keep this in mind let's walk-though how a request will  
look like.

At first your user connect to keystone and says this is my username for this  
tenant and here is the secret/api key, give me the endpoints for the  
services and add a token to it. This will look like this in curl :


```bash
curl -s -d '{"auth": {"tenantName": "demo", "passwordCredentials": {"username": "demo", "password": "password"}}}' -H 'Content-type: application/json' http://localhost:5000/v2.0/tokens
```


If successfully authenticated you get back in Json those public/internal urls  
for swift so you are able to connect, here is some part of the replied request :


```
{
    "endpoints": [
        {
            "adminURL": "http://localhost:8080/",
            "internalURL": "http://localhost:8080/v1/AUTH_2",
            "publicURL": "http://localhost:8080/v1/AUTH_2",
            "region": "RegionOne"
        }
    ],
    "name": "swift",
    "type": "object-store"
}
[...]
"token": {
    "expires": "2011-11-24T12:35:56",
    "id": "ea29dae7-4c54-4e80-98e1-9f886acb389a",
    "tenant": {
        "id": "2",
        "name": "demo"
    }
},
```


So now the clients is going to get the publicURL (or can be internal) with the token and able to give request to swift with it. Let's take the simple request which list the container,  this is a basic GET on the account :


```bash
curl -v -H 'X-Auth-Token: ea29dae7-4c54-4e80-98e1-9f886acb389a' http://localhost:8080/v1/AUTH_2
```


which should come back by a 20* http code if that work.

What's happening here is that when you connect to swift it will pass it to the middleware to make sure we are able to have access with that token.

The middleware will take that token connect to keystone admin url with the admin token and pass that user token to be validated. The query looks like this in curl :


```bash
curl -H 'X-Auth-Token: 7XX' http://localhost:35357/v2.0/tokens/ea29dae7-4c54-4e80-98e1-9f886acb389a
```


_**note**: localhost:35357 is the keystone admin url and 7XX is the admin token set in the configuration of the middleware._

if successful keystone will come back with a reply that look like this :


```javascript
{
    "access": {
        "token": {
            "expires": "2011-11-24T12:35:56",
            "id": "ea29dae7-4c54-4e80-98e1-9f886acb389a",
            "tenant": {
                "id": "2",
                "name": "demo"
            }
        },
        "user": {
            "id": "2",
            "roles": [
                {
                    "id": "2",
                    "name": "Member",
                    "tenantId": "2"
                },
                {
                    "id": "5",
                    "name": "SwiftOperator",
                    "tenantId": "2"
                },
            ],
            "username": "demo"
        }
    }
}
```


Let's step back before more Curl command and understand a thing about Swift, a user of an account in Swift by default don't have any rights at all but there is one user in that account  whose able to give ACL on containers for other users. In swift keystone middleware we call it an Operator.

The way the middleware knows which user is able to be admin on an account is by using the roles matching to whatever configuration we have on the middleware setting called :


```
keystone_swift_operator_roles = Admin, SwiftOperator
```


since this user is part the SwiftOperator then it has access and he's allowed to do whatever he wants for that account like creating containers or giving ACL to other users.

So let's say we have a user called demo2 which is part of the demo account and have only the role Member to it and not SwiftOperator by default as we say before he will not be able to do much.

But if demo user give access to the group/role Memeber to a container via acl then demo2 will be able to do stuff on it.

We can all have fun with bunch of curl commands but since swift 1.4.7 the swift CLI tool have support for the auth server version 2.0 and allow you to connect to keystone for auth so we are going to use that instead.

Let first create a testcontainer and upload a file into it with our 'operator' user :


```bash
swift --auth-version 2 -A http://localhost:5000/v2.0 -U demo:demo -K password post testcontainer
```


now let's give access to the Member group for that container on reading :


```bash
swift --auth-version 2 -A http://localhost:5000/v2.0 -U demo:demo -K password post testcontainer -r Member
```


and now if we try to read that file directly with demo2 it will be allowed :


```bash
swift --auth-version 2 -A http://localhost:5000/v2.0 -U demo:demo2 -K password download testcontainer etc/issue -o-
```


Hope this make things a bit more clears how everything works, in the next part I am going to explain how the config files and packages will look like for installing keystone and swift.