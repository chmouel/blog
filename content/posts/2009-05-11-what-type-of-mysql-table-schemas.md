---
title: What type of MySQL table schemas
author: chmouel
type: post
date: 2009-05-11T08:55:27+00:00
url: /2009/05/11/what-type-of-mysql-table-schemas/
dsq_thread_id:
  - 252039369
tags:
  - MySQL

---
Since I always forget stuff like this. This is the SQL query to detect mysql table schemas type (thanks to Darren.B) :

<pre lang="sql">SELECT table_name, table_schema, table_type, engine FROM information_schema.tables where table_schema not in ('information_schema', 'mysql');</pre>