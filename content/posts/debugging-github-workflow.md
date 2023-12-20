---
title: "How to debug GitHub Workflow with Tmate"
date: 2023-12-20T11:40:45+01:00
---
GitHub workflow is great but can be a bit of a black box when things go wrong.

When the YAML cannot be validated, GitHub offers a handy feature to debug the
workflow with [additional logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging).

But sometimes your deployment or tests, or whatever you are doing in your
workflow, fail when running on CI but not locally, and you are bound to end up
in the git push/commit Outer-Loop hell:

```bash
📝 vi file/to/add/debug.sh
🎹 git commit -a "debug ignore"
🫸 git push
👀 [watch logs failures]
♻️ [repeat]
🔞 [swear]
🤦 [hope that things start to work but no it's just another random timeout]
😭 [distress]
```

I **hate** this loop; it’s time-consuming, stupid, and wastes resources and energy
for the planet and everyone.

## Using tmate, your best mate ever

Somebody made <tmate.io>, and that’s an incredible public service! It lets you
SSH with a unique URL (via SSH public/private keys) to the VM running on GitHub
actions and allows you debug your running VM.

I probably would not use that for sensitive repositories, but if you are just
running Open Source projects, then it’s probably fine.

You can enable it on your workflow on demand via the workflow_dispatch. First,
add at the top of your workflow in your on section:

```yaml
on:
  workflow_dispatch:
    inputs:
      debug_enabled:
        type: boolean
        description: 'Run the build with tmate debugging enabled (https://github.com/marketplace/actions/debugging-with-tmate)'
        required: false
        default: false
```

Then, add somewhere in your steps (after doing some pre-setup, for example) and
before running your actual test:

```yaml
      - name: Setup tmate session
        uses: mxschmitt/action-tmate@v3
        if: ${{ github.event_name == 'workflow_dispatch' && inputs.debug_enabled }}
        with:
          limit-access-to-actor: true
```

When you need to debug your Workflow, you simply can use the gh CLI to run the
workflow_dispatch with the debug variable enabled.

```bash
$ gh workflow run -f debug_enabled=true .github/workflows/my_workflow.yaml
```

It will stop at the tmate step in your workflow and show you an SSH URL which
you can connect to with your SSH private key and happily debug your tests or
deployment in there.

There are multiple other options for the workflow; head over to the [tmate action](https://github.com/mxschmitt/action-tmate)
repository to see what other options you can pass.
