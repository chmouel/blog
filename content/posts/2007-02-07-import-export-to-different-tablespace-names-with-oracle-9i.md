---
title: Import Export to different tablespace names with Oracle 9i
author: chmouel
type: post
date: 2007-02-07T09:32:40+00:00
url: /2007/02/07/import-export-to-different-tablespace-names-with-oracle-9i/
dsq_thread_id:
  - 252863717
tags:
  - Oracle

---
Renaming Oracle Database is a pain, coming from OpenSource DB like  
MySQL or PostGres where we do that all the time i did not think that  
Oracle have to be such a pain.

My only way i can find. 

- If i have the tablespace named **tablesp1** and owned by the  
user **user1**, and i want to import it to another tablespace  
called **tablesp2** in an another Oracle 9i tablespace with the user  
name **user2**.

  * I import the tablesp1 in an Oracle 10 (if you are lucky to have  
    one). 
  * Make sure i create the user2 in the Oracle10 DB. 
  * I connect as DBA access and i rename the tablespace with :  
    [code lang="sql"]  
    ALTER TABLESPACE tablesp1 RENAME TO tablesp2  
    ALTER TABLESPACE tablesp2 OWNER TO user2  
    [/code]</p> 
  * Export the Oracle10 tablespace with Oracle 9 exp.  
    Sometime sometime you may encounter that famous error </p> 
    <pre><i>"EXP-00003 : no storage definition found for segment ....."</i>. 
</pre>
    
    So you have have to  
    do [this][1] as well. </li> 
    
      * That's it. The dump should be under tablespace name tablesp2 with  
        owner user2. </ul>

 [1]: http://www.anysql.net/en/oracle/oracle_bug_exp00003.html