---
title: How-to use the Rackspace Cloud UK API
author: chmouel
date: 2011-01-04T09:00:00+00:00
url: /2011/01/04/how-to-use-the-rackspace-cloud-uk-api/
dsq_thread_id:
  - 252039419
tags:
  - Cloud
  - Rackspace

---
Rackspace just released the public beta for the UK version of Rackspace Cloud. The UK Rackspace Cloud doesn't have the same auth server as the US Cloud so there is a few change you need to do to support the UK Rackspace Cloud. This is the same way Amazon has different zone for EC2 we have now different geographical zone between the US and now the UK.

If you access directly, you just need to adjust the Auth URL in your code to go to :

[https://lon.auth.api.rackspacecloud.com  
][1]  
instead of :  
<https://auth.api.rackspacecloud.com>

The language binding provided by Rackspace has all been updated and available from github :

For [Python CloudFiles][2] :


```python
cnx = cloudfiles.Connection(api_username, api_key, authurl="https://lon.auth.api.rackspacecloud.com/v1.0)

```


For [Python CloudServers][3] :


```python
cloudservers.CloudServers("USERNAME", "API_KEY", auth_url="https://lon.auth.api.rackspacecloud.com/v1.0")

```


For [Ruby CloudFiles][4] :


```ruby
require 'cloudfiles'

  # Log into the Cloud Files system
cf = CloudFiles::Connection.new(
                                :username => "USERNAME",
                                :api_key => "API_KEY",
                                :authurl => "https://lon.auth.api.rackspacecloud.com/v1.0"
                                )

```


For [C# CloudFiles][5] :


```csharp
UserCredentials userCreds = new UserCredentials(new Uri("https://lon.auth.api.rackspacecloud.com/v1.0"), username, api_key, null, null);
Connection connection = new com.mosso.cloudfiles.Connection(userCreds);

```


For [Java CloudFIles][6] add a cloudfiles.properties file in your classpath with this content :


```ini
username=username
password=apikey
auth_url=https://lon.auth.api.rackspacecloud.com/v1.0
connection_timeout=15000

```


and you would be able to access it like this without any argument to the constructor :


```java
FilesClient client = new FilesClient();
client.login();

```


For non rackspace binding I have sent a patch for Apache [libcloud][7] :

<https://issues.apache.org/jira/browse/LIBCLOUD-66>

which when integrated would allow to do something like this :



for [jclouds][8] you can just pass the auth server like this for cloudfiles :



and like this for cloudservers :



for Ruby [Fog][9] :


```ruby
require 'rubygems'
require 'fog'

rackspace = Fog::Rackspace::Storage.new(
  :rackspace_api_key => "",
  :rackspace_username => "",
  :rackspace_auth_url => "lon.auth.api.rackspacecloud.com"
)

```


 [1]: https://lon.auth.api.rackspacecloud.com
 [2]: https://github.com/rackspace/python-cloudfiles
 [3]: http://packages.python.org/python-cloudservers
 [4]: https://github.com/rackspace/ruby-cloudfiles
 [5]: https://github.com/rackspace/csharp-cloudfiles
 [6]: https://github.com/rackspace/java-cloudfiles
 [7]: http://incubator.apache.org/libcloud/
 [8]: http://code.google.com/p/jclouds/
 [9]: https://github.com/geemus/fog/