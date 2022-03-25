---
title: When Oracle dbstart/dbshut does not do anything
author: chmouel
type: post
date: 2010-04-23T10:06:24+00:00
url: /2010/04/23/when-oracle-dbstartdbshut-does-not-do-anything/
dsq_thread_id:
  - 252039401
tags:
  - Oracle

---
If like me you are surprised by the fact that dbstart or dbshut does not do anything when launching it, just make sure to edit the /etc/oratab and have the last char as Y and not N. Like if it is like this :

<p style="padding-left: 30px;">
  orcl:/u01/app/oracle/product/11.2.0/dbhome_1:N
</p>

change it to this :

<div id="_mcePaste" style="padding-left: 30px;">
  orcl:/u01/app/oracle/product/11.2.0/dbhome_1:Y
</div>