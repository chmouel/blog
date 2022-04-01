---
title: Using yaml for OpenShift v3 templates
author: chmouel
date: 2015-03-24T10:54:53+00:00
url: /2015/03/24/using-yaml-for-openshift-v3-templates/
dsq_thread_id:
  - 3622100300
tags:
  - OpenShift

---
I have been experimenting a lot with [OpenShift v3][1] and love how everything work well together plugging Kubernetes and Docker with a [PAAS workflow.][2]

One of the thing that I don't get is to have to write manually verbose json templates, it's wonderful for machines and to parse but writing it can get as painful as (dear I said it) XML.

OpenShift natively support very nicely yaml files and it's a straight conversion of what you would have in json format.

Since at this time most of the examples are in json I wrote a script to quickly convert them to yaml and came up with this command line using python and bash :

    for i in $(find . -name '*.json');do  python -c 'import sys,json,yaml;print(yaml.safe_dump(json.loads(sys.stdin.read()), default_flow_style=False))' < $i > ${i/json/yaml};done
    

Happy Yameling (I just made this word up and I am not even drunk)

 [1]: github.com/openshift/origin
 [2]: http://openshiftv3-cmorgancloud.rhcloud.com/