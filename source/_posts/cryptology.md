---
title: 【密码学】一万字带您走进密码学的世界（上） 
tags:
  - 密码学
id: 375
categories:
  - 密码学
date: 2017-01-03 00:20:09
keywords: 密码学，对称秘钥，哈希密码
---
## 引文

>密码学是研究编制密码和破译密码的技术科学。研究密码变化的客观规律，应用于编制密码以保守通信秘密的，称为编码学；应用于破译密码以获取通信情报的，称为破译学，总称密码学。

为了使读者对密码学有一个整体的认识，本文简述了常见的密码学的概念，其中本文包括对称密码，哈希函数。 
[《一万字带您走进密码学的世界（下）》](cryptology.html)包括非对称密码，数字签名，数字认证等，需要指出的是文中并没有深入探讨加密算法原理，关于此部分内容，后续的文章会详细阐述。本文的主要内容如下图所示：
<img src="../images/2017/01/cryptology_16.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 
<!--more-->
## 对称密码
在对称密码体系中，相同的密码用来加密和解密报文，因此无论对发送者还是接收者他们都知道秘钥，解密和解密的过程：  
$M表示明文$   
$K表示秘钥$   
$C表示密文$  
<img src="../images/2017/01/cryptology_2.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  

$E表示加密函数$  
$D表示解密函数$  

对称密码可以分为两类：分组密码和序列密码
### 分组密码
**分组密码（Block Cipher）:**以一个数据块（比如64位连续的比特数据）为单位进行加密，将明文消息编码表示后的数字（简称明文数字）序列，划分成长度为n的组（可看成长度为n的矢量），每组分别在密钥的控制下变换成等长的输出数字（简称密文数字）序列。
常见的分组密码分为以下几类：
#### Feistel 密码
 在密码学研究中，Feistel 密码结构是用于分组密码中的一种对称结构。以它的发明者 Horst Feistel 为名，而Horst Feistel 本人是一位物理学家兼密码学家，在他为 IBM 工作的时候，为Feistel 密码结构的研究奠定了基础。很多密码标准都采用了Feistel 结构，其中包括DES。Feistel 的优点在于：由于它是对称的密码结构，所以对信息的加密和解密的过程就极为相似，甚至完全一样。这就使得在实施的过程中，对编码量和线路传输的要求就减少了几乎一半。  
#### DES
数据加密标准（英语：Data Encryption Standard，缩写为 DES）是一种对称密钥加密块密码算法，1976年被美国联邦政府的国家标准局确定为联邦资料处理标准（FIPS），随后在国际上广泛流传开来。它基于使用56位密钥的对称算法  
#### AES
高级加密标准（英语：Advanced Encryption Standard，缩写：AES），在密码学中又称Rijndael加密法，是美国联邦政府采用的一种区块加密标准。这个标准用来替代原先的DES，已经被多方分析且广为全世界所使用。经过五年的甄选流程，高级加密标准由美国国家标准与技术研究院（NIST）于2001年11月26日发布于FIPS PUB 197，并在2002年5月26日成为有效的标准。2006年，高级加密标准已然成为对称密钥加密中最流行的算法之一。
### 分组密码几种模式
分组（block）密码的工作模式（mode of operation）允许使用同一个分组密码密钥对多于一块的数据进行加密，并保证其安全性。分组密码自身只能加密长度等于密码分组长度的单块数据，若要加密变长数据，则数据必须先被划分为一些单独的密码块。通常而言，最后一块数据也需要使用合适填充方式将数据扩展到匹配密码块大小的长度。一种工作模式描述了加密每一数据块的过程，并常常使用基于一个通常称为初始化向量的附加输入值以进行随机化，以保证安全，
#### 电子密码本（ECB）
最简单的加密模式即为电子密码本（Electronic codebook，ECB）模式。需要加密的消息按照块密码的块大小被分为数个块，并对每个块进行独立加密.加密过程如下：
<img src="../images/2017/01/cryptology_4.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

解密过程如下：

<img src="../images/2017/01/cryptology_5.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

#### 密码块链接（CBC）
在CBC模式中，每个平文块先与前一个密文块进行异或后，再进行加密。在这种方法中，每个密文块都依赖于它前面的所有平文块。同时，为了保证每条消息的唯一性，在第一个块中需要使用初始化向量。
加密过程如下：
<img src="../images/2017/01/cryptology_6.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

解密过程如下：

<img src="../images/2017/01/cryptology_7.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

#### 填充密码块链接（PCBC）
填充密码块链接（PCBC，Propagating cipher-block chaining）或称为平文密码块链接（Plaintext cipher-block chaining）[15][16]，是一种可以使密文中的微小更改在解密时导致平文大部分错误的模式，并在加密的时候也具有同样的特性。
加密过程如下：

<img src="../images/2017/01/cryptology_8.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

解密过程如下：

<img src="../images/2017/01/cryptology_9.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

#### 密文反馈（CFB）
密文反馈（CFB，Cipher feedback）模式类似于CBC，可以将块密码变为自同步的流密码；工作过程亦非常相似，CFB的解密过程几乎就是颠倒的CBC的加密过程：  
加密过程如下：

<img src="../images/2017/01/cryptology_10.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

解密过程如下：

<img src="../images/2017/01/cryptology_11.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

#### 计数器模式（CTR）
TR模式（Counter mode，CM）也被称为ICM模式（Integer Counter Mode，整数计数模式）和SIC模式（Segmented Integer Counter）。
与OFB相似，CTR将块密码变为流密码。它通过递增一个加密计数器以产生连续的密钥流，其中，计数器可以是任意保证长时间不产生重复输出的函数，但使用一个普通的计数器是最简单和最常见的做法。
加密过程如下：

<img src="../images/2017/01/cryptology_12.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 

