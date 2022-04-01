---
title: History expansion and substitions in ZSH
author: chmouel
date: 2007-01-11T05:05:50+00:00
url: /2007/01/10/history-expansion-and-substitions-in-zsh/
dsq_thread_id:
  - 264839759
tags:
  - Scripts

---
I better to keep that somewhere since i always forget that thing, to do a search and replace from the command line in zsh. you just have to do the :s^FOO^BAR after your expansion

For example you just have typed the long command line :

<pre>blah bar FOO=1 FOO=3 FOO=6 cnt=1
</pre>

you can just type :

<pre>!blah:s^FOO^VALUE^:G 
</pre>

and it will be expanded to :

<pre>blah bar VALUE=1 VALUE=3 VALUE=6 cnt=1
</pre>