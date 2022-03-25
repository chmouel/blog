---
title: Audit a swift cluster
author: chmouel
type: post
date: 2012-02-01T10:18:11+00:00
url: /2012/02/01/audit-a-swift-cluster/
dsq_thread_id:
  - 560046583
tags:
  - Openstack

---
Swift integrity tools.

There is quite a bit of tools shipped with Swift to ensure you have the right object on your cluster.

At first there is the basic :

**swift-object-info**

It will take a swift object stored on the filesystem and print some infos about it, like this :

> swift@storage01:0/016/0b221bab535ac1b8f0d91e394f225016$ swift-object-info 1327991417.01411.data  
> Path: /AUTH_root/foobar/file.txt  
> Account: AUTH_root  
> Container: foobar  
> Object: file.txt  
> Object hash: 0b221bab535ac1b8f0d91e394f225016  
> Ring locations:  
> 192.168.254.12:6000 - /srv/node/sdb1/objects/0/016/0b221bab535ac1b8f0d91e394f225016/1327991417.01411.data  
> Content-Type: text/plain  
> Timestamp: 2012-01-31 06:30:17.014110 (1327991417.01411)  
> ETag: 053a0f8516a5023b9af76c49ca917d3e (valid)  
> Content-Length: 24 (valid)  
> User Metadata: {'X-Object-Meta-Mtime': '1327968327.21'}

PS: If you don't know where is your object on which node, you can you use swift-get-nodes

For auditing, the Etag value is important because swift-object-info will compare the object recorded etag in the metadata with what we have on the disks. Let's try to see if that works :

> swift@storage01:0/016/0b221bab535ac1b8f0d91e394f225016$ cp 1327991417.01411.data /tmp  
> swift@storage01:0/016/0b221bab535ac1b8f0d91e394f225016$ echo "foo" >> 1327991417.01411.data  
> swift@storage01:0/016/0b221bab535ac1b8f0d91e394f225016$ swift-object-info 1327991417.01411.data|grep '^Etag'  
> Etag: 053a0f8516a5023b9af76c49ca917d3e doesn't match file hash of 9ff871e5ce5dcb5d3f2680a80a88ff38!

swift-object-info has detected that this file is not the one we have uploaded.

There is an other tool called **swift-drive-audit** which as explained in the [admin guide][1] will parse the _/var/log/kern.log_ and have predefined regexp  to detect disk failure notified by the kernel. It is usually run periodically by cron and there is a config file for it called _[/etc/swift/drive-audit.conf.][2]_ If the script find any errors for a certain drive it will unmount it and comment it in /etc/fstab(5). Afterwards  the replication process will pick it up from other replicas and put the object on that drive in _handover_.

Swift provide as well different type of auditor daemons for account/container/object :

  *  swift-account-auditor
  *  swift-container-auditor
  *  swift-object-auditor

**swift-account-auditor** will open all sqlite db of an account server and launch a SQL query to make sure all the dbs are valid.  
**swift-container-auditor** will do the same but for containers.  
**swift-object-auditor** will open all object of an object server and make sure of :

  * Metadata are correct.
  * We have the proper size.
  * We have the proper MD5.

Those auditors needs to be set in each type-server.conf, for example for account server you will add something like this to /etc/swift/account-server.conf :

> [account-auditor]  
> \# You can override the default log routing for this app here (don't use set!):  
> \# log_name = account-auditor  
> \# log\_facility = LOG\_LOCAL0  
> \# log_level = INFO  
> \# Will audit, at most, 1 account per device per interval  
> interval = 1800  
> \# log\_facility = LOG\_LOCAL0  
> \# log_level = INFO

For container this is about the same options but for object-server does are the options :

> [object-auditor]  
> \# You can override the default log routing for this app here (don't use set!):  
> \# log_name = object-auditor  
> \# log\_facility = LOG\_LOCAL0  
> \# log_level = INFO  
> \# files\_per\_second = 20  
> \# bytes\_per\_second = 10000000  
> \# log_time = 3600  
> \# zero\_byte\_files\_per\_second = 50

Another tool shipped with swift is **swift-account-audit** which will audit a full account and report if there is missing replicas or incorrect object in that account.

 [1]: http://swift.openstack.org/admin_guide.html "Admin Guide"
 [2]: https://github.com/openstack/swift/blob/master/etc/drive-audit.conf-sample