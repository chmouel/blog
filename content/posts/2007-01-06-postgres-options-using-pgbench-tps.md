---
title: 'Benchmarking with PGBench: TPS results.'
author: chmouel
date: 2007-01-06T08:19:23+00:00
url: /2007/01/06/postgres-options-using-pgbench-tps/
dsq_thread_id:
  - 255677496
tags:
  - postgres

---
**pgbench** is not the best tools to benchmark postgres but it's  
the one shipped by default with postgres.  
It does not do a good job for benchmarking your "web apps" SQL wise, it will give you some  
good indication about how fast is your server for postgres.

Here are some results we have collected using theses options :

<pre>pgbench -Uuser  -s 10 -c 10 -t 3000 benchmark
</pre>

We configure servers with RAID 1+0 with write-cache and a battery  
backup, we have tested with postgres 8.1.5 and here are the best  
results for different type of servers :

IBM x3650 : 729tps  
HP DL385 : 717tps  
Dell PowerEdge 2950: 708tps