解密过程如下：

<img src="../images/2017/01/cryptology_13.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center /> 
### 序列密码
**序列密码（Stream Cipher）：**一次只对明文中的单个比特（有时对字节）运算的算法，而且密码要不断变化中。  
加密的一般模型如下：  
明文序列：$m=m_1m_2m_3...$  
秘钥序列：$k=k_1k_2k_3...$  
密文序列：$c=c_1c_2c_3...$  
加密变换：$c_i=k_i\otimes m_i (i = 1,2,3...)$  
解密变换：$m_i=k_i\otimes c_i (i = 1,2,3...)$  

流式密码有点像一次性密码：我们产生一个和和要加密的数据一样长的秘钥，这个秘钥往往是从种子中产生的，虽然他不是随机的，但是是伪随机的。  
<img src="../images/2017/01/cryptology_14.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

常见的序列加密算法如下：
#### 线性反馈寄存器
线性反馈移位寄存器（linear feedback shift register, LFSR）是指，给定前一状态的输出，将该输出的线性函数再用作输入的移位寄存器。异或运算是最常见的单比特线性函数：对寄存器的某些位进行异或操作后作为输入，再对寄存器中的各比特进行整体移位。 
#### 内容扰乱系统
内容扰乱系统(Content Scrambling System) 是一种防止直接从盘片上复制视频文件的数据加密和鉴定方法。每个获得许可的人都能得到一把密钥，它从加密光盘上的密钥组成的母集中取出来。 只要在以后的光盘上去除该密钥，许可就失效了。
<img src="../images/2017/01/cryptology_15.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />
#### A5/1算法
该方案用于GSM蜂窝电话网络中的数据机密性加密
#### RC5算法
分组密码算法是1994由麻萨诸塞技术研究所的Ronald L. Rivest教授发明的，并由RSA实验室分析。不像许多方案，RC5具有可变块大小（32，64或128位），密钥大小（0到2040位）和轮回数（0到255）。参数的原始建议选择分别为64位，128位密钥和12轮的块大小。12轮的RC5（64位块）易受使用244选择明文差分攻击。18-20轮被认为是足够的安全保护。
## 哈希加密
哈希加密是独立于对称密码和对称密码体系的，因为他不需要解密。接下来我们会提到哈希函数的概念，注意：此处的哈希函数有别与编程中的哈希函数，编程中函数主要用来做地址的映射。具体详见我之前的文章[《【密码学】Hash Function(哈希函数)》](hashFunction.html)
密码学上指散列函数具有的特征:

* 输入长度可以是任意长度
* 输出是固定长度
* 给出任意的报文可以很轻松的算出哈希函数$H（x）$
* 哈希函数是个不可逆的函数，就是给出一个$Y $，其中$Y = H（x）$,你完全不能通过Y去推算出x
* 哈希函数不存在碰撞，就是不存在任意一个$x'$,使$H（x'） = H（x）$

### 哈希函数的用处
#### 文件校验
MD5 Hash算法的"数字指纹"特性，使它成为目前应用最广泛的一种文件完整性校验和（Checksum）算法
#### 数字签名
由于非对称算法的运算速度较慢，所以在数字签名协议中，单向散列函数扮演了一个重要的角色。对 Hash 值，又称"数字摘要"进行数字签名，在统计上可以认为与对文件本身进行数字签名是等效的。而且这样的协议还有其他的优点。
### 常见的哈希函数算法
#### MD4
MD4(RFC 1320）是 MIT 的Ronald L. Rivest在 1990 年设计的，MD 是 Message Digest 的缩写。它适用在32位字长的处理器上用高速软件实现--它是基于 32位操作数的位操作来实现的。
#### MD5
MD5(RFC 1321）是 Rivest 于1991年对MD4的改进版本。它对输入仍以512位分组，其输出是4个32位字的级联，与 MD4 相同。MD5比MD4来得复杂，并且速度较之要慢一点，但更安全，在抗分析和抗差分方面表现更好
#### SHA1
SHA1是由NIST NSA设计为同DSA一起使用的，它对长度小于2^64位的输入，产生长度为160bit的散列值，因此抗穷举（brute-force）性更好。SHA-1 设计时基于和MD4相同原理，并且模仿了该算法。

## 总结

本文主要阐述了密码学中的<font color=#00ffff>对称密码和哈希密码</font>
在下篇文章[《一万字带您走进密码学的世界（下）》](cryptology1.html)中我们将继续介绍 非对称密码，秘钥交换，数字证书等概念。

## 声明
本文40%为翻译组合,**60%为原创**
## 引用
http://baike.baidu.com/linkurl=8O2XInaeTewn0xMPgNceWPDDCbwEeI8DjJMwpp_T8Gcu6sGCpeJDSpolFXLsYXPfa5OcaIqq7t_r11cprg2j8q  
https://zh.wikipedia.org/wiki/%E5%88%86%E7%BB%84%E5%AF%86%E7%A0%81%E5%B7%A5%E4%BD%9C%E6%A8%A1%E5%BC%8F#.E7.94.B5.E5.AD.90.E5.AF.86.E7.A0.81.E6.9C.AC.EF.BC.88ECB.EF.BC.89  
http://baike.baidu.com/link?url=MbBt9W9ZxPbUczMDPjb4Touio78qil_JUp858Oi0GQbB6uVIhpfElCRtdouJlKVO6oDL4lhPzeENovTkJp2GWrq7XeutPYyIpB3l6eWytIu 
http://baike.baidu.com/link?url=hhvK2RFiyxU0CJ12HnVpg9PEozTQ2tTfU7DT2K8VcCgx198hhJRBpiKuCjJk6qm0FA0fyeKPH9w_vLkJrGQ3_j-iLxOi4E6WIlFe-u0WxO_

