---
title: "Navigating the pull_request_target conundrum in GitHub Actions with Pipelines as Code"
date: 2025-03-25T00:54:49+02:00
draft: false
---

GitHub's [`pull_request_target`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request_target)
event presents a significant security challenge due to its access to the pull
request within the *target* repository's context. This can expose sensitive
secrets to untrusted users submitting pull requests.

For projects like Pipelines-as-Code (PAC), where interaction with multiple
upstream providers (Bitbucket, GitLab, GitHub) is essential, this risk is
amplified. Access to repository secrets is vital for E2E testing across these
platforms, yet arbitrary pull requests triggering secret-laden workflows is
unacceptable.

Restricting pull requests to originate solely from repository branches would
mitigate this risk, but it would also severely limit external contributions—a
trade-off we aimed to avoid.

## Exploring Alternatives: GitHub Environments and Workflow Dispatch

Initially, [GitHub
Environments](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
were considered. Configuring workflows to run only within specific environments
allows for leveraging GitHub's built-in approval mechanism. This offers a
user-friendly approval button in the UI. However, it necessitates manual
approval for *every* workflow execution, including automated nightly runs,
which becomes cumbersome.

Next, the
[`workflow_dispatch`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch)
event was explored. This involved a PAC PipelineRun that triggers the workflow
dispatch API and monitors its completion. The appeal lies in utilizing PAC's
robust permission control features. Approved users can trigger E2E tests by
commenting `/ok-to-test` on pull requests, while non-approved users have the
workflow automatically initiated.

However, several challenges arose. While the GitHub Actions workflow was
triggered with the correct SHA and input arguments, it failed to accurately
target the specified SHA during execution. This resulted in inaccurate status
updates in the UI. Additionally, reliably retrieving the run ID of a newly
created workflow dispatch proved difficult.

Ultimately, this approach proved overly complex and challenging to debug,
prompting a search for a simpler, more transparent solution.

## The Solution: Automating with GitHub Labels and PAC

The solution involved leveraging GitHub labels, specifically the `e2e` label,
to trigger our E2E testing workflow. This approach offers several advantages:

- **Explicit Triggering:** Workflows are triggered only when the `e2e` label is added.
- **Transparency:** The label's presence is clearly visible in the pull request UI.
- **Simplicity:** This method avoids the complexities of API-based triggering and run ID management.

To automate the label application, we utilize a [Pipelines-as-Code
(PAC)](https://pipelinesascode.com/) PipelineRun. This PipelineRun is triggered
on pull requests targeting the `main` branch and involving changes to specific
files (e.g., Go files, workflow configurations).

```yaml
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: e2e-label.yaml
  annotations:
    pipelinesascode.tekton.dev/on-event: "pull_request"
    pipelinesascode.tekton.dev/on-target-branch: "main"
    pipelinesascode.tekton.dev/on-path-change: "[***/*.go, .github/workflows/*l]"
spec:
  pipelineSpec:
    tasks:
      - name: label-pr
        taskSpec:
          steps:
            - name: label-pr
              image: registry.access.redhat.com/ubi9/ubi
              env:
                - name: HUB_TOKEN
                  valueFrom:
                    secretKeyRef:
                      name: "nightly-ci-github-hub-token"
                      key: "hub-token"
              script: |
                #!/usr/bin/env python3
                # ... Python script to add the 'e2e' label ...
```

This PipelineRun runs within the context of [PAC's Access Control List](https://nightly.pipelines-as-code.pages.dev/docs/guide/running/#acl-permissions-for-triggering-pipelineruns)
(ACL) authorization, which is highly flexible. This allows us to define
specific rules for when the `e2e` label should be applied. For example, we can
restrict label application to pull requests originating from trusted users or
those meeting specific criteria.

By configuring the GitHub workflow to trigger both when the label is added and
when it already exists, we ensure that the workflow is executed for all
relevant pull requests. This automation, driven by PAC's flexible ACL,
significantly streamlines the E2E testing process.

Another benefit of this approach is that if the automatic labeling fails to apply—such as when the Pull Request doesn’t involve any Go files but still requires testing—a GitHub repository admin can manually add the `e2e` label. This manual addition will trigger the workflow. Previously, the workflow would not have been triggered at all unless it specifically targeted changes in Go files.

```yaml
name: E2E Tests

on:
  pull_request_target:
    types:
      - labeled
      - opened
      - reopened
      - synchronize

jobs:
  e2e-tests:
    if: >
      github.event_name == 'pull_request_target' && (github.event.label.name == 'e2e' || contains(github.event.pull_request.labels.*.name, 'e2e'))
    # ... rest of the workflow configuration
```

## Conclusion

The `pull_request_target` event in GitHub Actions presents inherent security
risks. By exploring alternative solutions and ultimately adopting a label-based
triggering mechanism, coupled with PAC's automated labeling and flexible
authorization, a more secure, transparent, and manageable E2E testing workflow
is established. This approach allows for maintaining a balance between
security and the ability to accept contributions from external developers,
while automating the triggering process.

## Links

- Our E2E testing workflow: [e2e.yaml](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/.github/workflows/e2e.yaml)
- Our Pipelines-as-Code PipelineRun that automates labeling: [e2e-label.yaml](https://github.com/openshift-pipelines/pipelines-as-code/blob/main/.tekton/e2e-label.yaml)
- [Understanding `pull_request` vs `pull_request_target`](https://runs-on.com/github-actions/pull-request-vs-pull-request-target/)
- [GitHub Actions Documentation on `pull_request_target`](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request_target)
- [Pipelines as Code Documentation](https://pipelinesascode.com/)
