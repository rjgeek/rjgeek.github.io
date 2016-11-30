---
title: 【密码学】Diffie-Hellman密钥交换
id: 813
categories:
  - 密码学
date: 2016-11-30 21:15:54
tags:
---
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>
## Diffie-Hellman密钥交换
Diffie-Hellman密钥交换是RSA之前的算法，其中的原理就是单项函数，如下图所示  
在已知下图的模式下，任意跟换X可以获得不同的输出，但是从输出你无法获取X，RSA的算法基石   
<img src="https://rjgeek.github.io/images/2016/11/rsa_6.png?t=1" width = "70%" height = "auto" alt="图片名称" align=center />
<img src="https://rjgeek.github.io/images/2016/11/rsa_5.png" width = "70%" height = "auto" alt="图片名称" align=center />  
假设ALICE和BOB进行通信，而EVE是个监听者，首先ALICE根据上左边的选择一个任意的X54经过计算得出结果15发给BOB
<img src="https://rjgeek.github.io/images/2016/11/rsa_8.png?t=1" width = "70%" height = "auto" alt="图片名称" align=center />
<img src="https://rjgeek.github.io/images/2016/11/rsa_9.png" width = "70%" height = "auto" alt="图片名称" align=center />  
BOB同样选择任意一个X24按照上图的公式进行计算得出16，此时54,24分别为ALICE和BOB的私有，15和16则为公开的数据，监听者EVE可以获取15和16  
<img src="https://rjgeek.github.io/images/2016/11/rsa_10.png" width = "70%" height = "auto" alt="图片名称" align=center />  

其中1为将来需要交换的秘钥，两边接收的相同
$$3^{54\ast24}mod\quad17 =3^{24\ast54}mod\quad17 = 1$$
证明  
$$16^{54}mod\quad17 = (3^{24}mod17)^{54}mod\quad17 = 3^{24\ast54}mod\quad17$$
同理  
$$15^{24}mod\quad17 = (3^{54}mod17)^{24}mod\quad17 = 3^{54\ast24}mod\quad17$$
### 引用
https://www.khanacademy.org/computing/computer-science/cryptography/modern-crypt/v/diffie-hellman-key-exchange-part-2



