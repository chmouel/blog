---
title: sqlplus timeout when connnecting
author: chmouel
date: 2007-01-03T02:24:26+00:00
url: /2007/01/02/sqlplus-timeout-when-connnecting/
dsq_thread_id:
  - 252039319
tags:
  - Oracle

---
If you are using a pam\_ldap or pam\_nis environement and it happend that sqlplus does not want to connect as user but it does as root, waiting for :


```
socket(PF_FILE, SOCK_STREAM, 0)         = 3
connect(3, {sa_family=AF_FILE, path="/var/run/.nscd_socket"}, 110) = 
-1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/hosts", O_RDONLY)            = 3
fcntl64(3, F_GETFD)                     = 0
fcntl64(3, F_SETFD, FD_CLOEXEC)         = 0
fstat64(3, {st_mode=S_IFREG|0644, st_size=286, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE
|MAP_ANONYMOUS, -1, 0) = 0x45b78000
read(3, "127.0.0.1tlocalhost.localdomaint"..., 4096) = 286
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0x45b78000, 4096)                = 0
getpid()                                = 26002
getuid32()                              = 1121
futex(0x41239198, FUTEX_WAIT, 2, NULL &lt;unfinished>
&lt;/unfinished>
```


You just to have make sure to have nscd up and running. dunno what sqlplus does :(