---
title: 【Mongodb】MongoDB分片备份策略示例与配置迁移示例
tags:
  - Mongodb
id: 142
categories:
  - 数据库知识
date: 2014-09-25 02:00:22
---

以下内容针对Linux系统配置MongoDB集群过程，具体的Windows平台自行进行修改：
<div>部署模式：</div>
<div>**1、Replica Set + Sharding **
<div>

### <a name="_Toc388704078"></a><a name="_Toc385360833"></a><a name="_Toc384758415"></a><span style="font-family: 'Arial','sans-serif'; mso-fareast-font-family: &lt;br /&gt;
Arial;" lang="X-NONE">1.1.1<span style="font-weight: normal; font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">
</span></span><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: 'Arial Unicode MS'; mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">准备工作</span>

<!--more-->

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">正式安装</span><span lang="EN-US">MongoDB</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">集群前需分别在三台服务器上做如下准备工作：</span>

<p class="MsoListParagraph" style="margin-left: 18.0pt; text-indent: 24.0pt; &lt;br /&gt;
mso-list: l5 level1 lfo2;"><span style="font-family: 宋体; mso-bidi-font-family: 宋体;" lang="EN-US">1.<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span><span style="font-family: 宋体;">创建安装<span lang="EN-US">Mongodb</span>所需用户：<span lang="EN-US">Mongo</span>，组：<span lang="EN-US">Mongodb</span></span>

<span style="font-family: 宋体; mso-bidi-font-family: 宋体;" lang="EN-US">2.<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span><span style="font-family: 宋体;">创建程序数据存储目录<span lang="EN-US">:/data/db/shard1</span>、<span lang="EN-US">/data/db/shard2</span>、<span lang="EN-US">/data/db/shard3</span>、<span lang="EN-US">/data/db/config</span></span>

<span style="font-family: 宋体; mso-bidi-font-family: 宋体;" lang="EN-US">3.<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span><span style="font-family: 宋体;">创建日志存储目录：<span lang="EN-US">/data/dblog/shard1</span>、<span lang="EN-US">/data/dblog/shard2</span>、<span lang="EN-US">/data/dblog/shard3</span>、<span lang="EN-US">/data/dblog/mongos</span>、<span lang="EN-US">/data/dblog/config</span></span>

<span style="font-family: 宋体; mso-bidi-font-family: 宋体;" lang="EN-US">4.<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span><span style="font-family: 宋体;" lang="EN-US">Mongo</span><span style="font-family: 宋体;">用户对数据及日志存储目录拥有读写权限</span>

<span style="font-family: 宋体; mso-bidi-font-family: 宋体;" lang="EN-US">5.<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span><span style="font-family: 宋体;">上传<span lang="EN-US">Mongodb</span>程序<span lang="EN-US">mongodb-linux-x86_64-2.4.3.tgz</span>到<span lang="EN-US">/home/mongo/</span>目录下，并解压。</span>

### <a name="_Toc388704079"></a><a name="_Toc385360834"></a><a name="_Toc384758416"></a><span style="font-family: 'Arial','sans-serif'; mso-fareast-font-family: &lt;br /&gt;
Arial;" lang="X-NONE">1.1.2<span style="font-weight: normal; font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">
</span></span><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: 'Arial Unicode MS'; mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">创建</span><span lang="X-NONE"> shard</span><span style="font-family: 黑体; mso-ascii-font-family: 'Arial Unicode MS'; &lt;br /&gt;
mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">服务</span>

<span lang="EN-US">1)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>分别在三台服务器上配置环境变量，具体操作如下：

<span lang="EN-US">[root@mongodb ~] su – mongo</span>

<span lang="EN-US">[mongo@mongodb ~] vi .bash_profile</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">然后在打开的环境变量文档的</span><span lang="EN-US">export PATH</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">后添加如下变量信息：</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">export MONGODB=/home/mongo/mongodb</span>

<span lang="EN-US">export MONGO_DATA=/data/db</span>

