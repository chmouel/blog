---
title: Swift integration with other OpenStack components in Essex.
author: chmouel
date: 2012-04-25T15:11:58+00:00
url: /2012/04/25/swift-integration-with-other-openstack-components-in-essex/
dsq_thread_id:
  - 663693088
tags:
  - Openstack

---
During the development for OpenStack Essex a lot of work has been done to make Swift working well with the other OpenStack components, this is a list of the work that has been done.

#### **MIDDLEWARE**

To make Swift behaving well in the 'stack' we had to get a rock solid keystone middleware and make sure most of the features provided by Swift would be supported by the middleware.

The middleware is currently <a href="https://github.com/openstack/keystone/blob/stable/essex/keystone/middleware/swift_auth.py" target="_blank">located</a> in the keystone essex repository and was entirely rewritten from the Diablo release to allow support these Swift features :

  * ACL via keystone roles :

<p style="padding-left: 30px;">
  Allow you to map keystone roles as ACL, for example to allow a user with the keystone role 'Reader' to read a container the user in <strong>swift_operator_role</strong> can set this ACL :
</p>

<p style="padding-left: 30px;">
  <em>-r:Reader container</em>
</p>

  * Anonymous access via ACL referrer.

<p style="padding-left: 30px;">
  If a swift_operator wants to give anonymous access to a container in reading they can set this ACL :
</p>

<p style="padding-left: 30px;">
  <em>-r:*</em>
</p>

<p style="padding-left: 30px;">
  It basically mean you are enabling public access to the container.
</p>

  * Container syncing :

<p style="padding-left: 30px;">
  This allow to have two different container in sync, see the documentation <a href="http://swift.openstack.org/overview_container_sync.html" target="_blank">here</a>.
</p>

  * Different reseller prefix :

<p style="padding-left: 30px;">
  You will be able to mix different auth server on your Swift cluster, like swauth and keystone.
</p>

  * Special reseller admin account :

<p style="padding-left: 30px;">
  This is a special account whose allowed to access all account. It i used by nova for example to upload images to different accounts.
</p>

  * S3 emulation :

<p style="padding-left: 30px;">
  Allows you to connect with S3 API to Swift using swift3 and new s3_token middleware. The S3 token will simply take a S3 token to validate it in keystone and get the proper tenant/user information to Swift.
</p>

One thing missing in the middleware is to allow auth overriding, basically it means that when an another middleware wants to take care of the authentication for some request the auth middleware will just let it go and allow the request to continue. Such feature is used for example in the <a href="http://swift.openstack.org/misc.html#module-swift.common.middleware.tempurl" target="_blank">temp_url</a> middleware to allow temporary access/upload to an object. This is projected to be supported in the future.

An important thing to keep in mind when you configure your roles is to have a user in a tenant (or account like called in Swift world) acting as an operator. This is controlled by the setting :

**swift\_operator\_roles**

and by default have the roles _swiftoperator_ and _admin_. A user needs to have this role to be able to do something in a tenant.

#### **GLANCE**

Glance has been updated as well to be able to store images in swift which have a auth server using the 2.0 identity auth.

**NOVA**

Nova have the ability to access an objectstore to store images in a store which has been uploaded with the euca-upload-bundle command. Historically nova have shipped with a service called nova-objectstore but the service was buggy and had some security issues. Swift combined with keystone's s3_token and swift3 middleware now can act as a more reliable and secure objectstore for Nova.

#### **DEVSTACK**

support Swift if you add the swift service to the ENABLED_SERVICE variable in your localrc. This is where you want to poke around to see how the configuration is made to have everything playing well together. The only bit that didn't made for the devstack essex release is to have glance storing images directly in Swift.

#### **CLI / Client Library**

Swift CLI and client library (called swift.common.client) has been updated to support auth v2.0 the CLI support now the <a href="http://wiki.openstack.org/CLIAuth" target="_blank">common OpenStack CLI arguments and environment</a> to operate against auth server that has 2.0 identity auth.

We unfortunately were not in time to add the support for OS\_AUTH\_TENANT and use the Swift auth v1 syntax where if the user has the form of tenant:user OS\_AUTH\_TENANT will become tenant and OS\_AUTH\_USER the user.

Aside of a couple of bit missing we believe Swift should be rock solid to use with your other OpenStack components. There is no excuse to not use Swift as your central object storage component in OpenStack ;-).

&nbsp;

<div>
  <strong><br /> </strong>
</div>