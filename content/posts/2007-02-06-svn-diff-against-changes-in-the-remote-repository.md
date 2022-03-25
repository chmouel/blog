---
title: SVN Diff against changes in the remote repository.
author: chmouel
type: post
date: 2007-02-07T03:02:26+00:00
url: /2007/02/06/svn-diff-against-changes-in-the-remote-repository/
dsq_thread_id:
  - 252039349
tags:
  - Scripts

---
A useful svn wrapper scripts. Get a diff of your local repostitory against the upstream repository changes. I wonder why it is not builtins though like a svn status -u but for dif.

<pre lang="bash">#!/bin/bash

IFS="
"
for line in `svn status -u`;do
    [[ $line != "   "* ]] && continue
    rev=`echo $line|awk '{print $2}'`
    ff=`echo $line|awk '{print $3}'`
    svn diff -r${rev}:HEAD $ff
done
</pre>