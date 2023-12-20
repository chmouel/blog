---
title: "Gosmee Webhook Forwarder Relayer"
date: 2023-12-20T13:22:06+01:00
---
I use "Webhook" every day; it's a simple mechanism used by most web
applications to send payloads on events. It's great and all, but since it needs to
send you data, it has to be exposed to the internet. And that's where it gets
tricky. If you are in development mode and want to test the webhook, you can't
just expose your local machine to the internet; you need some sort of
solution for that.

There are a lot of solutions for that, but most of them are either paid or require
some pre-setup. At [work](https://redhat.com/security), our Security team is very
pedantic about things that can go in when you have things behind the VPN; the only
service that is allowed is: <https://smee.io>

## smee.io Service

`smee.io` is a great service! It lets you expose a local port to the internet
as simply as that. It's all open source, but you can use their instance on
<https://smee.io> for free. They have this client called
[smee-client](https://github.com/probot/smee-client) which you can run locally
to fetch the events from the server and replay them on a local service.

I encountered some issues with the client (not being able to set the Host header
behind a proxy) and found it challenging to deploy the Node.js version. So, I
quickly went looking for alternatives and discovered [pysmee](https://github.com/Akrog/pysmee),
which worked for me for a while. However, I later faced some [issues with chunked
transfer](https://github.com/Akrog/pysmee/issues/5) due to a Python update,
which broke it.

The project didn't seem to be updated, and since our CI depended on this,
I had to figure out a proper solution for this.

## Creating Gosmee

Since it seemed to be a perfect fit for go, I looked on how to do my own
implementation.

Using the [r3labs/sse](https://github.com/r3labs/sse) Go library, I made a quick
implementation that connects to `smee.io` and replays events on another server.

This was quite straightforward, and since it was in `Go`, it makes it easy to
distribute and run in the cloud, which is a perfect fit for when running on
`Kubernetes` to expose a local `Deployment/Service` to the internet.

Here is a handy diagram showing how it works:

<img src="gosmee-diag.png">

![gosmee diagram](gosmee-diag.png)

## Debugging Webhook with the Saved Script

I added a feature that I find crucial to my workflow: the ability to replay a
webhook without having to resend a commit. When you add the flag `--saveDir` and
point it to a directory, it saves the full payload to a JSON file and creates a
handy shell script with the correct headers, as seen from the server, for `curl` to
send over to your local service. This allows you to "Re-run" the request easily, and
furthermore, if you plug a debugger into it, it makes debugging a bug easy.

These days, when someone reports a bug on `pipelines-as-code` and I need to
debug the query, I ask them to:

- Change the webhook URL to a `smee.io` URL.
- Provide me with the kubeconfig of their test cluster.
- Replay the action that wasn't working.

I plug `gosmee --saveDir` into that `smee.io` URL, connect with their kubeconfig,
and run a debugger while replaying the action via the shell script and can
easily reproduce (and hopefully fix) the bug.

## Gosmee server

All this things was great until `smee.io` wasn't available anymore, it was down
for a few weeks due of some abuse and our CI was broken again...

You can run the [smee.io server](https://github.com/probot/smee.io) easily and
I should have probably have done that and go on with my day but instead since I
did find it interesting I implemented a server into `gosmee` available as
`gosmee server` with the ideas of adding more features like `authentication` in
the feature (spoiler: I didn't do it since webhook is not really designed for
that).

I wasn't sure if it was going to scale but since I have started running it on
<https://hook.pipelinesascode.com> behind a [caddy
server](https://caddyserver.com/) on the smallest Amazon public VM I could find,
I never had issues with it and happily run this for everyone who wants an
alternative to `smee.io`.

## Gosmee Replay via GitHub API

I could probably have been done with this and called it a day, but then I stumbled
onto the GitHub API documentation and saw that they have started to have the ability to [list
deliveries](https://docs.github.com/en/rest/repos/webhooks?apiVersion=2022-11-28)
I thought this would be an interesting fit for `gosmee`.

This has the advantage of being able to replay any webhook deliveries even if the
server or client was down, but it has the disadvantage of being specific to GitHub
(unless there are other services offering that API that I don't know about).
Furthermore you don't have to trust a external service or deploy your own.

So, the `gosmee replay` feature is born. It only supports repository webhook for
now, but I am planning to have organization webhook or even GitHub Apps webhook
replaying.

There is more things I want to add to the `gosmee replay` feature, like being
able to see the payload and replay a specific one directly in a interactive way,
so hopefully there is even more to do here...
