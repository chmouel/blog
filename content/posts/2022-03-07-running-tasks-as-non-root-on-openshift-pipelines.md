---
title: Running tasks as non root on OpenShift Pipelines
author: chmouel
date: 2022-03-07T08:04:02+00:00
url: /2022/03/07/running-tasks-as-non-root-on-openshift-pipelines/
showToc: true
tags:
  - OpenShift
  - Tekton
---
Expanding on my [previous blog post][1] on getting buildah to run with user namespaces or as rootless. There is another important security topic to talk about is how to run everything on OpenShift Pipeline as non root and not just the buildah task.

On OpenShift Pipelines we made the conscious decision to run all the TaskRuns and Pipelinerun by default under a custom ServiceAccount called `pipelines`.

That's it, unless overridden by the user in its pipelinerun or taskrun, it will use the `pipelines` ServiceAccount which has a few elevated privileges..

The ServiceAccount has a custom SecurityContext (SCC) called `pipelines-scc` bound to it which allows running an image as any UUID.

We added this service account because building and pushing images to a registry is a very common use case on OpenShift Pipelines and to get buildah working under OpenShift Pipelines root was previously the only solution to run buildah.

One side effect of this SCC is that any images running on Openshift Cluster, unless the container image has a _“USER $user_” in its dockerfile will run as root. So even standard tasks like the “git-clone” tasks end up checking out code as root when it really doesn’t need to.

If you want to run all your pipelines as non root (and you probably want it) and the images you are using have the ability to do it, you can make the `pipelines-scc` running everything by default as the user 1000 by modifying it.

Simply edit the scc as `cluster-admin` with `oc edit scc pipelines-scc` and modify the `runAsUser` section with :

```yaml
runAsUser:
  type: MustRunAs
  uid: 1000
```

The `ClusterTask` shipped with openshift-pipelines needs to have a slight modification when running as uid 1000, to get the volumeMount path corrected, you can grab the modified `buildah` task from here :

<https://gist.github.com/chmouel/8242806100ffa7164bb63d7d5b0a593d#file-buildah-task-yaml>

### Example

Here is an example pipeline :

<https://github.com/chmouel/scratchmyback/blob/f6a0329832ee55a339a7acec8095aba276d651a5/.tekton/pipeline.yaml>

It has three tasks.

  1. A git repository clone using the (modified) git-clone cluster task
  2. A simple task as taskspec which tests if we can write to the workspace where we have the source code checkout.
  3. A buildah task building a container and pushing it to the internal openshift registry.

When you run this pipeline you can see that everything with run as non root as user 1000 :

```bash
% tkn pr logs -Lf
[clone : clone] ++ id
[clone : clone] + echo ' Running as uid=1000 gid=0(root) ps=0(root),1000670000'
[clone : clone] Running as uid=1000 gid=0(root) groups=0(root),1000670000
[....]
[task-spec : task-spec] ++ id
[task-spec : task-spec] + echo ' I can write here I am uid=1000(1000) 0(root) groups=0(root),1000670000'
[task-spec : task-spec] + ls -l .
[task-spec : task-spec] total 52
[....]
userns-buildah : build] ++ id
[userns-buildah : build] Running as USER ID uid=1000(build) gid=1000(build) ps=1000(build),1000670000
[userns-buildah : build] + echo ' Running as USER ID uid=1000(build) 1000(build) groups=1000(build),1000670000'
[userns-buildah : build] + buildah --storage-driver=vfs bud --format=oci --tls-fy=true --no-cache -f ./Dockerfile -t image-registry.openshift-image-stry.svc:5000/test/userns:latest .
[userns-buildah : build] STEP 1: FROM registry.access.redhat.com/ubi8/ubi-mal:8.5
[...]
[userns-buildah : build] Storing signatures
[userns-buildah : build] STEP 2: RUN id
[userns-buildah : build] uid=0(root) gid=0(root) groups=0(root)
[userns-buildah : build] STEP 3: COMMIT image-registry.openshift-image-stry.svc:5000/test/userns:latest
[userns-buildah : build] --> 3637c099315
[userns-buildah : build] c0993158a555352c26ca9f8ed6406f916a708511b95f6135a8ba02432b96
[userns-buildah : push] ++ id
[userns-buildah : push] + echo ' Running as USER ID uid=1000(build) 1000(build) groups=1000(build),1000670000'
[userns-buildah : push] Running as USER ID uid=1000(build) gid=1000(build) ps=1000(build),1000670000
[userns-buildah : push] + buildah --storage-driver=vfs push --tls-verify=true --stfile /workspace/source/image-digest image-registry.openshift-image-stry.svc:5000/test/userns:latest docker://image-registry.openshift-image-stry.svc:5000/test/userns:latest
[...]
[userns-buildah : push] Writing manifest to image destination
[userns-buildah : push] Storing signatures
[...]
```

### Conclusion

There may be some restrictions when running rootless buildah where some images may not work but for most use cases this it should not need elevated priviliges to run your Tasks.

We are still exploring different solutions to make this more flexible and hopefully make this easier to set-up

 [1]: https://blog.chmouel.com/2022/01/25/user-namespaces-with-buildah-and-openshift-pipelines/ " previous blog post"
