---
title: rsync like backup to Rackspace Cloud File with duplicity
author: chmouel
date: 2009-09-02T20:09:15+00:00
url: /2009/09/02/rsync-like-backup-to-rackspace-cloud-file-with-duplicity/
dsq_thread_id:
  - 252039380
tags:
  - Rackspace
  - Scripts

---
It seems that there is no much documentation about how to do rsync like backup with <a href="http://" target="_blank">duplicty</a> so here it is :

  * Install python-cloudfiles from here <a href="http://github.com/rackspace/python-cloudfiles" target="_blank">http://github.com/rackspace/python-cloudfiles</a>
<li style="text-align: left;">
  Install duplicity, its available directly from Debian or alike distros (ie: ubuntu) or you can do that from source from the <a href="http://duplicity.nongnu.org/" target="_blank">homepage</a>.
</li>
<li style="text-align: left;">
  Get your API Key from <a href="https://manage.rackspacecloud.com/" target="_blank">https://manage.rackspacecloud.com/</a> and use a script like this :
</li>

<pre lang="bash">#!/bin/bash
UPLOAD_TO_CONTAINER="backup" #adjust it as you like
export CLOUDFILES_USERNAME=Your Username
export CLOUDFILES_APIKEY=API_KEY_YOU_GOT
export PASSPHRASE=The Passphrase for your encrypted backup

duplicity /full/path cf+http://${UPLOAD_TO_CONTAINER}</pre>

This should take care to upload the backup files to the backup container. It does that incrementally and detect the changes to your file system to upload. There is much more option for duplicity look at the manpage for more info.