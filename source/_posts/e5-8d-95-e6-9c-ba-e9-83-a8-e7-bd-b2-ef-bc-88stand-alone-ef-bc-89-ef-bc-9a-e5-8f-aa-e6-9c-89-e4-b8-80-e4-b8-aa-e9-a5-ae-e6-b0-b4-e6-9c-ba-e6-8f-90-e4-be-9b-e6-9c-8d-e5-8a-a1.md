---
title: 【系统架构】通俗理论解释常用部署方案
tags:
  - 数据库知识
id: 558
categories:
  - 编程语言
date: 2015-11-11 18:27:28
---

图中用饮水机的例子解释了常用的部署方案
<!--more-->

![4.jpg](https://rjgeek.github.io/images/2015/11/wpid-d231e1bb9b2beb0a03ab1616005507d4_49de07bf-6d29-41ca-acdd-a8b12a4d0e7a.jpg)

**单机部署**（stand-alone）：只有一个饮水机提供服务，<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">服务只部署一份</span>

* * *

**集群部署**（cluster）：有多个饮水机同时提供服务，服务冗余部署，每个冗余的服务都对外提供服务，<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">一个服务挂掉时依然可用</span>

* * *

**热备部署**（hot-swap）：只有一个桶提供服务，另一个桶stand-by，在水用完时自动热替换，服务冗余部署，<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">只有一个主服务对外提供服务，影子服务在主服务挂掉时顶上</span>

* * *

磁盘阵列RAID（Redundant Arrays of independent Disks）

![5.gif](https://rjgeek.github.io/images/2015/11/wpid-d231e1bb9b2beb0a03ab1616005507d4_7b921b1d-9a34-418d-84f4-af7a0d578cb8.gif)

**<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">RAID0</span>**<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;">：存储性能高的磁盘阵列，又称striping，它的原理是，<span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(255, 0, 0); box-sizing: border-box !important; word-wrap: break-word !important;">将连续的数据分散到不同的磁盘上存储</span>，这些不同的磁盘能同时</span><span style="margin: 0px; padding: 0px; max-width: 100%; color: rgb(255, 0, 0); box-sizing: border-box !important; word-wrap: break-word !important;">并行存取数据（速度块）</span>

<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"></span>

* * *

![6.gif](https://rjgeek.github.io/images/2015/11/wpid-d231e1bb9b2beb0a03ab1616005507d4_97286508-6a45-4ebd-9ae5-c95ec0cba3a1.gif)
<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important;"></span>

**RAID1**：安全性高的磁盘阵列，又称mirror，它的原理是，<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">将数据完全复制到另一个磁盘上，磁盘空间利用率只有50%（冗余，数据安全）</span>

* * *

**RAID0+1**：<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">RAID0和RAID1的综合方案</span>，这也是**国企**用的比较多的存储方案<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">（速度快，安全性又高，但是很贵）</span>

* * *

![33.gif](https://rjgeek.github.io/images/2015/11/wpid-d231e1bb9b2beb0a03ab1616005507d4_621a7dc3-7fcf-4d84-8b8c-fc93c5139217.gif)

**RAID5**：RAID0和RAID1的折衷方案，读取<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">速度比较快</span>（不如RAID0，因为多存储了校验位），<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">安全性也很高</span>（可以利用校验位恢复数据），<span style="margin: 0px; padding: 0px; max-width: 100%; box-sizing: border-box !important; word-wrap: break-word !important; color: rgb(255, 0, 0);">空间利用率也不错</span>（不完全复制，只冗余校验位），这也是**互联网公司**用的比较多的存储方案

<div style="color:gray">
</div><small></small><small>&nbsp;</small>

<div>[来自为知笔记(Wiz)](http://www.wiz.cn/i/60efacb7 "来自为知笔记(Wiz)")</div>

<div>

### 附件列表

*   [9fcf96b1-fc49-42c9-aeff-c6447db54d72.gif](https://rjgeek.github.io/images/2015/11/wpid-d231e1bb9b2beb0a03ab1616005507d4_9fcf96b1-fc49-42c9-aeff-c6447db54d72.gif)
*   [e118ad4b-8b98-45f8-a2c5-171d6ff384b4.jpg](https://rjgeek.github.io/images/2015/11/wpid-d231e1bb9b2beb0a03ab1616005507d4_e118ad4b-8b98-45f8-a2c5-171d6ff384b4.jpg)
*   [34faebdd-1028-409a-a6bd-50259eb827fc.gif](https://rjgeek.github.io/images/2015/11/wpid-d231e1bb9b2beb0a03ab1616005507d4_34faebdd-1028-409a-a6bd-50259eb827fc.gif)
*   [bc05bfee-9daf-44b0-8bfc-a0c4171ba201.gif](https://rjgeek.github.io/images/2015/11/wpid-d231e1bb9b2beb0a03ab1616005507d4_bc05bfee-9daf-44b0-8bfc-a0c4171ba201.gif)</div>

&nbsp;