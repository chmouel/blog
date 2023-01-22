---
title: How to connect to Rackspace Cloud Files via ServiceNET
author: chmouel
date: 2009-10-14T00:47:27+00:00
url: /2009/10/14/how-to-connect-to-rackspace-cloud-files-via-servicenet/
dsq_thread_id:
  - 252039388
tags:
  - Programming
  - Python
  - Rackspace

---
<span style="background-color: #ffffff;">If you are a Rackspace customer and you are are planning to use Rackspace Cloud Files via it's internal network (ServiceNet) so you don't get billed for the bandwidth going over Cloud Files this is how you can do.</span>

The first thing is to make sure with your support team if your servers are connected to ServiceNet and if you have that connection then there is a small change to do in your code.

The second thing is to use the just released 1.5.0 version on GitHUB for PHP :

<http://github.com/rackspace/php-cloudfiles/tree/1.5.0>

and for python :

<http://github.com/rackspace/python-cloudfiles/tree/1.5.0>

(you need to click on the download link at the top to download the tarball of the release).

Afer this is just a matter to set the argument servicenet=True, for example in PHP :


```php
$user='username';
$api_key='theapi_key';

$auth = new CF_Authentication($user, $api_key);
$auth->authenticate();
$conn = new CF_Connection($auth, $servicenet=true);

```


In Python you can do like this :


```python
username='username'
api_key='api_key'

cnx = cloudfiles.get_connection(username, api_key, servicenet=True)
```
