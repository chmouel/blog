---
title: How to Make a Release Pipeline with Pipelines as Code
author: Chmouel
date: 2021-07-01T12:44:25+00:00
url: /2021/07/01/how-to-make-a-release-pipeline-with-pipelines-as-code/
---

One of the early goals of [Pipelines as Code](https://github.com/openshift-pipelines/pipelines-as-code/) on Tekton was to ensure the project’s CI could run using itself.

The common use case of validating pull requests was quickly implemented, and you can find more information about it in this walkthrough video:

{{< youtube cNOqPgpRXQY >}}

For slightly more advanced use cases, here is how we created a release pipeline for the project.

The goal is that when we tag a release and push the tags to the GitHub repository, it will:

- Generate the `release.yaml` file for that version, allowing users to automatically run `_kubectl apply -f-_`.
- Upload the `release.yaml` to a `release-${version}` branch.
- Generate the `tkn-pac` binaries for different operating systems.
- Create the GitHub release.

## Repository Configuration

To achieve this, I created a `Repository` Custom Resource (CR) in the `pipelines-as-code-ci` namespace:

```yaml
apiVersion: pipelinesascode.tekton.dev/v1alpha1
kind: Repository
metadata:
  name: pipelines-as-code
spec:
  url: https://github.com/openshift-pipelines/pipelines-as-code
```

The key part is the `branch` and `event_type` fields, which specify that all pushed tags should be handled and run in the `pipelines-as-code-ci` namespace.

## PipelineRun Configuration

Next, I created a [release-pipeline.yaml](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/.tekton/release-pipeline.yaml) `PipelineRun` in the `.tekton` directory, adding the necessary annotations:

```yaml
pipelinesascode.tekton.dev/on-event: "[push]"
pipelinesascode.tekton.dev/on-target-branch: "[refs/tags/*]"
```

This configuration ensures the `PipelineRun` handles all push tag events.

## Tasks

In the tasks, I included the `git-clone` task and a custom version of the `goreleaser` task, located in the repository at `.tekton/task/goreleaser.yaml`.

The annotation for these tasks looks like this:

```yaml
pipelinesascode.tekton.dev/task: "[git-clone, .tekton/tasks/goreleaser.yaml]"
```

[Goreleaser](https://goreleaser.com/) simplifies many tasks for us. It compiles binaries, creates a GitHub release, and can generate a [Homebrew](https://brew.sh) release in the [openshift-pipelines/homebrew-pipelines-as-code](https://github.com/openshift-pipelines/homebrew-pipelines-as-code/) repository. This allows users on macOS or LinuxBrew to easily install it:

```shell
brew install openshift-pipelines/pipelines-as-code/tektoncd-pac
```

## Uploading the Release

Uploading the `release.yaml` is handled by a Python script I wrote:

<https://github.com/openshift-pipelines/pipelines-as-code/blob/main/hack/upload-file-to-github.py>

The script fetches the tag SHA, creates a `release-${tagversion}` branch, and pushes the file into it. This provides a stable branch with all artifacts specific to that version.

## Final Steps

After everything is in place, I edit the GitHub release, update a few fields for a nicer presentation, and set it as a release (by default, Goreleaser creates a prerelease).

![GitHub Release Screenshot](/wp-content/uploads/2021/07/image-1024x354.png)

## Useful Links

Here are links to all the related files:

- [.goreleaser.yaml](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/.goreleaser.yml) - The configuration file for Goreleaser.
- [upload-file-to-github.py](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/hack/upload-file-to-github.py) - The Python script to upload files directly to GitHub.
- [.tekton/release-pipeline.yaml](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/.tekton/release-pipeline.yaml) - The Tekton release pipeline.
