---
title: 【系统架构】五种通用WEB应用服务器（5 Common Server Setups For Your Web Application）
id: 813
categories:
  - 系统架构
date: 2016-11-25 18:05:54
tags:
---
最近访客
<div class="ds-recent-visitors" data-num-items="28" data-avatar-size="42" id="ds-recent-visitors"></div>
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>
## 简介（Introduction）
When deciding which server architecture to use for your environment, there are many factors to consider, such as performance, scalability, availability, reliability, cost, and ease of management.

Here is a list of commonly used server setups, with a short description of each, including pros and cons. Keep in mind that all of the concepts covered here can be used in various combinations with one another, and that every environment has different requirements, so there is no single, correct configuration.
<!--more-->

## 所有东西都放在一个服务器上（Everything On One Server）
The entire environment resides on a single server. For a typical web application, that would include the web server, application server, and database server. A common variation of this setup is a LAMP stack, which stands for Linux, Apache, MySQL, and PHP, on a single server.
Use Case: Good for setting up an application quickly, as it is the simplest setup possible, but it offers little in the way of scalability and component isolation.




## 引用
https://www.digitalocean.com/community/tutorials/5-common-server-setups-for-your-web-application


















