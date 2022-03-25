---
title: How does a PUT to a swift object server look like.
author: chmouel
type: post
date: 2012-02-06T10:00:33+00:00
url: /2012/02/06/anatomy-of-a-swift-put-query-to-object-server/
dsq_thread_id:
  - 566098090
tags:
  - Openstack

---
I have been trying lately to get a better understanding of the Swift code base, and I found the best way to know it was to read it from top to bottom and document it along the way. Here is some of my notes, hopefully more will come.

I am starting with an object **PUT** when the request is coming from the proxy server. The request in the log-file will look like this :

_"PUT /sdb1/2/AUTH_dcbeb7f1271d4374b951954a4f1be15f/foo/file.txt" 201 - "-" "txdw08eca2842e344bb8e11b5869c81cb52" "-" 0.0308_

The WSGI controller send the request to the method [swift.obj.server.ObjectController->PUT][1] and start to do the following :

  * splits the request.path to :

<p style="text-align: center;">
  device(<strong>sdb1</strong>), partition(<strong>2</strong>), account(<strong>AUTH_ACCOUNT_ID</strong>), container(<strong>foo</strong>), obj(<strong>file.txt</strong>)
</p>

  * Make sure that partition is mounted. (_there is a **mount_check** option that can toggle this_).
  * Ensure that there is a X-Timestamp header which should be set by the proxy server.
  * Start the check method [check\_object\_creation][2] which does the following :

  * Make sure the **content_length** is not greater than the **MAX\_FILE\_SIZE**.
  * Make sure there is a **content_length** header (_except if the transfer has been chunked_).
  * Make sure that there is no **content_length** (ie: zero byte body) when doing a **X-Copy-From**.
  * Make sure the **object_name** is not greater than **MAX\_OBJECT\_NAME_LENGTH** (_1024 bytes by default_).
  * Making sure we have a **Content-Type** in the headers passed (this could be set by the user or auto-guessed via [mimetypes.guess_type][3] on the proxy server).
  * When we have an header of **x-object-manifest** (_for large files support_) it makes sure the value is a container/object style and not contain chars like **? & /** in the referenced objects names.
  * Checks metadata, make sure at first that the metadata name are not empty.
  * The metadata name length are not greater than **MAX\_META\_NAME_LENGTH** (_default: 128_).
  * The metadata value is not greater than **MAX\_META\_VALUE_LENGTH** (_default: 256_).
  * We don't have a greater amount of metadatas than **MAX\_META\_COUNT** (_default: 90_).
  * The size of the headers combined (_name+value_) is not over **MAX\_META\_OVERALL_SIZE** (_default: 4096_).
  * If we have '**X-Delete-At**' (_for the object expiration feature_) we are making sure this is not happening in the past or we will exit with an **HTTPBadRequest**.
  * The class [swift.obj.server.DiskFile][4] will be the class that takes care to actually write the file locally. It gets instantiated and do the following in the constructor method:
  * It will hash the following  value (**account**, **container**, **obj)** which will become hashed for our example into :

<p style="text-align: center;">
  <span style="font-size: small;"><span style="line-height: 24px;">46acec4563797178df9ec79b28146fe1</span></span>
</p>

  * It will get the path where this is going to be store which going to be :

<p style="text-align: center;">
  <span style="font-size: small;"><span style="line-height: 24px;">/srv/node/sdb1/objects/2/fe1/46acec4563797178df9ec79b28146fe1</span></span>
</p>

  * **/srv/node** is the devices path which is the configuration directive [[proxy]->devices][5] (_default to /srv/node_).
  * **sdb1** being the mounted device name.
  * add the datadir type, ''**objects**'' for us.
  * and the partition power (**2**)
  * last three chars of the hashed name (**fe1**)
  * the hash itself **46acec4563797178df9ec79b28146fe1**
  * It will get the temporary directory which become in our case to: **/srv/node/sdb1/tmp** it is basically the devices dir, the device and /tmp
  * If the directory didn't exists before then it just return.
  * If the directory was existing (already uploaded) then it will parse all files in there and would looks if we have :
  * Files ending up with .**_ts_**  which will be the tombstone (a deleted file).  NB: _Replication process will take care to os.unlink() the file properly later._
  * In case of a _POST_ and if we have fast post setting enabled (see config **object\_post\_as_copy** in proxy_server) we will detect it and only do a copy of metadata.
  * It calculates the expiration time which is from now + the **max\_upload\_time** setting.
  * It start the etag hashing to gradually calculate the md5 of the object.
  *  Using the method **mkstemp** of **DiskFile** it will start to write to tmpdir, which does the creation of the file like that :
  * Make sure to create the _tmpdir_.
  * make a secure temporary file (using **mkstemp**(3)) and yield the file descriptor back to **PUT**.
  * If there is a **content-length** in the headers (assigned by the client) it will use the posix function **[fallocate][6]**(2) to pre-allocate that disk space to the file descriptor.
  * It will then iterate over chunk of data size defined by the configuration variable **network\_chunk\_size** (_default: 64m_) reading that chunk from the request _wsgi.input_ :
  * It will update the **upload_size** value.
  * It will make sure we are not going over our upload expiration time (_or get back **HTTPRequestTimeout** HTTP Error_).
  * It will update the calculated md5 with that chunk.
  * It will write the chunk using python [os.write][7]
  * For large file sync which is over the configuration variable **bytes\_per\_sync** it will do a [fdatasync][8](2) and drop the kernel buffer caches (s_o we are not filling up too much the kernel memory_).
  * if we have a **content-length** in the client headers that doesn't match the calculated **upload_size** we return a **_499 Client Disconnected_** as it means we had a problem somewhere during the upload.
  * It will bail out if we have a etag in the client headers that doesn't match the calculated etag.

