---
title: Using python to drive OpenShift REST API
author: chmouel
date: 2016-09-19T08:19:50+00:00
url: /2016/09/19/using-python-to-drive-openshift-rest-api/
dsq_thread_id:
  - 5155324661
tags:
  - OpenShift

---
I have been meaning to automate my deployment directly from my small python application without having to use the openshift client (oc) directly.

OpenShift use a REST API and the oc client uses it to communicate with the server, you can actually see all the REST operation the oc client is doing if you specify the --loglevel=7 (it goes to 10 to get even more debug info) :


```
$ oc --loglevel=7 get pod 2>&1 |head -10
I0919 09:59:20.047350   77328 loader.go:329] Config loaded from file /Users/chmouel/.kube/config
I0919 09:59:20.048149   77328 round_trippers.go:296] GET https://openshift:8443/oapi
I0919 09:59:20.048158   77328 round_trippers.go:303] Request Headers:
I0919 09:59:20.048162   77328 round_trippers.go:306]     User-Agent: oc/v1.4.0 (darwin/amd64) openshift/85eb37b
I0919 09:59:20.048175   77328 round_trippers.go:306]     Authorization: Bearer FOOBAR
I0919 09:59:20.048180   77328 round_trippers.go:306]     Accept: application/json, */*
I0919 09:59:20.095239   77328 round_trippers.go:321] Response Status: 200 OK in 47 milliseconds
I0919 09:59:20.096056   77328 round_trippers.go:296] GET https://openshift:8443/version
I0919 09:59:20.096078   77328 round_trippers.go:303] Request Headers:
I0919 09:59:20.096084   77328 round_trippers.go:306]     User-Agent: oc/v1.4.0 (darwin/amd64) openshift/85eb37b

```


I was thinking to come up with my own python rest wrapper since a google quick search didn't come up with any binding. But since openshift is build on kubernetes and fully compatible with it (i.e: no fork or changes that make it incompatible) it was as easy as using the tools provided for kube.

The first project coming up on the google search is [pykube][1] and it's easily installable with pip.

You need to provide a kubeconfig that was already setup (with username/passwd) or already identified if it's token based (i.e: oauth, oid etc) and you can use this example like this :

```python
import pykube
api = pykube.HTTPClient(pykube.KubeConfig.from_file("/Users/chmouel/.kube/config"))
pods = pykube.Pod.objects(api).filter(namespace="test")
for x in pods:
    print(x)
```


see the documentation of pykub on its [website][1]

 [1]: https://github.com/kelproject/pykube