<span lang="EN-US">export MONGO_LOG=/data/dblog</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">其中</span><span lang="EN-US">MONGODB</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">为程序包路径，</span><span lang="EN-US">MONGO_DATA</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">为数据存放路径，</span><span lang="EN-US">MONGO_LOG</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">为日志存放路径</span>

<p class="MsoListParagraph" style="margin-left: 45.0pt; text-indent: -21.0pt; &lt;br /&gt;
mso-char-indent-count: 0; mso-list: l4 level1 lfo3;"><span lang="EN-US">2)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>创建<span lang="EN-US">mongodb</span>的启动脚本，具体操作如下：

<span lang="EN-US">[mongo@mongodb ~] cd /home/mongo</span>

<span lang="EN-US">[mongo@mongodb ~] mkdir script</span>

<span lang="EN-US">[mongo@mongodb ~] cd script</span>

<span lang="EN-US">[mongo@mongodb script] vi startshard1.sh</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">然后在打开的文档中输入如下信息：</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">${MONGODB}/bin/mongod<span style="color: #ff0000;"> -fork </span>-shardsvr -replSet shard1 -port 10001
-dbpath ${MONGO_DATA}/shard1 -logpath ${MONGO_LOG}/shard1/shard1.log</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">保存后为刚创建的</span><span lang="EN-US">startshard1.sh</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">增加执行权限</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">[mongo@mongodb script] chmod 755 startshard1.sh</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">重复上述步骤在当前服务器上创建</span><span lang="EN-US">startshard2.sh</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">和</span><span lang="EN-US">startshard3.sh,</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">其中</span><span lang="EN-US">shard2</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">的端口为</span><span lang="EN-US">10002,shard3</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">的端口为</span><span lang="EN-US">10003,</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">并在其余两台服务器上创建</span><span lang="EN-US">startshard1.sh</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">、</span><span lang="EN-US">startshard2.sh</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">和</span><span lang="EN-US">startshard3.sh.</span>

<p class="MsoListParagraph" style="margin-left: 45.0pt; text-indent: -21.0pt; &lt;br /&gt;
mso-char-indent-count: 0; mso-list: l4 level1 lfo3;"><span lang="EN-US">3)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>启动每台服务器上的三个<span lang="EN-US">shard</span>服务

<span lang="EN-US">[mongo@mongodb ~] cd /home/mongo/script</span>

<span lang="EN-US">[mongo@mongodb script] ./startshard1.sh</span>

<span lang="EN-US">[mongo@mongodb script] ./startshard2.sh</span>

<span lang="EN-US">[mongo@mongodb script] ./startshard3.sh</span>

<span lang="EN-US">
</span>

### <a name="_Toc384758419"></a><span style="font-family: Arial, sans-serif;" lang="X-NONE">1.1.3<span style="font-weight: normal; font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">     </span></span><span style="font-family: 黑体;" lang="X-NONE">初始化</span><span lang="X-NONE">replica set</span>

<span lang="EN-US">1)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>连接<span lang="EN-US">mongodb 10001</span>端口初始化<span lang="EN-US">replica set</span>，具体操作如下：

<span style="line-height: 20px; color: #333333; background-color: white; background-position: initial initial; background-repeat: initial initial;" lang="EN-US">[mongo@mongodb ~] cd ${MONGODB}bin</span>

<span style="line-height: 20px; color: #333333; background-color: white; background-position: initial initial; background-repeat: initial initial;" lang="EN-US">[mongo@mongodb ~] ./mongo –port</span><span style="line-height: 20px; color: red; background-color: white; background-position: initial initial; background-repeat: initial initial;" lang="EN-US"> </span><span style="line-height: 20px; color: #333333; background-color: white; background-position: initial initial; background-repeat: initial initial;" lang="EN-US">10001</span>

<span lang="EN-US">MongoDB shell version: 2.4.3</span>

<span lang="EN-US">connecting to: 127.0.0.1:10001/test</span>

<span lang="EN-US">&gt;config={_id:'shard1',members:[{_id: 0, host: '<span style="color: red;">IP1</span>:10001',priority:2},{_id: 1, host: '<span style="color: red;">IP2</span>:10001' ,priority:1},{_id: 2, host: '<span style="color: red;">IP3</span>:10001', "arbiterOnly": true }]}</span>

