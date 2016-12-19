---
title: 【搜索优化】Hexo-next百度和谷歌搜索优化
tags:
  - 搜索优化
id: 375
categories:
  - 搜索优化
date: 2016-12-19 23:12:09
keywords: Hexo-next,百度,谷歌,搜索优化,seo 
---

## 引言
搭建好了github的网站发现百度和谷歌搜索都不收录，甚为沮丧，研究后发展其实有很多实用的技巧可以优化网站搜索，特写文章总结之.
<img src="https://rjgeek.github.io/images/2016/12/seo_1.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  
<!--more-->

## 首页title优化
更改index.swig文件(your-hexo-site\themes\next\layout);  
```
{% block title %} {{ config.title }} {% endblock %}
```
修改为
```
{% block title %} {{ theme.keywords }} - {{ config.title }}{{ theme.description }} {% endblock %}
```
<img src="https://rjgeek.github.io/images/2016/12/seo_5.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  

## 修改文章链接
HEXO默认的文章链接形式为domain/year/month/day/postname，默认就是一个四级url，并且可能造成url过长，对搜索引擎是十分不友好的，我们可以改成 domain/postname 的形式。编辑站点_config.yml文件，修改其中的permalink字段改为permalink: :title.html即可。

## 设置站点地图

1.安装sitemap站点地图自动生成插件

```
npm install hexo-generator-sitemap --save
npm install hexo-generator-baidu-sitemap --save
```
2.在主题配置文件中添加一下配置(your-hexo-site\_config.yml)

```
sitemap:
  path: sitemap.xml
baidusitemap:
  path: baidusitemap.xml
```
3.然后在主题配置文件中修改url为你的域名，例如我的
```
url: http://www.ehcoo.com
```

配置好后，hexo g 就能在your-hexo-site\public 中生成sitemap.xml 和 baidusitemap.xml了;
<img src="https://rjgeek.github.io/images/2016/12/seo_7.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  

4.在your-hexo-site\source中新建文件robots.txt,内容可以参照我的
```
# hexo robots.txt
User-agent: *
Allow: /
Allow: /archives/
Allow: /categories/
Allow: /tags/
Allow: /about-me/

Disallow: /vendors/
Disallow: /js/
Disallow: /css/
Disallow: /fonts/
Disallow: /vendors/
Disallow: /fancybox/

Sitemap: http://www.ehcoo.com/sitemap.xml
Sitemap: http://www.ehcoo.com/baidusitemap.xml
```

<img src="https://rjgeek.github.io/images/2016/12/seo_6.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

当上面所有的都配置后就能看到编译好的sitemap.xml和baidusitemap.xml

<img src="https://rjgeek.github.io/images/2016/12/seo_4.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

