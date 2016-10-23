---
title: 【Mongodb】低版本Mongodb集群加密-用户认证
id: 515
categories:
  - 数据库知识
date: 2015-10-12 11:49:20
tags:
---

# <span style="line-height: 1.2;">1  数据库调整</span>

本文适用于对Mongo有一定了解到操作人员

以下操作基于以下条件

操作系统：Red Hat 6.4

Mongo版本：2.6.3

已经完成集群分片，已经存在数据库pmr

因为Mongo升级的原因，以下方法仅适用于2.6.3 以前的版本

## 1.1  创建用户

本次一共预留4个用户

用户名                密码                备注

admin                123root           超级管理员

admin_read           123root_read      只读超级管理员

pmr_admin            123root_pmr        pmr库管理员

pmr_admin_read      123root_pmr_read   pmr库可读管理员

在无命令的情况下进行登录,（蓝色字体表示需敲入的语句，黑色字体表示执行成功的控制台输出的部分）

   [root@master ~]# mongo 192.168.0.178:20000/admin

MongoDB shell version: 2.6.1

connecting to: 192.168.0.178:20000/admin

mongos&gt;db.addUser('admin','123root')  #添加超级管理员用户

mongos&gt;db.addUser('admin_read',123root_read'，true) #添加超级管理员可读用

mongos&gt;use pmr

mongos&gt; db.addUser('pmr_admin','123root_pmr')  #添加pmr库管理员

mongos&gt; db.addUser('pmr_admin_read ','123root_pmr_read ')  #添加pmr可读管理员用户

命令执行成功标志：出现

Successfully added user: { }

在执行过程中会出现WARNING，提示方法已经过期，不影响最终结果

## 1.2  关闭服务器的mongod,mongos和config服务

执行ps –ef|grep mongo 查出所有mongo正在运行的进程

执行 kill -2 进程ID   杀掉所有进程

## 1.3  停生成密钥文件keyfile

切换到root的跟目录下执行以下命令

openssl rand -base64 753 &gt;keyfile

chmod 600 keyfile #重点 必须

cat keyfile   #查看

4a7w479ouV6fY5CASqxeWzzPhPLzZgYnHKWOFSIxjMABjaWK7up6Keb2+ZKz1C2Rtfl7ukCBelW2xOL0h3gOSAdIhUi0j8IMBYZV/kbUSSf0987xIur3lHZqUINPVVyl

ib+XPrg3SO4IG25tCQbEf/twvS1CxiDmi/GtQZfqOjUX7MEJK3ynFBsB/9wU1nf1

6rLhBPIdmSnpNf5s9yGohx2wn6dQcJ8o0wn75oOBysX2mPkLI0tEu4//7x1PgY9Q

Ws4XdXs1MFqUYXkh8K6RFd/TKB2zs5fonzqiXrgwpaW1KUFZB1lAfQwWePmxsWul

HqR96/yTGPxQKOVpm1Zdj2LGa616X3Www16Td4c2UVoM7mPi+Js8R2Flc6oV9H+

## 1.4  将keyfile分发到各个库中

#将生成的keyfile 拷贝到mongod/mongos/config 进程对应的文件夹（依据自己的库而定）

[root@master ~]# cp keyfile /data/mongodb/config/data/

[root@master ~]# cp keyfile /data/mongodb/mongos/

[root@master ~]# cp keyfile /data/mongodb/shard1/data/

[root@master ~]# cp keyfile /data/mongodb/shard2/data/

[root@master ~]# cp keyfile /data/mongodb/shard3/data/

依次将keyfile拷贝到另外两台机器上的数据文件

   全部执行完之后，依次变更权限，下面为其中一个例子

执行    chmod 600  /data/mongodb/mongos/keyfile

## 1.5  变更脚本文件

原脚本

${MONGODB}/bin/mongod -fork -shardsvr -replSet shard1 -port 10001 -dbpath ${MONGO_DATA}/shard1 -logpath ${MONGO_LOG}/shard1/shard1.log

变更后的脚本，在最后添加上权限

${MONGODB}/bin/mongod -fork -shardsvr -replSet shard1 -port 10001 -dbpath ${MONGO_DATA}/shard1 -logpath ${MONGO_LOG}/shard1/shard1.log

--keyFile /data/mongodb/shard1/data/keyfile

请依次变更所有服务的脚本（3台shard,config,mongo）

## 1.6  启动脚本

进入脚本目录下，依次执行所有shard和config脚本后，然后在执行mongo服务，顺序很重要

## 1.7  确认权限是否添加成功

验证超级管理员, 账户认证前状态

[Mongo@master ~]# mongo 10.142.51.43:30000

MongoDB shell version: 2.6.1

connecting to: localhost: 10.142.51.43:30000/test

Error while trying to show server startup warnings: not authorized on admin to execute command { getLog: "startupWarnings" }

mongos&gt; show collections;

2014-08-03T12:02:48.535+0800 error: {

  "$err" : "not authorized for query on test.system.namespaces",

  "code" : 13

} at src/mongo/shell/query.js:131

mongos&gt; use pmr

switched to db pmr

mongos&gt; show collections;

2014-08-03T12:03:10.923+0800 error: { "$err" : "not authorized for query on uba.system.namespaces", "code" : 13 } at src/mongo/shell/query.js:131

验证超级管理员, 账户认证后状态

#admin库认证

[Mongo @master ~]# mongo 10.142.51.43:30000/admin -u admin -p 123root

MongoDB shell version: 2.6.1

connecting to: localhost:20000/admin

mongos&gt; show collections;

system.indexes

system.users

system.version

#pmr库认证 读写权限用户

[Mongo@master ~]# mongo 10.142.51.44:30000/pmr -u pmr_admin -p 123root_pmr

MongoDB shell version: 2.6.1

connecting to: 10.142.51.44:30000/pmr

Error while trying to show server startup warnings: not authorized on admin to execute command { getLog: "startupWarnings" }

mongos&gt; show collections;

system.indexes

table1

mongos&gt; db.table1.count()

0

mongos&gt; for (var i = 1; i &lt;= 1000; i++)db.table1.save({id:i,name:"username"+i,age:i});

WriteResult({ "nInserted" : 1 })

mongos&gt; db.table1.count()

1000

mongos&gt; db.table1.findOne()

{

  "_id" : ObjectId("53ddb52a65bb900f61e458a1"),

  "id" : 1,

  "name" : "username1",

  "age" : 1

}

#pmr库 只读权限用户

[Mongo@master ~]# mongo localhost:20000/pmr -u pmr_read -p 123root_pmr_read

MongoDB shell version: 2.6.1

connecting to: localhost:20000/pmr

Error while trying to show server startup warnings: not authorized on admin to execute command { getLog: "startupWarnings" }

mongos&gt; db.auth('sa_read','123root_pmr_read')

1

mongos&gt; for (var i = 1; i &lt;= 1000; i++)db.table1.save({id:i,name:"username"+i,age:i});

WriteResult({

  "writeError" : {

   "code" : 13,

    "errmsg" : "not authorized on uba to execute command { insert: \"table1\", documents: [ { id: 1000.0, name: \"username1000\", age: 1000.0, _id: ObjectId('53ddb5d62390d9a487087c87') } ], ordered: true }"

  }

})

mongos&gt; db.table1.findOne()

{

  "_id" : ObjectId("53ddb52a65bb900f61e458a1"),

 "id" : 1,

  "name" : "username1",

  "age" : 1

}

mongos&gt; db.table1.count()

1000

也可用工具MongoVUE执行验证，这里不再描述