<span lang="EN-US">&gt;rs.initiate(config)</span>

<span lang="EN-US">&gt;rs.status()</span>

<span style="font-family: 宋体; color: red;">其中</span><span style="color: red;" lang="EN-US">IP1,IP2,IP3</span><span style="font-family: 宋体; color: red;">为三台服务器的</span><span style="color: red;" lang="EN-US">IP</span><span style="font-family: 宋体; color: red;">。</span>

<span lang="EN-US">2)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>连接<span lang="EN-US">mongodb 10002</span>端口初始化<span lang="EN-US">replica set</span>，具体操作如下：

<span lang="EN-US">[mongo@mongodb ~] cd ${MONGODB}bin</span>

<span lang="EN-US">[mongo@mongodb ~] ./mongo –port 10002</span>

<span lang="EN-US">MongoDB shell version: 2.4.3</span>

<span lang="EN-US">connecting to: 127.0.0.1:10002/test</span>

<span lang="EN-US">&gt;config={_id:'shard2',members:[{_id: 0, host: '<span style="color: red;">IP1</span>:10002',arbiterOnly:true},{_id: 1, host: '<span style="color: red;">IP2</span>:10002',priority:2},{_id: 2, host: '<span style="color: red;">IP3</span>:10002',priority:1 }]}</span>

<span lang="EN-US">&gt;rs.initiate(config)</span>

<span lang="EN-US">&gt;rs.status()</span>

<span style="font-family: 宋体; color: red;">其中</span><span style="color: red;" lang="EN-US">IP1,IP2,IP3</span><span style="font-family: 宋体; color: red;">为三台服务器的</span><span style="color: red;" lang="EN-US">IP</span><span style="font-family: 宋体; color: red;">。</span>

<span lang="EN-US">3)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>连接<span lang="EN-US">mongodb 10003</span>端口初始化<span lang="EN-US">replica set</span>，具体操作如下：

<span lang="EN-US">[mongo@mongodb ~] cd ${MONGODB}bin</span>

<span lang="EN-US">[mongo@mongodb ~] ./mongo –port 100033</span>

<span lang="EN-US">MongoDB shell version: 2.4.3</span>

<span lang="EN-US">connecting to: 127.0.0.1:100033/test</span>

<span lang="EN-US">&gt;config={_id:'shard3',members:[{_id: 0, host: '<span style="color: red;">IP1</span>:10003' ,priority:1},{_id: 1, host: '<span style="color: red;">IP2</span>:10003',arbiterOnly:true},{_id: 2, host: '<span style="color: red;">IP3</span>:10003',priority:2 }]}</span>

<span lang="EN-US">&gt;rs.initiate(config)</span>

<span lang="EN-US">&gt;rs.status()</span>

<span style="font-family: 宋体; color: red;">其中</span><span style="color: red;" lang="EN-US">IP1,IP2,IP3</span><span style="font-family: 宋体; color: red;">为三台服务器的</span><span style="color: red;" lang="EN-US">IP</span><span style="font-family: 宋体; color: red;">。</span>

<span lang="EN-US">4)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>验证<span lang="EN-US">replica set</span>信息

<span style="font-family: 宋体;">此时分别连接</span><span lang="EN-US">10001</span><span style="font-family: 宋体;">、</span><span lang="EN-US">10002</span><span style="font-family: 宋体;">和</span><span lang="EN-US">10003</span><span style="font-family: 宋体;">端口，用执行</span><span lang="EN-US">rs.status()</span><span style="font-family: 宋体;">命令会看到如下图所示的信息：</span>

