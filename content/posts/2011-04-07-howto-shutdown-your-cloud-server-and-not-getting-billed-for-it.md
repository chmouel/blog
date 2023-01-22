---
title: Howto shutdown your Cloud Server and not getting billed for it.
author: chmouel
date: 2011-04-07T09:36:28+00:00
url: /2011/04/07/howto-shutdown-your-cloud-server-and-not-getting-billed-for-it/
dsq_thread_id:
  - 273424072
tags:
  - Cloud
  - Rackspace

---
Currently in Rackspace-Cloud when you are shutting-down your Cloud Servers you are still paying for it.

The reason is that when the Cloud Server is shut-down your CloudServer is still sitting on the hyper-visor and still use resources on the Cloud and then get you billed for it.

There is a way to get around it by having the CloudServer stored as an image into CloudFiles.

The caveat with this solution is that every-time you are creating a server out of the stored image you are getting a new IP and in certain cases you would need to make a change in your application with the new IP.

If you only use domain names instead of IP in your application you are not dependent of the IP change, to update the domain with the new IP after creating the VM you can either :

- Have a dynamic DNS or 'Cloud DNS' updated just after you created your server out of the image.

- Have a script going into your server and update the IP directly in /etc/hosts.

In programming words this is the steps you would do. I am using the python-nova binding which allow you to connect to RackSpace Cloud.

At first I am going to create an object which we are going to authenticate


```python
import novaclient
cx = novaclient.OpenStack(USERNAME,
                            API_KEY)

```


or for the UK :


```python
import novaclient
cx = novaclient.OpenStack("USERNAME",
                            "API_KEY",
                            'https://lon.auth.api.rackspacecloud.com/v1.0')

```


cx is going to be the object from where we can do things on it. Let's first find the server server that we want, assuming your server is called test you would get the server like this :


```python
server = cx.servers.find(name='test')

```


The variable 'server' contain our server 'object' and we can get its ID out of it :


```python
server_id = server.id

```


We got the function cx.images.create to create an image from a server which accept as first argument the image name and the second the server id we just got. this would start the creation of the image :


```python
cx.images.create("backup_server", server_id)

```


The server has started to get backed-up into your Cloud Files account, you can see it directly into the "My Server Images" tab of Hosting => Cloud Servers section :

[<img loading="lazy" src="/wp-content/uploads/2011/04/Backup-1024x31.png" alt="" title="Backup" width="640" height="19" class="aligncenter size-large wp-image-442" srcset="https://blog.chmouel.com/wp-content/uploads/2011/04/Backup-1024x31.png 1024w, https://blog.chmouel.com/wp-content/uploads/2011/04/Backup-300x9.png 300w, https://blog.chmouel.com/wp-content/uploads/2011/04/Backup.png 1596w" sizes="(max-width: 640px) 100vw, 640px" />][1]

You can now delete the server since it's 'backuped' into cloud files ;


```python
server.delete()

```


At this time you are not billed for your Cloud Servers anymore and only for the storage usage in Cloud Files.

When you want to restore the image as a server, you would first get the id of your image :


```python
image = cx.images.find(name='backup-test')
image_id = image.id

```


and create the server out of this image :


```python
CNX.servers.create(image=image_id,
                            flavor=1,
                            name="test",
                            )

```


The flavor argument is the type of image you want, 1 the minimal 256M flavor. The full list is :


```python
In [14]: for x in cx.flavors.list():
   ....:     print x.id, '-', x.name
   ....:     
   ....:     
1 - 256 server
2 - 512 server
3 - 1GB server
4 - 2GB server
5 - 4GB server
6 - 8GB server
7 - 15.5GB server

```


When the server has created it should be exactly the same as what you have before created in image. You can now run a script using SSH with SSH keys to log into servers and do adjustment with the new IP.

 [1]: /wp-content/uploads/2011/04/Backup.png