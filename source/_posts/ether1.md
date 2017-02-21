---
title: 【学习笔记】从0开始搭建区块链开发环境  
tags:
  - 以太坊,区块链,ethereum
id: 375
categories:
  - 区块链
date: 2017-02-18 12:37:09
keywords: 以太坊,区块链,ethereum
---

## 引言
Ethereum（以太坊）是一个使开发人员能够建立和发布下一代分布式应用的公共区块链平台。 通过其专用加密货币以太币（Ether）提供去中心化的虚拟机（称为“以太虚拟机”Ethereum Virtual Machine）来处理点对点合约。

本文从0开始搭建了以太坊的开发环境，犹如当年初学其他语言一样，这是我们的第一个hellowork程序，在完成搭建后又进行了账户创建、挖矿、转账等测试。

<img src="../images/2017/02/ether1_1.jpg?>" width = "85%" height = "65%" alt="图片名称" align=center />  

<!--more-->

## 环境搭建
本次的以太坊环境是用go语言开发，虚拟机内部运行的是javascript. 可能有人不太理解，举个例子，java虚拟机本身就是用c开发的(windows平台上)，但是运行在虚拟机之上运行的是java语言。 
### 环境准备
一台能联网的Ubuntu64位机器(已经安装git)，如果是其他机器类型，请参考其他安装教程，[点我](https://github.com/ethereum/go-ethereum/wiki/Building-Ethereum)
### 开始安装
两种安装方式，任意选择一种(建议使用第一种)：

第一种使用 Personal Package Archives 直接安装，命令如下：

```
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```
第二种安装方式，使用源码安装，自己用go语言进行编译，命令如下：

1.下载源码
```
git clone https://github.com/ethereum/go-ethereum
```
2.安装go的运行环境，[参考本文](http://www.linuxidc.com/Linux/2015-02/113977.htm)  
3.绑定运行环境到go
```
sudo apt-get install -y build-essential golang
```
4.进入到源码目录中，开始编译源码
```
cd go-ethereum
make geth
```
5.运行  
```
build/bin/geth
```
## 初步探索
### 进入虚拟机并输出日志
```
get --dev console 2>> geth-log
```
主界面：  
<img src="../images/2017/02/ether1_2.jpg?>" width = "85%" height = "65%" alt="图片名称" align=center />

日志界面：  
<img src="../images/2017/02/ether1_3.jpg?>" width = "85%" height = "65%" alt="图片名称" align=center />

### 全局变量

其中有一些是全局变量，你可以认为是javascript的全局变量，全局变量拥有自己的方法和函数。  
如下eth变量：

<img src="../images/2017/02/ether1_4.jpg?>" width = "85%" height = "65%" alt="图片名称" align=center />

如下的的personal变量：  

<img src="../images/2017/02/ether1_5.jpg?>" width = "85%" height = "65%" alt="图片名称" align=center />

下面对用户操作，对矿机的操作，转账操作，挖矿操作，实际都在运用这些全局变量中的参数，然后穿上适当的方法。

### 账户操作

1.创建新账户
```
personal.newAccount('123456')
```

创建成功后，会展示创建成功的地址，其中上面的表达式中，中间传入的123456为密码

2.查看一下系统有的用户
```
eth.accounts
```
<img src="../images/2017/02/ether1_7.jpg?>" width = "85%" height = "65%" alt="图片名称" align=center />

因为我之前有个用户，所以在有两个用户

3.为用户取一个别名，很显然如果操作上面的字符串地址是很不方面的，所以下面对字符串用户进行取别名，因为是js语言，所以可以直接使用，如下：
```
user1 =  eth.accounts[0]
user2 =  eth.accounts[1]
```
如果你在查看user1.则如下，已经成功赋值
<img src="../images/2017/02/ether1_8.jpg?>" width = "85%" height = "65%" alt="图片名称" align=center />

4.对账户进行解锁，为了安全起见，一般一个用户在创建的时候都是出于锁定的状态，有日志状态可以看到，如下

<img src="../images/2017/02/ether1_9.jpg?>" width = "85%" height = "65%" alt="ehcoo" align=center />

对账户进行解锁的命令
```
personal.unlockAccount(user2,'123456')
```
### 开始挖矿
挖矿的过程，主要是对miner这个全局变量进行操作
<img src="../images/2017/02/ether1_10.jpg?>" width = "85%" height = "65%" alt="ehcoo" align=center />

开始之前我们检查一下账户user1和user2的金额，你会发现两者的金额都为0

```
eth.getBalcance(user1)
eth.getBalcance(user2)
```
开始挖矿,命令如下：
```
miner.start()
```
停止挖矿命令：
```
miner.stop()
```
开始挖矿后台输出挖矿日志：
<img src="../images/2017/02/ether1_11.jpg?>" width = "85%" height = "65%" alt="ehcoo" align=center />

运行一会后你去查看用户的账户金额

<img src="../images/2017/02/ether1_12.jpg?>" width = "85%" height = "65%" alt="ehcoo" align=center />

发现第一个账户中已经含有金额。也就是说默认是挖到了第一个账户中。
### 转账测试
现在我们模拟从第一个账户像第二个账户转账的命令
```
eth.sendTransaction({from:user1,to:user2,value:8})
```
<img src="../images/2017/02/ether1_13.jpg?>" width = "85%" height = "65%" alt="ehcoo" align=center />

需要说明的是转账后，账户2并没有立即收到钱，而在是挖矿之后才收到的，主要原因是当前的交易还没有并入到区块链中，我们从日志中可以获取相关信息

<img src="../images/2017/02/ether1_14.jpg?>" width = "85%" height = "65%" alt="ehcoo" align=center />

像地址0x0b52...写的的交易0xab24..,在区块8中才写入，我们可以查看区块8进行验证

<img src="../images/2017/02/ether1_15.jpg?>" width = "85%" height = "65%" alt="ehcoo" align=center />



## 总结
本文快速搭建了一个以太坊的环境，并进一步探索了账户操作，转账，挖矿等操作，其中主要参考了[汪晓明](http://ethcast.com/)老师的教程。
## 声明
本文20%为翻译组合,**80%为原创**
## 引用
https://github.com/ethereum/go-ethereum/wiki/Installation-Instructions-for-Ubuntu  
http://ethcast.com/v1  
http://www.8btc.com/ethereum  
https://zh.wikipedia.org/wiki/%E4%BB%A5%E5%A4%AA%E5%9D%8A






