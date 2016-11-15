---
title: 【密码学】RSA算法解析-数论基础
id: 813
categories:
  - 密码学
date: 2016-11-13 21:15:54
tags:
---
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>
## 数学基础(Fundamental_Theorem_of_Arithmeti)
### 1.素数
定义：大于 1 且只能被 1 和自身整除的正整数称为**素数或质数**. 大于 1 且不是素数的正整数称为**合数**.  
例如,  2,3,5,7,11是素数, 4,6,8,9是合数.     
一个好玩的现象，如果将所有素数进行螺旋排列，所有素数呈现斐波那契螺旋线排列，在计算机下的模拟如下：  
<img src="https://rjgeek.github.io/images/2016/11/rsa_1.png" width = "70%" height = "auto" alt="图片名称" align=center />  
<!--more-->
当有足够多的数据进行模拟时，展现的图形如下：  
<img src="https://rjgeek.github.io/images/2016/11/rsa_2.png" width = "70%" height = "auto" alt="图片名称" align=center />  
自然界中也有很多如贝类的螺旋轮廓线、向日葵轮廓、银河、人的耳朵等这种天然的“黄金螺旋”。至于素数为什么也有这样的特征我的答案是我也不知道  
<img src="https://rjgeek.github.io/images/2016/11/rsa_4.png" width = "70%" height = "auto" alt="图片名称" align=center />   

### 2.任何合数(Composite Number)都是有若干素数（Prime Number）组成的
素数是构成元素的基本要素,素数本身是不可再分的，素数是构建，每一个数有且只有一种素数的分解方法，没有两个数会分享同一个素数因子分解,  (算术基本定理)设a>1, 则
$$a=p_1^{k1}p_2^{k2}p_3^{k3}....p_r^{kr}$$, 
其中p1,p2,…,pk是不相同的素数, r1,r2,…,rk是正整数, 并且在不计顺序的情况下, 该表示是惟一的. 
     该表达式称作整数 a 的素因子分解. 
例如   30=2×3×5, 117=32×13, 1024=210 

### 3.数论倒数(Multiplicative Inverse)
在数论中，还有数论倒数的概念，如果两个数a和b，它们的乘积关于模m余1，那么我们称它们互为关于模m的数论倒数.比如  ,所以3是2关于5的数论倒数.数论倒数在中国剩余定理中非常重要.而辗转相除法提供了计算数论倒数的方法.
### 4.最大公约数
a,b属于Z，能同时被a和b整除的最大的那个数，成为最大公约数，或者公因子  
### 5.互素关系  
如果两个正整数，除了1以外，没有其他公因子，我们就称这两个数是互质关系（coprime）。比如，15和32没有公因子，所以它们是互质关系。这说明，不是质数也可以构成互质关系。  
关于互质关系，不难得到以下结论： 
>  
　　1. 任意两个质数构成互质关系，比如13和61。  
　　2. 一个数是质数，另一个数只要不是前者的倍数，两者就构成互质关系，比如3和10。  
　　3. 如果两个数之中，较大的那个数是质数，则两者构成互质关系，比如97和57。  
　　4. 1和任意一个自然数是都是互质关系，比如1和99。  
　　5. p是大于1的整数，则p和p-1构成互质关系，比如57和56。  
>　　6. p是大于1的奇数，则p和p-2构成互质关系，比如17和15。  
官方给的定义：  
<img src="https://rjgeek.github.io/images/2016/11/rsa_11.png" width = "70%" height = "auto" alt="图片名称" align=center />   

### 6.欧几里得算法(Euclidean Algorithm)
欧几里德算法又称辗转相除法，用于计算两个整数a,b的最大公约数。
其计算原理依赖于下面的定理： 
定理：gcd(a,b) = gcd(b,a mod b)   

> 证明：a可以表示成a = kb + r ，则r = a mod b  
假设d是a,b的一个公约数，则有   
d|a, d|b，而r = a - kb，因此d|r   
因此d是(b,a mod b)的公约数   

> 假设d 是(b,a mod b)的公约数，则   
d | b , d |r ，但是a = kb +r   
因此d也是(a,b)的公约数   
因此(a,b)和(b,a mod b)的公约数是一样的，其最大公约数也必然相等，得证。  

