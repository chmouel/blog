---
title: Generating md5 encrypted password for chpasswd
author: chmouel
date: 2007-08-17T07:11:38+00:00
url: /2007/08/17/generating-md5-encrypted-password-for-chpasswd/
dsq_thread_id:
  - 252039348
tags:
  - Programming
  - Python
  - Scripts
  - Solaris
  - Travel

---
If you want to generate properly encrypted password to feed to chpasswd, the most easier and proper way is to do that from command line :  
[code lang="bash"]  
echo "encryptedpassword"|openssl passwd -1 -stdin  
[/code]  
If you want to generate in pure python you can do it like that :  
[code lang="python"]  
def md5crypt(password, salt, magic='$1$'):  
import md5  
m = md5.new()  
m.update(password + magic + salt)

\# /\* Then just as many characters of the MD5(pw,salt,pw) \*/  
mixin = md5.md5(password + salt + password).digest()  
for i in range(0, len(password)):  
m.update(mixin[i % 16])

\# /\* Then something really weird... \*/  
\# Also really broken, as far as I can tell. -m  
i = len(password)  
while i:  
if i & 1:  
m.update('x00')  
else:  
m.update(password[0])  
i >>= 1

final = m.digest()  
\# /\* and now, just to make sure things don't run too fast \*/  
for i in range(1000):  
m2 = md5.md5()  
if i & 1:  
m2.update(password)  
else:  
m2.update(final)  
if i % 3:  
m2.update(salt)  
if i % 7:  
m2.update(password)

if i & 1:  
m2.update(final)  
else:  
m2.update(password)

final = m2.digest()

\# This is the bit that uses to64() in the original code.  
itoa64 = './0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'  
rearranged = ''  
for a, b, c in ((0, 6, 12), (1, 7, 13), (2, 8, 14), (3, 9, 15), (4, 10, 5)):  
v = ord(final[a]) < < 16 | ord(final[b]) << 8 | ord(final[c]) for i in range(4): rearranged += itoa64[v & 0x3f]; v >>= 6

v = ord(final[11])  
for i in range(2):  
rearranged += itoa64[v & 0x3f]; v >>= 6

return magic + salt + '$' + rearranged

[/code]

You need to feed it up with a salt, like this :  
[code lang="python"]  
def generate_salt(count):  
import random, string  
char = string.ascii_letters + string.digits + string.punctuation.replace(':', '')  
return string.join(map(lambda x,v=char: random.choice(v), range(count)), '')  
[/code]