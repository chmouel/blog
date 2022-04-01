---
title: Network manager and iwl3945 not showing network
author: chmouel
date: 2009-08-10T15:11:57+00:00
url: /2009/08/10/network-manager-and-iwl3945-not-showing-network/
dsq_thread_id:
  - 261514251
tags:
  - Debian
  - Debian

---
So if you have network-manager not detecting wireless networks it is probably because lately the driver need to be set as up to get the thing going.

On my Debian I have added this to make it works :

`echo "/sbin/ip link set wlan0 up"|sudo tee /etc/default/NetworkManager`