<span lang="EN-US">![](http://helloword.1kapp.com/wp-content/uploads/2015/01/wpid-6ee28ff2fe09e04487d6481316081b0f_clip_image002ba1a8041-7d7d-49ca-95cd-882760f6d82a.jpg)</span>

<div><span lang="EN-US">
</span></div>

### <a name="_Toc388704080"></a><a name="_Toc385360835"></a><a name="_Toc384758417"></a><span style="font-family: 'Arial','sans-serif'; mso-fareast-font-family: &lt;br /&gt;
Arial;" lang="X-NONE">1.1.4<span style="font-weight: normal; font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">    </span></span><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: 'Arial Unicode MS'; mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">创建</span><span lang="X-NONE">config servers</span><span style="font-family: 黑体; mso-ascii-font-family: &lt;br /&gt;
'Arial Unicode MS'; mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">服务</span>

<span lang="EN-US">1)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>创建<span lang="EN-US">config</span>启动脚本，具体操作如下：

<span lang="EN-US">[mongo@mongodb ~] cd /home/mongo</span>

<span lang="EN-US">[mongo@mongodb ~] cd script</span>

<span lang="EN-US">[mongo@mongodb script] vi startconfig.sh</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">然后在打开的文档中输入如下信息：</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">${MONGODB}/bin/mongod -configsvr -port 20000 <span style="color: #ff0000;">-fork</span> -dbpath
${MONGO_DATA}/dbcfg -logpath ${MONGO_LOG}/dbcfg/dbcfg.log</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">保存后为刚创建的</span><span lang="EN-US">startconfig.sh</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">增加执行权限</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">[mongo@mongodb script] chmod 755 startconfig.sh</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">重复上述步骤在其余两台服务器上创建</span><span lang="EN-US">startconfig.sh</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">。</span>

<p class="MsoListParagraph" style="margin-left: 45.1pt; text-indent: -21.0pt; &lt;br /&gt;
mso-char-indent-count: 0; mso-list: l2 level1 lfo4;"><span lang="EN-US">2)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>启动三台服务器上的<span lang="EN-US">config</span>服务

<span lang="EN-US">[mongo@mongodb ~] cd /home/mongo/script</span>

<span lang="EN-US">[mongo@mongodb script] ./startconfig.sh</span>

### <a name="_Toc388704081"></a><a name="_Toc385360836"></a><a name="_Toc384758418"></a><span style="font-family: 'Arial','sans-serif'; mso-fareast-font-family: &lt;br /&gt;
Arial;" lang="X-NONE">1.1.5<span style="font-weight: normal; font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">    </span></span><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: 'Arial Unicode MS'; mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">创建</span><span style="font-family: 黑体; mso-ascii-font-family: 'Arial Unicode MS'; &lt;br /&gt;
mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">服务</span>

<span lang="EN-US">1)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>创建<span lang="EN-US">mongos</span>启动脚本，具体操作如下：

<span lang="EN-US">[mongo@mongodb ~] cd /home/mongo</span>

<span lang="EN-US">[mongo@mongodb ~] cd script</span>

<span lang="EN-US">[mongo@mongodb script] vi startmongos.sh</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">然后在打开的文档中输入如下信息：</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">${MONGODB}/bin/mongos <span style="color: #ff0000;">-fork </span>-port 30000 -configdb "<span style="color: red;">IP1</span>:20000,<span style="color: red;">IP2</span>:20000,<span style="color: red;">IP3</span>:20000" -logpath
${MONGO_LOG}/mongos/mongos.log</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman'; color: red;">其中</span><span style="color: red;" lang="EN-US">IP1,IP2,IP3</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman'; color: red;">分别为三台服务器的</span><span style="color: &lt;br /&gt;
red;" lang="EN-US">IP</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">保存后为刚创建的</span><span lang="EN-US">startconfig.sh</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">增加执行权限</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">[mongo@mongodb script] chmod 755 startmongos.sh</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">重复上述步骤在其余两台服务器上创建</span><span lang="EN-US">startmongos.sh</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">。</span>

<p class="MsoListParagraph" style="margin-left: 45.1pt; text-indent: -21.0pt; &lt;br /&gt;
mso-char-indent-count: 0; mso-list: l1 level1 lfo5;"><span lang="EN-US">2)<span style="font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">   </span></span>启动三台服务器上的<span lang="EN-US">mongos</span>服务

