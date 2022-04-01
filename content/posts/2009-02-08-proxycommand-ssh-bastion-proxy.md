---
title: Using ProxyCommand with OpenSSH and a Bastion server.
author: chmouel
date: 2009-02-08T12:21:38+00:00
url: /2009/02/08/proxycommand-ssh-bastion-proxy/
dsq_thread_id:
  - 252709825
tags:
  - Scripts

---
So at work we have to use a <a href="http://en.wikipedia.org/wiki/Bastion_host" target="_blank">bastion host</a> for all our connections to servers to be able to get called [PCI][1] compliant. This kind of stuff could be a pain to use when you have to use another host to do RSYNC/SCP or other stuff that need direct transfer to workstation.

Thankfully OpenSSH is very flexible and have multiple options to easy the pain. If you add this to your ~/.ssh/config :

> Host bastion  
> Hostname <span style="color: #ff9900;"><em>IP_ADDRESS_OF_BASTION_SERVER</em></span>  
> User <span style="color: #ff9900;"><em>YOUR_USERNAME</em></span>  
> ProxyCommand none  
> ControlMaster auto  
> ControlPath ~/.ssh/master-%r@%h:%p
> 
> Host *  
> ProxyCommand ssh -qax bastion 'nc -w 600 %h %p'

This will allow you to pass all SSH requests to the bastion server.

I have experimented with different options and this seems to be most efficient way. The ControlMaster ControlPath is to speed up the connections by not reopening a tcp socket all the time to the bastion server. This seems to cause problems with the OpenSSH version shipped with some distros (ie: Fedora) so you may want to remove it if you experience problems. For the ProxyCommand there is way to use cat like this :

> ProxyCommand ssh bastion 'exec 3<>/dev/tcp/%h/22;(cat <&3 & );cat >&3'

but the cat processes seems to hang in memory on the bastion server so netcat seems a better option.  I heard that tcpconnect from the <a href="http://linux.about.com/cs/linux101/g/tcputils.htm" target="_blank">tcputils </a>package should make things smoother but I haven't tried that.

I have other options in my SSH configuration to allow to be less verbose see [ssh_config(5)][2] manpage for detailed description of each of these options :

> Host *  
> ForwardAgent yes  
> GSSAPIAuthentication no  
> VerifyHostKeyDNS no  
> StrictHostKeyChecking no  
> HashKnownHosts no  
> TCPKeepAlive yes  
> ServerAliveInterval 600

By the way forgot to mention you would need to have SSH key exchange configured with the bastion server with a SSH agent runing (these days all distros should do that by default) to don't have to type the password of your username on bastion server.

I have heard there is way to do that on Windows with putty and plink but I haven't tried that see this post <a href="http://fixunix.com/ssh/74073-putty-proxycommand.html" target="_blank">here</a> about it.

 [1]: http://www.pcicomplianceguide.org/
 [2]: http://www.openbsd.org/cgi-bin/man.cgi?query=ssh_config