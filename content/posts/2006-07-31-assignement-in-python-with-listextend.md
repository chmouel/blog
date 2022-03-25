---
title: Assignement in Python with list.extend()
author: chmouel
type: post
date: 2006-07-31T06:54:13+00:00
url: /2006/07/31/assignement-in-python-with-listextend/
dsq_thread_id:
  - 263934400
tags:
  - Python

---
This is weird for me :

<pre lang="python">d = ['foo', 'bar', 'ba', 'c']
print d
f = d
f.extend(d)
print d
</pre>

give me the result

<p style="margin-left: 40px">
  -*- mode: compilation; default-directory: "/tmp/" -*-<br /> Compilation started at Mon Jul 31 16:49:41
</p>

python "/tmp/a.py"  
['foo', 'bar', 'ba', 'c']  
['foo', 'bar', 'ba', 'c', 'foo', 'bar', 'ba', 'c']

Compilation finished at Mon Jul 31 16:49:4

It seems that extend assign as well the non extended part (d) which is confusing because to merge list i need to use temporary variable.