<span lang="EN-US">[mongo@mongodb ~] cd /home/mongo/script</span>

<span lang="EN-US">[mongo@mongodb script] ./startmongos.sh</span>

### <a style="font-size: 1.3em; text-indent: 0cm; line-height: 1.5;" name="_Toc384758420"></a><span style="font-family: 'Arial','sans-serif'; mso-fareast-font-family: &lt;br /&gt;
Arial;" lang="X-NONE">1.1.6<span style="font-weight: normal; font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">
</span></span><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: 'Arial Unicode MS'; mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">配置</span><span lang="X-NONE">Sharding</span>
<a name="_Toc388704082"></a>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">在其中一台服务器上，连接</span><span lang="EN-US">mongod</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">服务，即路由节点</span><span lang="EN-US">30000</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">端口，具体操作如下：</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">[mongo@mongodb ~] cd ${MONGODB}bin</span>

<span lang="EN-US">[mongo@mongodb ~] ./mongo –port 30000</span>

<span lang="EN-US">MongoDB shell version: 2.4.3</span>

<span lang="EN-US">connecting to: 127.0.0.1:30000/test</span>

<span style="color: #ff0000;">在这里需要 切换到 admin 库 </span>

<span style="color: #ff0000;">&gt; use admin</span>

<span lang="EN-US">&gt;db.runCommand({addshard:'shard1/10.1.195.47:10001,10.1.195.57:10001,10.1.195.67:10001'})</span>

<span lang="EN-US">{ "shardAdded" : "shard1", "ok" : 1 }</span>

<span lang="EN-US">&gt;db.runCommand({addshard:"shard2/10.1.195.47:10002,10.1.195.57:10002,10.1.195.67:10002"})</span>

<span lang="EN-US">{ "shardAdded" : "shard2", "ok" : 1 }</span>

<span lang="EN-US">&gt;db.runCommand({addshard:"shard3/10.1.195.47:10003,10.1.195.57:10003,10.1.195.67:10003"})</span>

<span lang="EN-US">{ "shardAdded" : "shard3", "ok" : 1 }</span>

<span lang="EN-US">&gt;db.runCommand({enablesharding:"(dbname)"})</span>

### <a name="_Toc388704084"></a><a name="_Toc385360839"></a><a name="_Toc384758421"></a><span style="font-family: 'Arial','sans-serif'; mso-fareast-font-family: &lt;br /&gt;
Arial; mso-fareast-language: ZH-CN;" lang="X-NONE">1.1.7<span style="font-weight: normal; font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">     </span></span><span style="font-family: 黑体; mso-ascii-font-family: 'Arial Unicode MS'; &lt;br /&gt;
mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">配置</span><span lang="X-NONE">Collect</span><span lang="X-NONE">i</span><span lang="X-NONE">on</span><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: 'Arial Unicode MS'; mso-hansi-font-family: 'Arial Unicode MS';" lang="X-NONE">分片</span>

<span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman'; mso-ansi-language: X-NONE;">为充分体现</span><span lang="X-NONE">mongodb</span><span style="font-family: 宋体; &lt;br /&gt;
mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: 'Times New Roman'; &lt;br /&gt;
mso-ansi-language: X-NONE;">分布式的优点，需对</span><span lang="X-NONE">mongodb</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; &lt;br /&gt;
mso-hansi-font-family: 'Times New Roman'; mso-ansi-language: X-NONE;">的</span><span lang="X-NONE">collection</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman'; mso-ansi-language: X-NONE;">进行分片。</span><span lang="X-NONE">collection</span><span style="font-family: &lt;br /&gt;
宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: 'Times New Roman'; &lt;br /&gt;
mso-ansi-language: X-NONE;">分片使得数据被分散存储在不同服务器上，减少每个服务器上的数据量，即使要进行大量数据的写入、读取操作，处理起来也会很容易的。</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">在其中一台服务器上，连接</span><span lang="EN-US">mongod</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">服务，即路由节点</span><span lang="EN-US">30000</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">端口，具体操作如下：</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span lang="EN-US">[mongo@mongodb ~] cd ${MONGODB}bin</span>

