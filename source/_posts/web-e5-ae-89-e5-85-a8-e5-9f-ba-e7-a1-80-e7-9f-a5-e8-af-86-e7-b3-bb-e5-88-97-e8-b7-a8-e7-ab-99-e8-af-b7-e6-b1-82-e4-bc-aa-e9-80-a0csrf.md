---
title: 【WEB安全】WEB安全基础知识系列-跨站请求伪造(CSRF)
id: 992
categories:
  - WEB安全
  - 编程语言
date: 2016-06-09 16:48:46
tags:
---

<span style="background-color: white;">CSRF（Cross-site request forgery跨站请求伪造，也被称成为"one click attack"或者session riding，通常缩写为CSRF或者XSRF，是一种对网站的恶意利用。</span><span style="font-family: 微软雅黑;">
</span>

## 1.攻击原理:<span style="font-family: 宋体;">
</span>

<span style="color: #585858;">CSRF攻击原理比较简单，如图1所示。其中Web A为存在CSRF漏洞的网站，Web B为攻击者构建的恶意网站，User C为Web A网站的合法用户。<span style="font-family: 微软雅黑; font-size: 11pt;">
</span></span>

![](http://helloword.1kapp.com/wp-content/uploads/2016/06/060916_0848_WEB16.jpg)
<span style="color: #585858; font-family: 微软雅黑; font-size: 11pt;">
</span>

<!--more-->

<span style="color: #585858;">1.用户C打开浏览器，访问受信任网站A，输入用户名和密码请求登录网站A；<span style="font-family: 微软雅黑; font-size: 11pt;">
</span></span>

<span style="color: #585858;">2.在用户信息通过验证后，网站A产生Cookie信息并返回给浏览器，此时用户登录网站A成功，可以正常发送请求到网站A；<span style="font-family: 微软雅黑; font-size: 11pt;">
</span></span>

<span style="color: #585858;">3.用户未退出网站A之前，在同一浏览器中，打开一个TAB页访问网站B；<span style="font-family: 微软雅黑; font-size: 11pt;">
</span></span>

<span style="color: #585858;">4.网站B接收到用户请求后，返回一些攻击性代码，并发出一个请求要求访问第三方站点A；<span style="font-family: 微软雅黑; font-size: 11pt;">
</span></span>

<span style="color: #585858;">5.浏览器在接收到这些攻击性代码后，根据网站B的请求，在用户不知情的情况下携带Cookie信息，向网站A发出请求。网站A并不知道该请求其实是<span style="font-family: 微软雅黑; font-size: 11pt;">
</span></span>

<span style="color: #585858;">由B发起的，所以会根据用户C的Cookie信息以C的权限处理该请求，导致来自网站B的恶意代码被执行。<span style="font-family: 微软雅黑; font-size: 11pt;">
</span></span>

## 2.攻击举例

&nbsp;

<span style="color: #333333;">银行网站A，它以GET请求来完成银行转账的操作，如：http://www.mybank.com/Transfer.php?toBankId=11&amp;money=1000危险网站B，它里面有一段HTML代码如下：<span style="color: blue;">&lt;<span style="color: maroon;">img<span style="font-family: 宋体;"> </span><span style="color: red;">src<span style="color: blue;">=http://www.mybank.com/Transfer.php?toBankId=11&amp;money=1000&gt;<span style="color: #333333;">首先，你登录了银行网站A，然后访问危险网站B，噢，这时你会发现你的银行账户少了1000块......为什么会这样呢？原因是银行网站A违反了HTTP规范，使用GET请求更新资源。在访问危险网站B的之前，你已经登录了银行网站A，而B中的&lt;img&gt;以GET的方式请求第三方资源（这里的第三方就是指银行网站了，原本这是一个合法的请求，但这里被不法分子利用了），所以你的浏览器会带上你的银行网站A的Cookie发出Get请求，去获取资源"[<span style="color: blue; text-decoration: underline;">http://www.mybank.com/Transfer.php?toBankId=11&amp;money=1000"，</span>](http://www.mybank.com/Transfer.php?toBankId=11&amp;money=1000”，)结果银行网站服务器收到请求后，认为这是一个更新资源操作（转账操作），所以就立刻进行转账操作......<span style="font-size: 10pt;">同样的道理，即使是用post依然会被轻易利用，在此不再冗余举例</span><span style="font-family: 微软雅黑;">
</span></span></span></span></span></span></span>

## 4.漏洞防御:

<span style="color: #333333;"><span style="font-size: 10pt;">增加二次验证，在表单提交之前在此输入验证码或者其他标识，如12306的校验过程</span>
</span>

<span style="color: #333333;">验证[HTTP REFERER](https://zh.wikipedia.org/wiki/HTTP%E5%8F%83%E7%85%A7%E4%BD%8D%E5%9D%80),HTTP源地址用来标识请求的源地址，即此次页面从哪发起，校验的代码如下
</span>
<div>
<table style="border-collapse: collapse; background: #fbd4b4;" border="0"><colgroup> <col style="width: 590px;" /></colgroup>
<tbody valign="top">
<tr>
<td style="padding-left: 7px; padding-right: 7px; border: solid 0.5pt;">

    // 从 HTTP 头中取得 Referer 值 `</pre>
    <pre>` String referer=request.getHeader("Referer"); `</pre>
    <pre>` // 判断 Referer 是否以 bank.example 开头 `</pre>
    <pre>` if((referer!=null) &amp;&amp;(referer.trim().startsWith("bank.example"))){ `</pre>
    <pre>` chain.doFilter(request, response); `</pre>
    <pre>` }else{ `</pre>
    <pre>` request.getRequestDispatcher("error.jsp").forward(request,response); `</pre>
    <pre>` }`</pre>
    </td>
    </tr>
    </tbody>
    </table>
    </div>
    <span style="color: #333333;">在实际生成环境中，因为代理服务器和防火墙的原因，源地址常常会被屏蔽掉，所以此种方法慎用,增加随机数校验TOKEN，其核心思想是客户端的请求时的随机数与存在后台的数据进行对比,前台的随机数常用隐藏的input中、自定义header中、cookie中，服务器端的随机数一般存在SESSION中，由此衍生出来的防御方法如下：前台的基础是浏览器的同源策略，即第三方的页面无法获取本页面的相应信息
    </span>

    <span style="color: #333333;">**基于隐藏input的代码
    **</span>
    <div>
    <table style="border-collapse: collapse; background: #fbd4b4;" border="0"><colgroup> <col style="width: 590px;" /></colgroup>
    <tbody valign="top">
    <tr>
    <td style="padding-left: 7px; padding-right: 7px; border: solid 0.5pt;">
    <pre>`&lt;form method="POST" action="transfer.php"&gt; 　　　　&lt;input type="text" name="toBankId"&gt; 　　　　&lt;input type="text" name="money"&gt; 　　　　&lt;input type="hidden" name="hash" value="****"&gt; 　　　　&lt;input type="submit" name="submit" value="Submit"&gt; `</pre>
    <pre>` &lt;/form&gt;`</pre>
    </td>
    </tr>
    </tbody>
    </table>
    </div>
    <span style="color: #333333;">**基于HASHCOOKIE的代码
    **</span>
    <div>
    <table style="border-collapse: collapse; background: #fbd4b4;" border="0"><colgroup> <col style="width: 590px;" /></colgroup>
    <tbody valign="top">
    <tr>
    <td style="padding-left: 7px; padding-right: 7px; border: solid 0.5pt;">
    <pre>`$token = md5(uniqid(rand(), TRUE)); `</pre>
    <pre>`$_SESSION['token'] = $token; `</pre>
    <pre>`$_SESSION['token_time'] = time()`</pre>
    </td>
    </tr>
    </tbody>
    </table>
    </div>
    <span style="color: #333333;">**基于自定义header的条件
    **</span>
    <div>
    <table style="border-collapse: collapse; background: #fbd4b4;" border="0"><colgroup> <col style="width: 590px;" /></colgroup>
    <tbody valign="top">
    <tr>
    <td style="padding-left: 7px; padding-right: 7px; border: solid 0.5pt;">
    <pre>`dojo.xhr = function(method,args,hasBody) { `</pre>
    <pre>`    // 确保 header 对象存在 `</pre>
    <pre>`    args.headers = args.header || {};                `</pre>
    <pre>`    tokenValue = '&lt;=request.getSession(false).getAttribute("csrftoken")%&gt;'; `</pre>
    <pre>`    var token = dojo.getObject("tokenValue"); `</pre>
    <pre>`    // 把 csrftoken 属性放到头中 `</pre>
    <pre>`    args.headers["csrftoken"] = (token) ? token : "  "; `</pre>
    <pre>`    return plainXhr(method,args,hasBody); `</pre>
    <pre>`}

</td>
</tr>
</tbody>
</table>
</div>
&nbsp;

## 4.总结与思考:<span style="font-family: 宋体;">
</span>

<span style="color: #333333;">其中起到关键因素因素是浏览器的同源策略，如果没有看懂的小伙盘，可以研究下这块<span style="font-size: 10pt;">
</span></span>

<span style="color: #333333;">目前最好的解决方案依然停留在客户端与服务端的对比校验，随机数有服务端发起，客户端在数据流中只负责带上，服务端自行校验
</span>

## 5.引用:<span style="font-family: 宋体;">
</span>

[<span style="color: #333333;">http://www.freebuf.com/articles/web/11840.html</span>](http://www.freebuf.com/articles/web/11840.html)<span style="color: #333333; font-size: 10pt;">
</span>

[<span style="color: #333333;">http://www.cnblogs.com/hyddd/archive/2009/04/09/1432744.html</span>](http://www.cnblogs.com/hyddd/archive/2009/04/09/1432744.html)<span style="color: #333333;">
</span>

<span style="font-size: 10pt;">《白帽子讲WEB安全》</span><span style="color: #333333;">
</span>

&nbsp;