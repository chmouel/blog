---
title: Emacs nighly cvs snapshot with xft on Ubuntu Edgy
author: chmouel
type: post
date: 2007-01-21T12:32:54+00:00
url: /2007/01/21/emacs-nighly-cvs-snapshot-with-xft-on-ubuntu-edgy/
dsq_thread_id:
  - 252039334
tags:
  - Emacs

---
I wanted to try the latest cvs snapshot with XFT support, since i did not want to screw up more my workstation i have used packages instead of make install blindy.

Basically i have a script called ./build.sh

<pre lang="bash">#!/bin/bash
set -e

d=$(date '+%Y%m%d')
debpatch=20061218-1

mkdir -p cvs

pushd cvs &gt;/dev/null && {
cvs -Q -z3 -d:pserver:anonymous@cvs.savannah.gnu.org:/sources/emacs co -r emacs-unicode-2 emacs
} && popd &gt;/dev/null

mkdir -p build
[[ -d build/emacs-${d} ]] && rm -rf build/emacs-${d}
cp -al cvs/emacs build/emacs-${d}

zcat patches/emacs-snapshot_${debpatch}.diff.gz|patch -p1 -d build/emacs-${d}
cat patches/with-font.patch|patch --silent -p1 -d build/emacs-${d}

pushd build/emacs-${d} &gt;/dev/null && {
    chmod +x debian/rules
    dch -v "1:${d}-1" "New snapshot."
    dch "Build with xft."
    fakeroot dpkg-buildpackage -b
} && popd &gt;/dev/null</pre>

in patches/with-font.patch i have :

<pre lang="diff">--- c/debian/rules.chmou        2007-01-21 23:21:09.486353750 +1100
+++ c/debian/rules      2007-01-21 23:21:13.914630500 +1100
@@ -393,7 +393,7 @@
 # Emacs-gtk confflags
 emacs_gtk_confflags := ${confflags}
 emacs_gtk_confflags += --with-x=yes
-emacs_gtk_confflags += --with-x-toolkit=gtk
+emacs_gtk_confflags += --with-x-toolkit=gtk  --enable-font-backend --with-xft

 # Emacs-nox confflags
 emacs_nox_confflags := ${confflags}
--- c/src/emacs.c.chmou 2007-01-21 23:21:09.486353750 +1100
+++ c/src/emacs.c       2007-01-21 23:22:18.430662500 +1100
@@ -1408,10 +1408,10 @@
     = argmatch (argv, argc, "-nl", "--no-loadup", 6, NULL, &skip_args);

 #ifdef USE_FONT_BACKEND
-  enable_font_backend = 0;
-  if (argmatch (argv, argc, "-enable-font-backend", "--enable-font-backend",
-               4, NULL, &skip_args))
     enable_font_backend = 1;
+  if (argmatch (argv, argc, "-disable-font-backend", "--disable-font-backend",
+               4, NULL, &skip_args))
+    enable_font_backend = 0;
 #endif /* USE_FONT_BACKEND */

 #ifdef HAVE_X_WINDOWS
@@ -1816,7 +1816,7 @@
   { "-unibyte", "--unibyte", 81, 0 },
   { "-no-multibyte", "--no-multibyte", 80, 0 },
   { "-nl", "--no-loadup", 70, 0 },
-  { "-enable-font-backend", "--enable-font-backend", 65, 0 },
+  { "-disable-font-backend", "--disable-font-backend", 65, 0 },
   /* -d must come last before the options handled in startup.el.  */
   { "-d", "--display", 60, 1 },
   { "-display", 0, 60, 1 },</pre>

i have as well in patches/ the ubuntu (or could be debian) patch downloaded from the ubuntu (or debian archive) archive which is for ubuntu on

 <http://archive.ubuntu.com/ubuntu/pool/universe/e/emacs-wiki> 

If there is a new version you will need to increase the version in build.sh to match the patch downloaded.

When running build.sh it should produce binary in build/* with xft enabled by default. Make sure to have all the dependencies (dpkg-buildpackages should tell you if there is unresovled one).

One screenshot :

[<img src="http://www.chmouel.com/blog/wp-content/uploads/2007/01/emacs-snapshot-xft.png" alt="Screenshot of Emacs snapshot with XFT" width="80%" />][1]

 [1]: http://www.chmouel.com/blog/wp-content/uploads/2007/01/emacs-snapshot-xft.png "Screenshot of Emacs snapshot with XFT"