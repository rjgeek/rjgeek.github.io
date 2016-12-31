---
title: 【Linux】linux查看端口占用情况
tags:
  - Linux
id: 163
categories:
  - 操作系统
date: 2015-11-21 22:23:05
---

## netstat -nupl 查看UDP 
// n表示用数字形式显示端口号，u，表示UDP协议类型，p是程序PID，l表示处于监听状态的；
<img src="../images/2016/12/linuxport_1.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
## netstat -tupl  查看TCP
t，表示TCP协议类型
<img src="../images/2016/12/linuxport_2.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
## lsof -i:8088
查看此端口是否开放，如果没有开放不返回任何动，如果开放正常返回
<img src="../images/2016/12/linuxport_3.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
## netstat –apn
使用netstat -apn查看所有的进程和端口使用情况。发现下面的进程列表，其中最后一栏是PID/Program name 
<img src="../images/2016/12/linuxport_4.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
发现8080端口被PID为1288的进程占用。进一步使用命令：ps -ef | grep pid 查看
<img src="../images/2016/12/linuxport_5.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
就可以明确知道8080端口是被哪个程序占用了！然后判断是否使用KILL命令干掉！
## 声明
本文90%为翻译组合,**10%为原创**
## 引用
https://zhidao.baidu.com/question/82236788.html