<span lang="EN-US">[mongo@mongodb ~] ./mongo –port 30000</span>

<span lang="EN-US">MongoDB shell version: 2.4.3</span>

<span lang="EN-US">connecting to: 127.0.0.1:30000/test</span>

<span lang="EN-US">&gt;db.runCommand({“enablesharding”:”sgccoa”})</span>

<span lang="EN-US">{“OK”:”1”}</span>

<span lang="EN-US">&gt;db.runCommand({“shardcollection”:”sgccoa.XXX”,”key”:{“XXX”:”1”}})</span>

<span lang="EN-US">{“collectionsharded”:”sgccoa.XXX”,”OK”:”1”}</span>

<p class="MsoNormal" style="text-indent: 24.0pt; mso-char-indent-count: 2.0;"><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">由于协同办公一级部署系统关于</span><span lang="EN-US">mongodb</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">如何分片，研发暂未给出明确答复，故以上分片操作中</span><span lang="EN-US">XXX</span><span style="font-family: 宋体; mso-ascii-font-family: 'Times New Roman'; mso-hansi-font-family: &lt;br /&gt;
'Times New Roman';">为不确定信息，可暂不进行分片操作。</span>

## <a name="_Toc388704085"></a><a name="_Toc385360840"></a><span lang="X-NONE">1.2<span style="font-weight: normal; font-size: 7pt; line-height: normal; font-family: 'Times New Roman';">
</span></span><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">如何验证</span><span lang="X-NONE">MongoDB</span><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">集群安装部署成功</span>

