---
title: Using Jython with the vCloud API
author: chmouel
date: 2010-05-17T20:33:47+00:00
url: /2010/05/17/using-jython-with-the-vcloud-api/
dsq_thread_id:
  - 252701357
tags:
  - Cloud
  - Programming

---
Lately I had to do a lot of works with the <a title="Vcloud vCloud API" href="http://communities.vmware.com/community/developer/forums/vcloudapi" target="_blank">VMware VCloud</a> product and since the python API did not seem available and I did not have the courage to use the PHP API I had to do most of the API works with Java. I never did any Java before and while I have found Eclipse+Java development surprisingly pleasant and easy to use/learn my favourite are still Emacs+Python.

I have then started to look over Jython to see if I can interact easily with Java via Python and this was actually pretty easy, it took me less than 10mn to convert a Login/Listing-VAPPS script in Jython.

The script is attached at the end of this post (or on github gist [here][1]). Don't forget to adjust the classpath variable mine are defined like that :

> commons-codec-1.3.jar
> commons-httpclient-3.1.jar
> commons-logging-1.1.1.jar
> rest-api-schemas-1.0.0.jar
> vcloud-java-sdk-0.9.jar
> vCloudJavaSDK-samples.jar

<div>
  Most of them are the ones shipped with the official Java API
</div>

<div>
  Here is the script  the __main__ should get you the logic and a start how to use it :
</div>

```python
#!/usr/bin/jython
import sys

from org.apache.commons.httpclient.protocol import Protocol
from com.vmware.vcloud.sdk  import VcloudClient, Organization, Vdc
from com.vmware.vcloud.sdk.samples import FakeSSLSocketFactory

class VcloudLogin(object):
    """
    VcloudLogin: Login to vcloud class
    """
    vcloudClient = None
    api_version = None
    vcloud_url = None

    def __init__(self, vcloud_url, api_version):
        # This is needed if you have a self certified certificate
        # remove it if you have a proper SSL certs.
        self.setup_fake_ssl()
        self.vcloud_url = vcloud_url
        self.api_version = api_version

    def setup_fake_ssl(self):
        https = Protocol("https", FakeSSLSocketFactory(), 443)
        Protocol.registerProtocol("https", https)

    def login(self, username, password):
        versions = VcloudClient.getSupportedVersions(self.vcloud_url + "/api/versions")
        self.vcloudClient = VcloudClient(versions.get(self.api_version))
        return self.vcloudClient.login(username, password)


if __name__ == '__main__':
    URL="https://URL"
    API_VERSION="0.9"
    USERNAME="user@organization"
    PASSWORD="password"

    vcl = VcloudLogin(URL, API_VERSION)
    organizations_list = vcl.login(USERNAME, PASSWORD)

    for org in organizations_list.values():
        for vdcLink in \
                Organization.getOrganizationByReference(vcl.vcloudClient, org).getVdcLinks():
            vdc = Vdc.getVdc(vcl.vcloudClient, vdcLink)
            print "VDC Href: %s\n" % (vdcLink.getHref())
            for vapps in vdc.getVappRefs():
                print "Name: %s URL: %s" % (vapps.getName(), vapps.getHref())

```

 [1]: http://gist.github.com/404193
