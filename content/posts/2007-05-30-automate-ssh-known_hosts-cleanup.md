---
title: Automate SSH known_hosts cleanup
author: chmouel
date: 2007-05-30T22:33:40+00:00
url: /2007/05/30/automate-ssh-known_hosts-cleanup/
dsq_thread_id:
  - 252039342
tags:
  - Scripts

---
If you like me, you have to do a lot of installs[1] of the same test machine with the same IP and have to ssh it you will notice this annoying message :

<pre>IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that the RSA host key has just been changed.
The fingerprint for the RSA key sent by the remote host is
54:9d:c0:37:3a:80:48:6c:82:ec:d1:84:93:61:24.
Please contact your system administrator.
Add correct host key in /home/cboudjnah/.ssh/known_hosts
to get rid of this message.
Offending key in /home/cboudjnah/.ssh/known_hosts:595
Password authentication is disabled to avoid
 man-in-the-middle attacks.
Keyboard-interactive authentication is disabled to avoid
man-in-the-middle attacks.
Agent forwarding is disabled to avoid man-in-the-middle attacks.</pre>

I have automated the cleanup by a script :  
[code lang="bash"]  
#!/bin/bash  
H=$1

[[ -z ${H} ]] && { echo "Need a host as argument"; exit 1 ;}  
LINE=$(ssh -o StrictHostKeyChecking=yes $1 'exit' 2>&1 | sed -n '/Offending key/ { s/.*://;s/r//;p }')  
[[ -z ${LINE} ]] && { echo "Nothing to clean"; exit; }  
sed -i -n "$LINE!p" ~/.ssh/known_hosts[/code]  
[1] Like having to tests bunch of [FAI][1].

 [1]: http://www.informatik.uni-koeln.de/fai/