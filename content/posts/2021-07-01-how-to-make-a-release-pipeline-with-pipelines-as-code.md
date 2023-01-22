---
title: How to make a release pipeline with Pipelines as Code
author: chmouel
date: 2021-07-01T12:44:25+00:00
url: /2021/07/01/how-to-make-a-release-pipeline-with-pipelines-as-code/
---
One of the early goal of <a href="https://github.com/openshift-pipelines/pipelines-as-code/" data-type="URL" data-id="https://github.com/openshift-pipelines/pipelines-as-code/">Pipelines as Code</a> on Tekton is to make sure we were able to have the project CI running with itself.

The common user case of validating pull request was quickly implemented and you can find more information about it in this walkthough video :


{{< youtube Uh1YhOGPOes >}}

For slightly more advanced use case here is how we made a release pipeline for the project.

The goal is when we tag a release and push the tags to the GitHUB repo it will

  * Generate the release.yaml file for that version for user to automatically _`kubectl apply -f-`_ it.
  * Upload that release.yaml to a `release-${version} branch`
  * Generate the `tkn-pac` binaries for the different Operating Systems
  * Generate the GitHUB release.

To be able to do so, I created a Repository CR in the `pipelines-as-code-ci` namespace:

```yaml
apiVersion: pipelinesascode.tekton.dev/v1alpha1
kind: Repository
metadata:
  name: pipelines-as-code-ci-make-release
  namespace: pipelines-as-code-ci
spec:
  branch: refs/tags/*
  event_type: push
  namespace: pipelines-as-code-ci
  url: https://github.com/openshift-pipelines/pipelines-as-code
```

The key part is the `branch` and `event_type` spec fields, where in plain
english means I want to have all the tags push handled and run in the namespace
`pipelines-as-code-ci`

I then created a [release-pipeline.yaml][3] PipelineRun in my `.tekton`
directory with the annotations needed:

```yaml
pipelinesascode.tekton.dev/on-event: "[push]"
pipelinesascode.tekton.dev/on-target-branch: "[refs/tags/*]"
```

```

Which mean in pain english that this pipelinerun will handle all on push tags events.

In my tasks I need the git-clone tasks and a custom version of the goreleaser
task located inside my repository in [.tekton/task/goreleaser.yaml][4].

The annotation for this looks like this :

```yaml
pipelinesascode.tekton.dev/task: "[git-clone, .tekton/tasks/goreleaser.yaml]"
```

[Goreleaser](https://goreleaser.com/) takes care of a lot of things for us, it compiles all binary and make a release in GitHub, it as well has the ability to generate a [homebrew](https://brew.sh) release in [openshift-pipelines/homebrew-pipelines-as-code/](https://github.com/openshift-pipelines/homebrew-pipelines-as-code/) so user on OSX or LinuxBrew can easily just do :

```shell
brew install openshift-pipelines/pipelines-as-code/tektoncd-pac
```

Uploading the release.yaml si done with a Python script I wrote for it :

<https://github.com/openshift-pipelines/pipelines-as-code/blob/main/hack/upload-file-to-github.py>

It will fetch the tag SHA and create a branch release-${tagversion} and push the file into it. This gives a stable branch with all the artifacts specifique to that version.

After all of that, I just need to edit the release and change a few fields to make it a bit nicer and set it as release (by default goreleaser do a prerelease)

![](/wp-content/uploads/2021/07/image-1024x354.png)

Here is the link to all the files :

* [.gorelease.yaml](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/.goreleaser.yml) the configuration file for goreleaser
* [upload-file-to-github.py](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/hack/upload-file-to-github.py) - The python script to upload a file to GitHub directly
* [.tekton/release-pipeline.yaml](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/.tekton/release-pipeline.yaml) - The tekton release pipeline