## 百度链接优化
百度站长平台sitemap提交是邀请制的，并没有对所有站长开放，只有网站到一定等级百度才会在你后台开放提交sitemap的入口。
1.站点验证
[百度搜索引擎提交入口 ](http://zhanzhang.baidu.com/site/siteverify  )  
百度搜索有三种验证方式，我选择Html标签验证，在themes\next\layout\_partials\head.swing中添加验证代码：
<img src="https://rjgeek.github.io/images/2016/12/seo_2.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 
```
<meta name="baidu-site-verification" content="6VWurVhWUo" />
```
配置页面如下图所示  

<img src="https://rjgeek.github.io/images/2016/12/seo_8.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

2.更新Robots

<img src="https://rjgeek.github.io/images/2016/12/seo_10.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

## 谷歌链接优化
1.注册Google Search Console，添加你的域名后，如下图所示

<img src="https://rjgeek.github.io/images/2016/12/seo_15.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />

2.进行站点验证，验证的方式和百度的方式相同

<img src="https://rjgeek.github.io/images/2016/12/seo_13.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />

3.测试robots.txt

<img src="https://rjgeek.github.io/images/2016/12/seo_17.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

4.提交站点地图

<img src="https://rjgeek.github.io/images/2016/12/seo_18.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

5.点击左侧的Google 抓取方式

<img src="https://rjgeek.github.io/images/2016/12/seo_16.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

6.提交谷歌索引
在这里我们填上我们需要抓取的url,不填这表示抓取首页，抓取方式可以选择桌面，智能手机等等，自行根据需要选择。填好url之后，点击抓取。然后可能会出现几种情况，如:完成、部分完成、重定向等，自由这三种情况是可以提交的。
提交完成后，提交至索引，根据提示操作就可以了，我的提交：

<img src="https://rjgeek.github.io/images/2016/12/seo_19.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

7.上面我们提交了（【个人生活】大不列颠及北爱尔兰联合王国首都伦敦之3日游记）这篇文章，下面我们测试一下，优化效果 

<img src="https://rjgeek.github.io/images/2016/12/seo_20.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 



## 设置关键字
1.设置hexo博客的关键字:
在博客根目录下找到 config.yml 文件，在所示地方添加keywords: 关键字1,关键字2,关键字3…，采用英文逗号隔开，注意keywords与关键词之间的空格

<img src="https://rjgeek.github.io/images/2016/12/seo_12.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center /> 

2.设置文章的关键字:

在文章里面加入keywords，如下所示：
```
---
title: ###
date: ###
categories: ###
tags: ###
keywords: ###
description: ###
---
```

## 添加 “nofollow” 标签
给非友情链接的出站链接添加 “nofollow” 标签，nofollow标签是由谷歌领头创新的一个“反垃圾链接”的标签，并被百度、yahoo等各大搜索引擎广泛支持，引用nofollow标签的目的是：用于指示搜索引擎不要追踪（即抓取）网页上的带有nofollow属性的任何出站链接，以减少垃圾链接的分散网站权重。

rel这个属性它有许多的属性值，比如next、previous,、chapter、 section等等，比较常见的是rel="external nofollow"与rel="nofollow"两种参数的应用！

rel="nofollow"属性是谷歌为了应对垃圾链接而引入的一个属性值，被各大搜索引擎引用！rel="external nofollow"只是更相对于rel="nofollow"参数更加规范一些而已！

rel="external nofollow"与rel="nofollow"其功能就中文译文”不要读取” 及”外部链接不要读取”的意思！

1、 找到footer.swig，路径在your-hexo-site\themes\next\layout\_partials\footer.swig，将下面代码
```
{{ __('footer.powered', '<a class="theme-link" href="http://hexo.io">Hexo</a>') }}
```
修改成
```
{{ __('footer.powered', '<a class="theme-link" href="http://hexo.io" rel="external nofollow">Hexo</a>') }}
```
将下面代码
```
<a class="theme-link" href="https://github.com/iissnan/hexo-theme-next">
```
修改成
```
<a class="theme-link" href="https://github.com/iissnan/hexo-theme-next" rel="external nofollow">
```
2、 修改sidebar.swig文件，路径在your-hexo-site\themes\next\layout\_macro\sidebar.swig，将下面代码
```
<a href="{{ link }}" target="_blank">{{ name }}</a>
```
修改成
```
<a href="{{ link }}" target="_blank" rel="external nofollow">{{ name }}</a>
```
将下面代码
```
<a href="http://creativecommons.org/licenses/{{ theme.creative_commons }}/4.0" class="cc-opacity" target="_blank">
```
修改成
```
<a href="http://creativecommons.org/licenses/{{ theme.creative_commons }}/4.0" class="cc-opacity" target="_blank" rel="external nofollow">
```

## 总结
<font color=#00ffff>本文从 
首页title优化，修改文章链接，设置站点地图，百度链接优化，谷歌链接优化，添加 “nofollow” 标签
</font>
6个方面进行了github博客的SEO优化，其中大量借鉴了他人的方法，具体地址详见引用。

## 声明
本文70%为组合,30%为原创

## 引用
http://hunao.info/
http://www.arao.me/2015/hexo-next-theme-optimize-seo/
http://blog.csdn.net/zaoan_wx/article/details/50859675
http://hunao.info/2016/06/01/Hexo-Seo%E4%BC%98%E5%8C%96%E8%AE%A9%E4%BD%A0%E7%9A%84%E5%8D%9A%E5%AE%A2%E5%9C%A8google%E6%90%9C%E7%B4%A2%E6%8E%92%E5%90%8D%E7%AC%AC%E4%B8%80/





