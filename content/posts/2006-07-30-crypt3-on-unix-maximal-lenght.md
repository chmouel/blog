---
title: crypt(3) on unix maximal length
author: chmouel
date: 2006-07-30T12:50:45+00:00
url: /2006/07/30/crypt3-on-unix-maximal-lenght/
dsq_thread_id:
  - 252039322
tags:
  - Programming

---
When i have a password comparaison function using [crypt(3)][1] i really should remember that the comparaison stop at the 7 bytes, because that stuff is weird for me :

> In [1]: import crypt  
> In [2]: seed='foo!bar'  
> In [3]: crypt.crypt('abcdefghaa123456681', seed)  
> Out[3]: 'foEoVhbk7ad7A'  
> In [4]: crypt.crypt('abcdefghpax;lalx;al', seed)  
> Out[4]: 'foEoVhbk7ad7A'  
> In [5]:

any stuff after the 6 char will always get ignored by the hash algorithm.

 [1]: http://en.wikipedia.org/wiki/Crypt_%28Unix%29#Library_Function