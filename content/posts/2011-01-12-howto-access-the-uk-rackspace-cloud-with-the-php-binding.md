---
title: Howto access the UK Rackspace Cloud with the PHP Binding
author: chmouel
date: 2011-01-12T16:17:07+00:00
url: /2011/01/12/howto-access-the-uk-rackspace-cloud-with-the-php-binding/
dsq_thread_id:
  - 253390337
tags:
  - Cloud
  - Rackspace

---
One of the last library I didn't documented in my [earlier post][1] was php-cloudfiles. You need to have at least the [version 1.7.6][2] released to have support to different auth_server and when you have that you can do it like this to get access to cloud files via the library :

```php
<?php
require_once("cloudfiles.php");

# Allow override by environment variable
$USER = "MY_API_USERNAME";
$API_KEY = "MY_API_KEY";

$auth = new CF_Authentication($USER, $API_KEY, NULL, UK_AUTHURL);
$auth->authenticate();
?>
```

 [1]: https://blog.chmouel.com/2011/01/04/how-to-use-the-rackspace-cloud-uk-api/
 [2]: https://github.com/rackspace/php-cloudfiles/archives/1.7.6
