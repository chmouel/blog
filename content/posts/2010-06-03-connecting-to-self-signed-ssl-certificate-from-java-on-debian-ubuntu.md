---
title: connecting to self signed SSL certificate from Java on Debian/Ubuntu
author: chmouel
type: post
date: 2010-06-03T10:50:43+00:00
url: /2010/06/03/connecting-to-self-signed-ssl-certificate-from-java-on-debian-ubuntu/
dsq_thread_id:
  - 253512169
tags:
  - Java
  - Programming

---
You want to connect to self signed SSL certificate from Java using the standard [HttpsURLConnection][1] and you are getting this error, because the self signed certificate is obviously not recognized by Java :

<pre>SEVERE: sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
javax.net.ssl.SSLHandshakeException: sun.security.validator.ValidatorException: PKIX path building failed: sun.security.provider.certpath.SunCertPathBuilderException: unable to find valid certification path to requested target
	at sun.security.ssl.Alerts.getSSLException(Alerts.java:192)
	at sun.security.ssl.SSLSocketImpl.fatal(SSLSocketImpl.java:1639)
	at sun.security.ssl.Handshaker.fatalSE(Handshaker.java:215)
	at sun.security.ssl.Handshaker.fatalSE(Handshaker.java:209)
</pre>

it seems that there is a lot of 'solutions' (read hack) or workaround around the web which is resumed well on [this][2] stack overflow article. 

There is actually a very easy (and secure) way on Debian based systems. 

- Go to your https url with Firefox  
- Right Click to 'View Page Info'  
- In 'Security' tab you will see a button saying 'View Certificate'  
- Click now on the 'Details' tab  
- Finally click on the 'Export' button which offer you to save the PEM certifcate of the website somewhere on your filesystem.

Call it my.self.signed.domain.name.pem or whatever my.self.signed.domain.name should be and put the file in /etc/ssl/certs now you just have to run the command :

<pre>sudo update-ca-certificates
</pre>

and it should add your certificate to the java keystore, you can check it with the command (Enter for Password) :

<pre>keytool -list -v -keystore /etc/ssl/certs/java/cacerts
</pre>

 [1]: http://java.sun.com/j2se/1.4.2/docs/api/javax/net/ssl/HttpsURLConnection.html
 [2]: http://stackoverflow.com/questions/875467/java-client-certificates-over-https-ssl