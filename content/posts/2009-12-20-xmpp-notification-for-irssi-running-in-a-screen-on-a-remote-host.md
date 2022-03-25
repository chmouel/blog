---
title: XMPP notification for irssi running in a screen on a remote host
author: chmouel
type: post
date: 2009-12-20T15:41:55+00:00
url: /2009/12/20/xmpp-notification-for-irssi-running-in-a-screen-on-a-remote-host/
dsq_thread_id:
  - 252039394
tags:
  - Linux
  - Misc
  - Python

---
Like a lot of people I have my irssi on a server in a screen. This has  
been working great so far but my only concerns are the notifications  
on the desktop when something happening.

Over the time I have found some different solution with mitigated  
results for me :

- Use fanotify script with the libnotify-bin and SSH like mentioned [here][1].

- Setup your irssi (or other) as irc proxy bouncer and connect with  
your desktop client (like xchat) to get notification. 

The fanotify is kind of very hacky on a laptop with intermittent  
connection and having a cron doing a ssh every minutes or so is not  
ideal, not talking about no passphrase ssh key or having to snoop the  
SSH_AGENT variable to connect without password.

The via proxy method is not my thing and I don't feel like having  
xchat open all the time just for it and I anyway usually forget to  
launch it.

My solution is to have a plugin for irssi notify me via XMPP if there  
is a direct message addressed to me. I usually get my pidgin or gmail  
alway open and if i don't since it goes to a gmail account I got gmail  
sending me an email about it.

You can find all the information about the install and configuration  
here :

[http://github.com/chmouel/irssi-xmpp-notify  
][2]

 [1]: http://thorstenl.blogspot.com/2007/01/thls-irssi-notification-script.html
 [2]: http://github.com/chmouel/irssi-xmpp-notify