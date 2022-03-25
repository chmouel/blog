---
title: Nokia N95 bluetooth teethering with T-Mobile under Linux and Delll Latitude D630
author: chmouel
type: post
date: 2009-10-30T08:55:53+00:00
url: /2009/10/30/nokia-n95-bluetooth-teethering-with-t-mobile-under-linux-and-delll-latitude-d630/
dsq_thread_id:
  - 264470172
tags:
  - Debian
  - Linux

---
Spent a bit of time to configure my Nokia mobile to teethering wih my Linux and T-Mobile. Here is some steps that may help the others :

  * If you don't have that blue bluetooth led switched on on your Dell Latitude D630 Laptop you have to enable it. I haven't find any way to do that via the Linux Kernel module but with Windows under Vmware Player (3.0) enabling Bluetooth and installing the [driver][1] (manually not via the setup.exe) enabled bluetooth.
  * Switched on bluetooth on the Phone and attached to the laptop via gnome bluetooth applet thingy.
  * Get my phone device number from hcitool scan.
  * And did this (as root) :

> cat </etc/bluetooth/rfcomm.conf  
> #  
> \# RFCOMM configuration file.  
> #
> 
> rfcomm0 {  
> \# Automatically bind the device at startup  
> bind yes;
> 
> \# Bluetooth address of the device  
> device YOUR:PHONE:DEVICE:NUMBER;
> 
> \# RFCOMM channel for the connection  
> channel 4;
> 
> \# Description of the connection  
> comment "Nokia N95";  
> }  
> EOF
> 
> /etc/init.d/bluetooth restart
> 
> cat </etc/ppp/chat-tmobile  
> ABORT BUSY  
> ABORT 'NO CARRIER'  
> ABORT 'NO ANSWER'  
> ABORT ERROR  
> REPORT CONNECT  
> SAY 'Calling t-mobile...\n'  
> "" 'ATZ'  
> OK 'ATE0V1&D2&C1S0=0+IFC=2,2'  
> SAY 'Modem reset.\n'  
> SAY 'Setting APN...'  
> OK 'AT+cgdcont=1,"IP","general.t-mobile.uk"'  
> SAY 'APN set\n'  
> SAY 'Dialling...\n'  
> OK 'ATDT*99#'  
> TIMEOUT 30  
> CONNECT ""  
> EOF
> 
> cat </etc/ppp/peers/t-mobile  
> /dev/rfcomm0  
> 460800  
> idle 7200  
> modem  
> noauth  
> lock  
> crtscts  
> defaultroute  
> user "user"  
> password "pass"  
> noipdefault  
> usepeerdns  
> updetach  
> noccp  
> nobsdcomp  
> #novj  
> ipcp-restart 10  
> ipcp-accept-local  
> ipcp-accept-remote  
> lcp-echo-interval 65535  
> lcp-echo-failure 10  
> lcp-max-configure 10  
> connect "/usr/sbin/chat -v -f /etc/ppp/chat-tmobile"  
> EOF

Under Debian distros you can enable the connection with the command 'pon t-mobile' or you for the others can do via the manual way with the command 'pppd call t-mobile'.

 [1]: http://support.dell.com/support/downloads/download.aspx?c=ca&l=en&s=gen&releaseid=R155172&SystemID=LATITUDE%20D630&servicetag=&os=WW1&osl=en&deviceid=13911&devlib=0&typecnt=0&vercnt=1&catid=-1&impid=-1&formatcnt=1&libid=5&fileid=206919 "Dell Latitude Driver"