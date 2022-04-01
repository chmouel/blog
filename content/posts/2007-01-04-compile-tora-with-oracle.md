---
title: Compile tora with oracle
author: chmouel
date: 2007-01-04T22:19:28+00:00
url: /2007/01/04/compile-tora-with-oracle/
dsq_thread_id:
  - 252039326
tags:
  - Oracle

---
After installing Oracle instant client, if you have them in /usr/local/lib/instantclient\_10\_2, this is the command line i use :

./configure --with-instant-client=/usr/local/lib/instantclient\_10\_2 --with-oracle-includes=/usr/local/lib/instantclient\_10\_2/sdk/include --with-oracle-libraries=/usr/local/lib/instantclient\_10\_2 --with-oci-version=10G

Let me know ny email if you want the deb for ubuntu linux.