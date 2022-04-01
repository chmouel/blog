---
title: User namespaces with Buildah and OpenShift Pipelines
author: chmouel
date: 2022-01-25T10:07:07+00:00
url: /2022/01/25/user-namespaces-with-buildah-and-openshift-pipelines/
showToc: true
---
In 2022 one of the hottest topic around CI is how to secure it every steps along the way.

The so-called supply chain attacks have been more and more an attack vector for bad actor whereas providers need to make sure every piece of the Integration is secure.

One area that was identified as something we can improve with Openshift and containers in general is when running as root on the container _may_ expose the host and process in that container may be able to mingle with other resources.

And this is a problem for us at the OpenShift pipelines team since this is what our shipped buildah ClusterTask does by default.

Ideally we would like to run everything rootless with a randomized user id, like what Openshift does by default. But there are some use-cases needing to run as root on the container but still be secure on the host.

In this article we will focus on Buildah but some of those techniques can be reused for different workloads, bear in mind that some of those technologies can be pretty bleeding edge, and you may encounter some unexpected side effects, but for the sake of a secure pipeline I would encourage you to try this out and see how it works out for you.

## **Running as root in a user namespace**

Running in a user namespace is when you are running the container as root (user id 0) but as user on the host.

OpenShift is using CRI-O as its container engine. And CRI-O has now a workload feature to be able to let the pod know it wants to run [“user namespaced”][1].

User namespaces is not a new feature; it has been here for a while, see for example this [2013 article][2] from the lwn introducing it. But it took some time to be included in RHEL (from RHEL8) and integrated into OpenShift (support was added in Openshift 4.10). If you want to try this feature manually you can refer to [this article][3] explaining how it works .

To run as a user in a namespace with Openshift Pipelines you need to be able to pass the annotations expected by CRIO to get the pods running user namespaced.

You can directly edit the buildah ClusterTask with “oc edit clustertask buildah” to add this to all users, or export the clustertask as a task to a specific Namespace.

With the latest tkn create from feature you can easily automate it :

```bash
oc new-project test
$ tkn task create --from=buildah
$ oc edit task buildah
```

And add the annotations to the task :

```yaml
annotations:
    io.kubernetes.cri-o.userns-mode: "auto"
    io.openshift.builder: "true"
```

Now if you are running the (currently unreleased) latest Openshift Pipelines 1.7 on OpenShift 4.10, you will see your buildah container running like before as root.

But if you adventure yourself behind the scene on the host of the pod :

```bash
# get the nodename where the buildah pod is with "oc get pod -o wide"
$ oc debug nodes/nodename
$ chroot /host
$ lsns -t user
```

OpenShift and CRIO did their magic and ran your pod in a “user namespace”.

## **Running as rootless in container**

To be able to run as rootless inside a container; where you run as a user inside the container, you need your container to do some setup to add the subuid and subgid provided from the latest shadow-utils package.

Thankfully the public image based on Red Hat UBI has everything already setup for us in its [Containerfile][4]

You have an extra step to take tho, you need to “force” running the container as
the “build” user, because if we start to leave it to the default it will be
“randomed” and would not have the setup needed to run as non-root.

Edit directly or export to a specific namespace the buildah clustertask as
described in the previous section.  Add this securityContext to each [build][5]
and [push][6] steps :

<pre>securityContext: runAsUser: 1000 </pre>

Since we are now going to be building as user, buildah will keep its image
caching in **/home/build/.local/cache** so instead of volume mounting
**/var/lib/containers** we are going to change the **mountPath** on build and
push steps to the user one :

```yaml
volumeMounts:
  - name: varlibcontainers
    mountPath: /home/build/.local/share/containers
```

And for demo purpose I have added this line at the beginning of the script task
:

`echo "Running as USER ID id"`

I have then created a [ConfigMap workspace][7] with a sample dockerfile and a
sample taskrun to be able to test it.

When running it, I can see my image is running as user :

```shell
% tkn tr logs -Lf buildah-run
[build] ++ id [build] Running as USER ID uid=1000(build) gid=1000(build) groups=1000(build),1000690000
[build] + echo 'Running as USER ID uid=1000(build) gid=1000(build)
groups=1000(build),1000690000'
[build] + buildah --storage-driver=vfs bud --format=oci --tls-verify=true --no-cache -f ./Dockerfile -t image-registry.openshift-image-registry.svc:5000/test/buildahuser .
[build] STEP 1: FROM registry.access.redhat.com/ubi8/ubi AS buildah-runner
[build] Getting image source signatures [build] Checking if image destination supports
signatures [build] Copying blob
sha256:adffa69631469a649556cee5b8456f184928818064aac82106bd08bd62e51d4e
[build] Copying blob sha256:26f1167feaf74177f9054bf26ac8775a4b188f25914e23bda9574ef2a759cce4
[build] Copying config sha256:fca12da1dc30ed8e7d03afb84b287fc695673fff9c04bfcb2ff404b558670a36
[build] Writing manifest to image destination
[build] Storing signatures
[build] STEP 2: RUN dnf -y update && dnf -y install git && dnf clean all
[build] Updating Subscription Management repositories.  […]
```

## More security with a custom SCC

Now these steps are working because currently on Openshift Pipelines we make all
taskrun/pipelinerun running automatically as the pipelines serviceAccount which
has the pipelines SecurityContext that allows running as any user.

We have added those rights to have it easy to to migrate pipelines that needs to
be run or build as root, but if you like to further lock down your installation
you can only allow running container as the user 1000 if the pod is asking (or
the container image forces it) for it and don’t let the container running as
root by default.

To do so you need to edit the pipelines-scc and modify the runAsUser and
seLinuxContext section to MustRunAs to uid 1000 :

```yaml
runAsUser:
  type: MustRunAs
  uid: 1000
  seLinuxContext:
    type: MustRunAs
```

The pipeline serviceaccount will only allow running images as user 1000 and not
as root anymore, if the images are not running as 1000 they will berandomed out as user id.

## Templates examples

This gist reference all the files I am mentioned int his article

* Buildah.yaml force running as user build : <https://gist.github.com/chmouel/8242806100ffa7164bb63d7d5b0a593d#file-buildah-task-yaml>

* Taskrun and Dockerfile configmap workspace: <https://gist.github.com/chmouel/8242806100ffa7164bb63d7d5b0a593d#file-buildah-taskrun-configmap-yaml>
* Modified scc only allow running as user 1000: <https://gist.github.com/chmouel/8242806100ffa7164bb63d7d5b0a593d#file-scc-runasuser-drop-anyuid-yaml>

 [1]: https://github.com/cri-o/cri-o/blob/main/docs/crio.conf.5.md#crioruntimeworkloads-table
 [2]: https://lwn.net/Articles/532593/
 [3]: https://www.redhat.com/sysadmin/building-container-namespaces
 [4]: https://catalog.redhat.com/software/containers/ubi8/buildah/602686f7b16b1eb2e30807ee?container-tabs=dockerfile
 [5]: https://github.com/tektoncd/operator/blob/main/cmd/openshift/operator/kodata/tekton-addon/addons/02-clustertasks/buildah/buildah-task.yaml#L63
 [6]: https://github.com/tektoncd/operator/blob/main/cmd/openshift/operator/kodata/tekton-addon/addons/02-clustertasks/buildah/buildah-task.yaml#L75
 [7]: https://github.com/tektoncd/pipeline/blob/main/docs/workspaces.md#configmap