</div>
</div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">   对于安装完成后的MongoDB，我们如何查看对应的状态呢，下面是具体的查询操作，以下的查询均基于生产环境实际操作截图：</span></div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">--查看副本集的配置</span></div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">1、shard1的副本集情况</span></div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE"><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">![](http://helloword.1kapp.com/wp-content/uploads/2015/01/wpid-6ee28ff2fe09e04487d6481316081b0f_559644114970fcdc2db003ee4d5eb3b4.png)</span></span>
<div>![](http://helloword.1kapp.com/wp-content/uploads/2015/01/wpid-6ee28ff2fe09e04487d6481316081b0f_a851c3740c7f8ed8a623fe95a9d347ad.png)
<div></div>
</div>
</div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">2、shard2的副本集情况</span></div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE"><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">![](http://helloword.1kapp.com/wp-content/uploads/2015/01/wpid-6ee28ff2fe09e04487d6481316081b0f_908a45abc97733e8faefc6ad79532695.png)</span></span>
<div>![](http://helloword.1kapp.com/wp-content/uploads/2015/01/wpid-6ee28ff2fe09e04487d6481316081b0f_d1cca730827559fd5eefebd0b72980e5.png)
<div></div>
</div>
</div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">3、shard3的副本集情况</span></div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE"><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">![](http://helloword.1kapp.com/wp-content/uploads/2015/01/wpid-6ee28ff2fe09e04487d6481316081b0f_81090258219c4eb30a3907d160865323.png)</span></span>
<div>![](http://helloword.1kapp.com/wp-content/uploads/2015/01/wpid-6ee28ff2fe09e04487d6481316081b0f_836dde6525a281b02d51b9af2b0cf3a3.png)
<div></div>
</div>
</div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">--查看分片的配置</span></div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">
</span></div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE"><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">![](http://helloword.1kapp.com/wp-content/uploads/2015/01/wpid-6ee28ff2fe09e04487d6481316081b0f_83e74839797dd91bb712c55ee8b900ab.png)</span></span>
<div></div>
</div>
<div><span style="font-family: 黑体;">1.3 操作当某57磁盘空间沾满而47空间空闲时，将57中的副本集迁移到47中的操作过程：</span></div>
<div><span style="font-family: 黑体;">  1、首先连接到三个副本集上面，查看一下分布在57服务器上面的副本状态：</span></div>
<div><span style="font-family: 黑体;">  在57服务器上面部署的副本集情况为：</span></div>
<div><span style="font-family: 黑体;">    shard1:  57:10001 为secondary   副本节点 数据来自与primary节点，所以该节点可以删除</span></div>
<div><span style="font-family: 黑体;">    shard2:  57:10002 为primary      主节点，主要数据的存储目录，不建议删除</span></div>
<div><span style="font-family: 黑体;">    shard3:  57:10003 为arbiter      仲裁节点，数据量不大，不考虑迁移 </span></div>
<div><span style="font-family: 黑体;"> 故对shard1 在57上面的分布进行迁移</span></div>
<div><span style="font-family: 黑体;">    操作步骤：</span></div>
<div><span style="font-family: 黑体;">1、查看shard1副本集的primary节点，10.142.51.47:10001 </span></div>
<div><span style="font-family: 黑体;">    通过mongo -host 10.1.195.47 -port 10001 登录到shard1的主节点进行操作：</span></div>
<div><span style="font-family: 黑体;">    &gt;rs.remove("10.1.195.57:10001")--删除指定发副本集</span></div>
<div><span style="font-family: 黑体;">    &gt;rs.status()可以查看删除后的节点情况</span></div>
<div><span style="font-family: 黑体;">2、由于我们的副本将迁移到47上面，所以在47上面在开启一个mongod服务，作为节点，启动脚本如下：</span></div>
<div><span style="text-indent: 32px;">${MONGODB}/bin/mongod</span><span style="text-indent: 32px;"><span style="color: #ff0000;"> </span>-fork </span><span style="text-indent: 32px;">-shardsvr -replSet <span style="color: #ff0000;">**shard1**</span> -port **<span style="color: #ff0000;">10004</span>** -dbpath ${MONGO_DATA}**<span style="color: #ff0000;">/shard4</span>** -logpath ${MONGO_LOG}/**<span style="color: #ff0000;">shard4/shard4.log</span>**</span><span style="font-family: 黑体;">
</span></div>
<div><span style="text-indent: 32px;">**<span style="color: #ff0000;">
</span>**</span></div>
<div><span style="text-indent: 32px;">如以上启动脚本所示： 我们删除的副本集的名称（shard1）和我们即将创建的mongod的名称必须一致，否则在添加的时候会出现问题，提示集合名称不匹配。</span></div>
<div><span style="text-indent: 32px;">前提：需要再对应的47服务器上面创建对应的目录结构。</span></div>
<div><span style="text-indent: 32px;">
</span></div>
<div><span style="text-indent: 32px;">当新的副本集mongod创建完成后，</span></div>
<div><span style="text-indent: 32px;"> &gt;rs.add("10.1.195.47:10004") --方式一</span></div>
<div><span style="text-indent: 32px;">&gt;rs.add({_id:2,host:'10.1.195.47:10004',priority:2})--方式二 利用配置形式创建可以指定优先级</span></div>
<div style="text-indent: 32px;">在添加成功后，我们再次查看配置</div>
<div style="text-indent: 32px;">&gt;rs.conf()</div>
<div style="text-indent: 32px;">&gt;rs.status()</div>
<div style="text-indent: 32px;"></div>
<div style="text-indent: 32px;">3、在以上的操作结束后，mongo会进行数据的备份过程，如果数据量大的话会比较耗时，如果数据量较大，建议将新建mongod的目录清空，让mongo进行整改数据库的备份，忽略掉匹配备份，比较省时。</div>
<div style="text-indent: 32px;">4、在以上创建完副本集后，再去查看分片的配置，发现分片的配置已经自动更新为 新增的mongod了。</div>
<div><span style="font-family: 黑体;">
</span></div>
<div><span style="font-family: 黑体;">
</span></div>
<div><span style="font-family: 黑体; &lt;br /&gt;
mso-ascii-font-family: Arial; mso-hansi-font-family: Arial;" lang="X-NONE">
</span></div>
<div>[来自为知笔记(Wiz)](http://www.wiz.cn/i/60efacb7 "来自为知笔记(Wiz)")</div>