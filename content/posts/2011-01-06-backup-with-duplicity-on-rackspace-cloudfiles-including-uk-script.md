---
title: Backup with duplicity on Rackspace CloudFiles (including UK) script.
author: chmouel
date: 2011-01-06T00:21:34+00:00
url: /2011/01/06/backup-with-duplicity-on-rackspace-cloudfiles-including-uk-script/
dsq_thread_id:
  - 252100932
tags:
  - Cloud
  - Rackspace

---
It seems that my post about using duplicity to backup your data on Rackspace CloudFiles got popular and people may be interested to use with the newly (Beta) released Rackspace Cloud UK. You would just need to have a environnement exported at the top of your backup script like this : 

export CLOUDFILES_AUTHURL=https://lon.auth.api.rackspacecloud.com/v1.0

and it will use the UK auth server (the same goes for OpenStack auth server if you have your own Swift install).

To make things easier I have taken this script from :

[http://damontimm.com/code/dt-s3-backup  
][1]  
and adapted it to make it work with Rackspace Cloud Files.

This is available here :

[https://github.com/chmouel/dt-cf-backup  
][2]  
You need to make sure that you have python-cloudfiles installed, on a Debian or Ubuntu system you can do it like this :

<pre lang="shell">sudo apt-get -y install python-stdeb 
sudo pypi-install python-cloudfiles
</pre>

Check the documentation of your Operating System to install python-cloudfiles, usually it is very easy to do it via [pip][3] (pip install python-cloudfiles)

When you have installed duplicity and checkout the script (see the github page for documentation how to do it) you can start configuring it. 

At the top there is a detailled explanation of the different variables that need to be configured. You can change it in the script or you can have them configured in an external configuration file in your home directory called ~/.dt-cf-backup.conf, this is an example :

<pre lang="shell">export CLOUDFILES_USERNAME="MY_USERNAME"
export CLOUDFILES_APIKEY="MY_APIKEY"
export PASSPHRASE="MY_PASSPHRASE"
GPG_KEY="8D643162"
ROOT="/home/chmouel"
export DEST="cf+http://duplicity_backup"
INCLIST=( /home/chmouel/ )
EXCLIST=( 	 "/home/chmouel/tmp"    "/**.DS_Store" "/**Icon?" "/**.AppleDouble"  )
LOGDIR="/tmp/"
LOG_FILE_OWNER="chmouel:"
</pre>

You can then just run :

<pre>./dt-cf-backup.sh --backup  
</pre>

to do your backup. 

There is much more documentation in the [README.txt.][4]

I just would like to thanks again the author of dt-s3-backup for this script. I have just made a few modifications for Rackspace Cloud Files.

 [1]: http://damontimm.com/code/dt-s3-backup
 [2]: https://github.com/chmouel/dt-cf-backup
 [3]: http://pip.openplans.org/
 [4]: https://github.com/chmouel/dt-cf-backup/blob/master/README