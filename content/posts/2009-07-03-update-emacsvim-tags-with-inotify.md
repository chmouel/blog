---
title: Update Emacs/VIM tags with inotify
author: chmouel
date: 2009-07-03T18:12:30+00:00
url: /2009/07/03/update-emacsvim-tags-with-inotify/
dsq_thread_id:
  - 252039373
tags:
  - Emacs

---
When you use the tags interface for [Emacs][1] or with [VIM][2] you have to generate your tag file everytime you have a new class or things get changed.  Would not be cool to have inotify monitoring your project directory and run the etags command to generate it.

With [incron][3] you have cron that can watch some portion of the filesystem and generate an action if certain event appears.  So after installed (aptitude/urpmi) it I have configured this incrontab entry :


```bash
/home/chmouel/git/myproject IN_CLOSE_WRITE /home/chmouel/update-ctags.sh py $@ $@/$#

```


The script update-ctags.sh takes 3 argument one is the type of file to update when it's changed it accept multipe of them if you delimit with a pipe ie: py|inc|php|c and the two others are identifier from incron to give the base directory and the full path which is something you should not have to change.

The update-ctags is simple as follow which could be hacked for your convenience :


```bash
#!/bin/bash

ACCEPTED_EXTENSION="$(echo $1|sed 's/|/ /g')"
BASE_DIR=$2
FILE_EXT=${3##*.}

[[ -z ${FILE_EXT} ]] && exit

processing=
for extension in $ACCEPTED_EXTENSION;do
    [[ $extension == $FILE_EXT ]] && processing=true
done

find ${BASE_DIR} ! -wholename './.git/*'  -a ! -wholename './.svn/*' -a ! -name '*.pyc' -a ! -name '*~' -a ! -name '*#' -print0| xargs -0 etags -o ${BASE_DIR}/TAGS 2>/dev/null >/dev/null
```


<div id="_mcePaste" style="position: absolute; left: -10000px; top: 50px; width: 1px; height: 1px; overflow-x: hidden; overflow-y: hidden;">
  /home/chmouel/git/swift-container IN_CLOSE_WRITE /home/chmouel/updatectags.sh py $@ $@/$#
</div>

 [1]: http://www.emacswiki.org/emacs/EmacsTags
 [2]: http://www.vim.org/htmldoc/tagsrch.html#tags
 [3]: http://inotify.aiken.cz/?section=incron&page=doc&lang=en