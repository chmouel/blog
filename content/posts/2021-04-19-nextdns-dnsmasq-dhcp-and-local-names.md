---
title: NextDNS + DNSMasq DHCP and local names
author: chmouel
date: 2021-04-19T07:42:47+00:00
url: /2021/04/19/nextdns-dnsmasq-dhcp-and-local-names/
---
Took me a little bit a while to figure out so here is some documentation,

My [router from my ISP][1] which is generally pretty good, doesn't support local dns names which is annoying in itself. Combined with NextDNS, I have no way to identify the devices on my network.

So there I went configured dnsmasq on my tiny raspbery-pi :

```
port=5353
no-resolv
interface=eth0
except-interface=lo
listen-address=::1,192.168.0.3
no-dhcp-interface=
bind-interfaces
cache-size=10000
local-ttl=2
log-async
log-queries
bogus-priv
server=192.168.0.3
add-mac
add-subnet=32,128

```


This would have the dnsmasq service listening on 192.168.0.3:5353 and forward everything to 192.168.0.3.

I continued and set my DHCP server :


```
dhcp-authoritative
dhcp-range=192.168.0.20,192.168.0.251,24h
dhcp-option=option:router,192.168.0.254
dhcp-name-match=set:wpad-ignore,wpad
dhcp-name-match=set:hostname-ignore,localhost
dhcp-ignore-names=tag:wpad-ignore
dhcp-mac=set:client_is_a_pi,B8:27:EB:*:*:*
dhcp-reply-delay=tag:client_is_a_pi,2
dhcp-option=option:dns-server,192.168.0.3
dhcp-option=option:domain-name,lan

domain=lan
dhcp-option=option6:dns-server]
dhcp-range=::100,::1ff,constructor:eth0,ra-names,slaac,24h
ra-param=*,0,0

```



Standard DHCP really just make sure you setup the router to your local router, here it's 0.254 in my config.

I then configured the [nextdns client][2] on 192.168.0.3 default DNS port 53 :

```
cache-size 0
report-client-info true
setup-router false
log-queries true
config CONFIG_ID_FROM_NEXTDNS_GET_IT_FROM_THERE
cache-max-age 0s
timeout 5s
control /var/run/nextdns.sock
forwarder .lan.=192.168.0.3:5353
max-ttl 5s
discovery-dns 192.168.0.3:5353
hardened-privacy false
bogus-priv true
auto-activate false
listen 192.168.0.3:53
use-hosts true
detect-captive-portals false
```


The key setings is the discovery-dns setting, it means it would try to discover the local names to display on the nextdns web UI and resolve all lan domain to the local dnsmasq server.

And that's it.... Hope this helps.

 [1]: https://en.wikipedia.org/wiki/Freebox
 [2]: https://github.com/nextdns/nextdns