And now we are starting defining our metadatas that we are going to store with the file  :

> _metadata = {_  
> _  '**X-Timestamp'**:_ timestamp generated from the proxy_server_._  
> _  '**Content-Type**': d_efined by the user or 'guessed' by the proxy server  
> _  '**ETag**':_ calculated value from the request.  
> _  '**Content**-**Length**':_ an fstat(2) on the file to get the proper value of what is stored on the disk.  
>  _}_

  * It will add to the metadata every headers starting by **'x-object-meta-'.**
  * It will add to the metadata the allowed headers to be stored which is defined in the config variable **allowed_headers** (default: _allowed_headers = Content-Disposition, Content-Encoding, X-Delete-At, X-Object-Manifest_).
  * It will write the file using the put method of the DiskFile class, which finalise the writing on the file on disk and renames it from the temp file to the real location:
  * It will write the metadata using the [xattr][9](1) feature which is stored directly with the file.
  * If there is a **Content-Length** with the metada it will drop the kernel cache of that metadata length.
  * It will invalidate the hashes of the **datadir** directory using the function [swift.obj.replicator.invalidate_hashes][10]
  * It will set the hash of the dir as **None**, which would hint the replication process to have something to do with that dir (and that hash will be generated).
  * This file is stored by partition as python [pickle][11] which is in our case: _/srv/node/sdb1/objects/2/hashes.pkl_
  * Move the file from the tmp dir to go to the **datadir**.
  * It will use the method [unlinkold][12] from **DiskFile** to remove any older versions of the object file which is any files that has older timestamp.
  * It will start construct the request to make to a containers by going passing the following:
  * **account**, **container**, **obj** as request path.
  * the original headers.
  * the headers **Content-Length**, **Content-Type**, **X-Timestamp**, **Etag**, **X-trans-ID**.
  * It will get the headers **X-Container-{Host,Partition,Device}** from the original headers which is defined by the proxy to know on which container server it going to update. Every different PUT will have assigned a different container to each their own.
  * It will use the [async_update][13] method (_by self since it's part of the same class_) to make an asynchronous request:
  * Passing the aforementioned build headers and req.path.
  *  If the request success (between **200** to **300**) it will return to the main (**PUT**) method.
  *  the request didn't succeed it will create a **async_pending** file locally in the tmp dir which is going to be picked-up by the replication process to update the container listing when the container is not too busy.
  * When finish it will respond by a **HTTPCreated**

 [1]: https://github.com/openstack/swift/blob/80a3cb556d1ea2b8ac284816096198b89a2cf117/swift/obj/server.py#L530
 [2]: https://github.com/openstack/swift/blob/80a3cb556d1ea2b8ac284816096198b89a2cf117/swift/common/constraints.py#L85
 [3]: http://docs.python.org/library/mimetypes.html#mimetypes.guess_type
 [4]: https://github.com/openstack/swift/blob/80a3cb556d1ea2b8ac284816096198b89a2cf117/swift/obj/server.py#L94
 [5]: https://github.com/openstack/swift/blob/master/etc/object-server.conf-sample#L8
 [6]: http://linux.die.net/man/2/fallocate
 [7]: http://docs.python.org/library/os.html#os.write
 [8]: http://linux.die.net/man/2/fdatasync
 [9]: https://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/xattr.1.html
 [10]: https://github.com/openstack/swift/blob/80a3cb556d1ea2b8ac284816096198b89a2cf117/swift/obj/replicator.py#L128
 [11]: http://docs.python.org/library/pickle.html
 [12]: https://github.com/openstack/swift/blob/master/swift/obj/server.py#L283
 [13]: https://github.com/openstack/swift/blob/80a3cb556d1ea2b8ac284816096198b89a2cf117/swift/obj/server.py#L381