---
title: "How to debug GitHub Workflow with Tmate"
date: 2023-12-20T11:40:45+01:00
draft: true
---

GitHub workflow is great but can be a bit of a blackbox when things go wrong.

When the YAML cannot be validated, GitHub has a handy features with the debug
logging feature:

https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging

But sometime your deployment or tests, or whatever you are doing in your
workflow fails when running on CI but not locally and you are bound to end up in
the git push/commit Outer-Loop *hell*:

```bash
vi file/to/add/debug.sh
git commit -a "debug ignore"
git push
[watch logs failures]
[repeat]
```

I hate this loop, it's time consuming, stupid and waste resources and energy for
the planet and everyone.

## Using tmate.io

Somebody made <https://tmate.io> and that's an incredible public service ! It
let you ssh with a unique URL (via ssh public/private keys) to the VM running on
GitHub actions and let you debug.

I probably would not use that for sensible repositories but if you are just
running Open Source projects then it's probably fine.

You can enable on your workflow on demand via the `worflow_dispatch`. First add
at the top of your workflow in your `on` section:

```yaml
  workflow_dispatch:
    inputs:
      debug_enabled:
        type: boolean
        description: 'Run the build with tmate debugging enabled (https://github.com/marketplace/actions/debugging-with-tmate)'
        required: false
        default: false
```

and then add somewhere in your steps (after doing some pre setup for examples)
and before running your actual test:

```yaml
      - name: Setup tmate session
        uses: mxschmitt/action-tmate@v3
        if: ${{ github.event_name == 'workflow_dispatch' && inputs.debug_enabled }}
        with:
          limit-access-to-actor: true
```

when you need to debug your Workflow you simply can use the
[gh](https://github.com/cli/cli) CLI to run the workflow_dispatch with the debug
variable enabled.

```console
$ gh workflow run -f debug_enabled=true .github/workflows/my_workflow.yaml
```

It will stop onto the tmate step on your workflow and show you a SSH URL which
you can connect to with your SSH private key and happily debug your tests or
deployment in there.

There is multiple options to the workflow, head over to the tmate action
repository to see what other options you can pass.

<https://github.com/mxschmitt/action-tmate>