设两数为a、b(a>b)，求a和b最大公约数(a，b)的步骤如下：用a除以b，得a÷b=q......r1(0≤r1)。若r1=0，则(a，b)=b；若r1≠0，则再用b除以r1，得b÷r1=q......r2 (0≤r2）.若r2=0，则(a，b)=r1，若r2≠0，则继续用r1除以r2，……如此下去，直到能整除为止。其最后一个为被除数的余数的除数即为(a, b)。  
例如：a=25,b=15，a/b=1......10,b/10=1......5,10/5=2.......0,最后一个为被除数余数的除数就是5,5就是所求最大公约数。

### 7.贝祖定理
所谓贝祖定理是说：
两个整数 a、b 是互质的，等价于方程 ax+by=1有整数解。
当然， 贝祖定理还有一种更一般的形式，说的是两个整数 a、b有最大公因数是c，等价于方程 ax+by=c有整数解。
这两种表述其实是等价的，因为对第二种形式稍微一变形就得到了：
$$\frac{a}{c}\ast x-\frac{b}{c}\ast y = 1$$
所以我们只需要考虑第一种形式的贝祖定理就可以了。
### 8.模幂运算(Modular exponentiation)
*  **定义**  
模运算即求余运算。“模”是“Mod”的音译，模运算多应用于程序编写中。 Mod的含义为求余。模运算在数论和程序设计中都有着广泛的应用，从奇偶数的判别到素数的判别，从模幂运算到最大公约数的求法，从孙子问题到凯撒密码问题，无不充斥着模运算的身影。虽然很多数论教材上对模运算都有一定的介绍，但多数都是以纯理论为主，对于模运算在程序设计中的应用涉及不多。  
模幂运算则是指先进行幂运算，在进行模运算。  
In symbols, given base b(底数), exponent e（指数）, and modulus m（模量）, the modular exponentiation 
c is:
$$c \equiv b^e (mod\quad m).$$
Given integers b and e, and a positive integer m, a unique solution c exists with the property 0 ≤ c < m.  
Modular exponentiation can be performed with a negative(负指数) exponent e by finding the modular multiplicative inverse d of b modulo m using the extended Euclidean algorithm. That is:
$$c \equiv b^e \equiv d^{-e} (mod\quad m).$$
where e < 0 and b ⋅ d ≡ 1 mod m.
Modular exponentiation similar to the one described above are considered easy to compute, even when the numbers involved are enormous. On the other hand, computing the discrete logarithm – that is, the task of finding the exponent e when given b, c, and m – is believed to be difficult. This one-way function behavior makes modular exponentiation a candidate for use in cryptographic algorithms.
*  **如何计算**  
> 1.直接计算  
2.

### 9.欧拉函数  
请思考以下问题：  
***
任意给定正整数n，请问在小于等于n的正整数之中，有多少个与n构成互质关系？（比如，在1到8之中，有多少个数与8构成互质关系？）
***
计算这个值的方法就叫做欧拉函数，官方定义:  
<img src="https://rjgeek.github.io/images/2016/11/rsa_12.png" width = "70%" height = "auto" alt="图片名称" align=center />  
invertible elements 表示数论倒数，数论倒数实际是对互质（素）的表示  
以φ(n)表示。在1到8之中，与8形成互质关系的是1、3、5、7，所以 φ(n) = 4。  
φ(n) 的计算方法并不复杂，但是为了得到最后那个公式，需要一步步讨论。  
*  **第一种情况**  
如果n=1，则 φ(1) = 1 。因为1与任何数（包括自身）都构成互质关系。
*  **第二种情况**  
如果n是质数，则 φ(n)=n-1 。因为质数与小于它的每一个数，都构成互质关系。比如5与1、2、3、4都构成互质关系。
*  **第三种情况**  
如果n是质数的某一个次方，即 n = p^k (p为质数，k为大于等于1的整数)，则
$$\phi{(p^k)}=p^k-p^{k-1}$$
比如 φ(8) = φ(2^3) =2^3 - 2^2 = 8 -4 = 4。
这是因为只有当一个数不包含质数p，才可能与n互质。而包含质数p的数一共有p^(k-1)个，即1×p、2×p、3×p、...、p^(k-1)×p，把它们去除，剩下的就是与n互质的数。
上面的式子还可以写成下面的形式：
$$\phi{(p^k)}=p^k-p^{k-1}=p^k(1-\frac{1}{p})$$
可以看出，上面的第二种情况是 k=1 时的特例。
*  **第四种情况**  
如果n可以分解成两个互质的整数之积，  
　　n = p1 × p2  
则  
　　φ(n) = φ(p1p2) = φ(p1)φ(p2)  
即积的欧拉函数等于各个因子的欧拉函数之积。比如，φ(56)=φ(8×7)=φ(8)×φ(7)=4×6=24。
这一条的证明要用到"中国剩余定理"，这里就不展开了，只简单说一下思路：如果a与p1互质(a&lt;p1)，b与p2互质(b&lt;p2)，c与p1p2互质(c&lt;p1p2)，则c与数对 (a,b) 是一一对应关系。由于a的值有φ(p1)种可能，b的值有φ(p2)种可能，则数对 (a,b) 有φ(p1)φ(p2)种可能，而c的值有φ(p1p2)种可能，所以φ(p1p2)就等于φ(p1)φ(p2)。
* ** 第五种情况**  
因为任意一个大于1的正整数，都可以写成一系列质数的积。
$$n=p_1^{k1}p_2^{k2}p_3^{k3}....p_r^{kr}$$
根据第4条的结论，得到
$$\phi{n}=\phi({p_1^{k1}})\phi(p_2^{k2})\phi(p_3^{k3})....\phi(p_r^{kr})$$
再根据第3条的结论，得到
$$\phi{n}=p_1^{k1}p_2^{k2}p_3^{k3}....p_r^{kr}(1-\frac{1}{p_1})(1-\frac{1}{p_2})(1-\frac{1}{p_3})(1-\frac{1}{p_r})$$
也就等于
$$\phi{n}=n(1-\frac{1}{p_1})(1-\frac{1}{p_2})(1-\frac{1}{p_3})(1-\frac{1}{p_r})$$
这就是欧拉函数的通用计算公式。比如，1323的欧拉函数，计算过程如下：
$$\phi{1323}=\phi({3^3\ast7^2})=1323(1-\frac{1}{3})(1-\frac{1}{7})=756$$

### 10.欧拉定理
欧拉函数的用处，在于欧拉定理。"欧拉定理"指的是：
如果两个正整数a和n互质，则n的欧拉函数 φ(n) 可以让下面的等式成立：
$$a^{\phi({n})}\equiv 1(mod\quad n)$$
也就是说，a的φ(n)次方被n除的余数为1。或者说，a的φ(n)次方减去1，可以被n整除。比如，3和7互质，而7的欧拉函数φ(7)等于6，所以3的6次方（729）减去1，可以被7整除（728/7=104）。
欧拉定理的证明比较复杂，这里就省略了。我们只要记住它的结论就行了。
欧拉定理可以大大简化某些运算。比如，7和10互质，根据欧拉定理，
$$7^{\phi({10})}\equiv 1(mod\quad 10)$$
已知 φ(10) 等于4，所以马上得到7的4倍数次方的个位数肯定是1。
$$7^{\phi({4k})}\equiv 1(mod\quad 10)$$
因此，7的任意次方的个位数（例如7的222次方），心算就可以算出来。
欧拉定理有一个特殊情况。
假设正整数a与质数p互质，因为质数p的φ(p)等于p-1，则欧拉定理可以写成
$$7^{\phi({p-1})}\equiv 1(mod\quad p)$$
这就是著名的费马小定理。它是欧拉定理的特例。
欧拉定理是RSA算法的核心。理解了这个定理，就可以理解RSA。
### 11.模反元素
还剩下最后一个概念：
如果两个正整数a和n互质，那么一定可以找到整数b，使得 ab-1 被n整除，或者说ab被n除的余数是1。
$$ab\equiv 1(mod\quad n)$$
这时，b就叫做a的"模反元素"。
比如，3和11互质，那么3的模反元素就是4，因为 (3 × 4)-1 可以被11整除。显然，模反元素不止一个， 4加减11的整数倍都是3的模反元素 {...,-18,-7,4,15,26,...}，即如果b是a的模反元素，则 b+kn 都是a的模反元素。
欧拉定理可以用来证明模反元素必然存在。
$$a^{\phi({n})}=a*a^{\phi({n})-1}\equiv 1(mod\quad n)$$
可以看到，a的 φ(n)-1 次方，就是a的模反元素。

### 引用
http://www.ruanyifeng.com/blog/2013/06/rsa_algorithm_part_one.html  
http://www.cnblogs.com/ziwuge/archive/2011/09/18/2180480.html  
https://en.wikipedia.org/wiki/Modular_exponentiation  
http://baike.baidu.com/link?url=o9Fn53FTV7r99qWNCYJGa3oR8yhjWV25RDvOMs0N4CCACOTFtsVzpwEAoVp50ecoYG5REZ2ksjQMfWiWw7y9Y18Y3CW1juoE7wC77h929B9tUysp4WjEt26BzMh1CA1539ZOoeUAZsucN0kz_ZVg9V-Fpt-_Z4nsiX0q9jOHm_jcDNw7Y2lL8BdRoFtmtJao 





