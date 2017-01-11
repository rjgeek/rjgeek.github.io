---
title: 【系统架构】数据库演进过程中的技术债务探讨
tags:
  - 系统架构
  - 技术债务
  - Technical debt
id: 375
categories:
  - 系统架构
date: 2017-01-011 00:20:09
keywords: 系统架构，Technical debt，技术债务
---
## 引文

软件工程是一门研究方法论且非常宏观的课程，对于与一个初级开发者来说，看到有些概念和定义觉得非常没有意义，感觉学这些是在浪费时间，可能做了多年开发之后才能真正理解其中的痛楚，有些前人总结的方法和教训我们还是要注意的。不能等初亏了之后再回头。

今天在英国做的一个技术债务的分享，其中拿了阿里巴巴的数据库演进做了案例分析，其中的有些数据可能不够准确，毕竟之前没在阿里工作过，但是不影响对其中的讲解。下面引用维基百科技术负债的定义开始本文的分享。

>技术负债（英语：Technical debt），又译技术债，也称为设计负债（design debt）、代码负债（code debt），是编程及软件工程中的一个比喻。指开发人员为了加速软件开发，在应该采用最佳方案时进行了妥协，改用了短期内能加速软件开发的方案，从而在未来给自己带来的额外开发负担。这种技术上的选择，就像一笔债务一样，虽然眼前看起来可以得到好处，但必须在未来偿还。软件工程师必须付出额外的时间和精力持续修复之前的妥协所造成的问题及副作用，或是进行重构，把架构改善为最佳实现方式。
<!--more-->


## 整体结构

本文开始介绍了什么是技术债务，简单介绍阿里巴巴和他的数据库变迁，技术债务和数据库演进之间的关系，技术债务在数据库演进中发挥的作用。 

技术负债比喻由漫无计划的软件架构，或者匆忙的软件开发引起的后果。又称为设计负债。1992年，沃德·坎宁安首次将技术的复杂比作为负债。第一次发布代码，就好比借了一笔钱。只要通过不断重写来偿还债务，小额负债便可以加速开发。但久未偿还债务会引发危险。复用马马虎虎的代码，类似于负债的利息。整个部门有可能因为松散的实现，不完全的面向对象的设计或其他诸如此类的负债而陷入窘境
 
<img src="../images/2017/01/technicalTebt_2.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

## 什么是技术债务
当你做一件事情的时候，你有两种选择去实现它，一种是草草了事，但是后期问题特别多，非常难维护，另一个总经过精心的策划与安排，
技术债务是一个非常好的比喻去解释这种现象。

<img src="../images/2017/01/technicalTebt_3.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

技术债务非常像银行的财务债务，当你欠了银行一英镑，日利率是10%，第二天你就要还银行1.1磅，技术债务也会出现利滚利的现象。

<img src="../images/2017/01/technicalTebt_4.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

技术债务是有维基百科的创始人Ward Cunningham在1992年提出，“你若是不偿还开始的技术债务，每一分钟都在累加”

<img src="../images/2017/01/technicalTebt_5.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

软件工程是一门非常实际的工程，只谈理论非常的空洞，而且没有意义，这个PPT是用来过渡的，下面引出阿里巴巴的数据库演进这个例子。

<img src="../images/2017/01/technicalTebt_6.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

## 阿里巴巴和他的数据库演变

阿里巴巴集团（英语：Alibaba Group），（NYSE：BABA）创立于1999年，是一间提供电子商务在线交易平台的公司，业务包括B2B贸易、网上零售、购物搜索引擎、第三方支付和云计算服务。集团的子公司及关系公司有阿里巴巴B2B、淘宝网、天猫、一淘网、阿里云计算及支付宝。旗下的淘宝网和天猫在2012年销售额达到1.1万亿人民币，超过亚马逊公司和eBay之和。其2015年度商品交易总额已经超过3万亿元人民币，是全球最大零售商。

<img src="../images/2017/01/technicalTebt_7.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

因为在英国做演讲，所以引用BBC的数据比较权威，这个是引自BBC的在2016年一次新闻报道。我想强调是是数据增长，必须说明的是这个数据量是根据网上的很多资料推算出来的，实际并不一定准确。但增长量确实非常迅速。

<img src="../images/2017/01/technicalTebt_8.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

阿里巴巴在过去15年对数据库进行的调整。这个数据时间可能会有一单误差，但是整体趋势是没有问题的。

<img src="../images/2017/01/technicalTebt_9.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

这段话仍然是过渡的，用来引出来问题，数据库演进和技术债务之间的关系
<img src="../images/2017/01/technicalTebt_10.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

## 数据库变革的原因

我们常常挂在嘴边的原因（数据量过大，并发过大，创造更多的价值）往往是冰山一角，一些更深次的原因往往被忽略，在实际的运用中这些原因可能占了更大的比重，这些原因包括：日益增长的运维费用，系统运行的风险和越来越差劲的客户应答。

<img src="../images/2017/01/technicalTebt_11.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

### 日益增长的运维费用

在这里举了一个简单的例子，我们想查询一个用户的用户信息从一个简单的表中，如果数据量只有1000条，那么在查询的时候就非常简单。

<img src="../images/2017/01/technicalTebt_12.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

如果数据量增长到了1万条，我们还可以用上面的简单语句进行查询，可能依然能查出来结果，但是速度非常慢。这个时候一个比较好的方式就是增加索引。

<img src="../images/2017/01/technicalTebt_13.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

如果数据增加到1千万条，单纯的使用索引已经很难解决问题，这个时候可能要考虑下水平分库和垂直分库。

<img src="../images/2017/01/technicalTebt_14.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

数据库的运维费用增加主要体现在两个方面，一方面如上面看到的数据的不断增加导致的技术变得复杂，另一方面之前的产生的技术债务会累积不断的累积。

<img src="../images/2017/01/technicalTebt_15.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

### 系统运行风险

就像你看到下面的图一样，系统中任何一部分变化都会影响其他部分，你在修复或者偿还之前的债务（问题）的时候，其他的部分有损毁的可能。

<img src="../images/2017/01/technicalTebt_16.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

依然用一个简单的例子来阐述，下面的例子中一个存储过程应该有四个服务在调用，在实际的开发环境中可能比这种情况更加严重，因为随着时间的推移你甚至不知道哪些服务调用哪些存储过程了。

<img src="../images/2017/01/technicalTebt_17.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

有一天客户提出了新的特性，需要改动服务2，在改动的同时可能无意修改了这个存储过程，所带来的后果的影响将是无法估量的，因为其他的服务都会受到影响。

<img src="../images/2017/01/technicalTebt_18.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

上面的这两个原因加速了用户逃离你的服务，我们都知道数据库架构本身没有什么价值，他的价值主要体现在为用户创造的价值，用户一旦逃离，势必会降低架构的价值。

<img src="../images/2017/01/technicalTebt_19.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />
## 技术债务实际运用
对上面原因进行总结后，在此处开始探讨另一个问题，为什么有些数据库架构用的时间长，有些架构用的时间短。开始引入另一个概念技术债务分类

Bob大叔和Martin Fowler对于技术负债的进行了划分。他划分的四个象限如下：  
**不计后果，故意的**——团队没有时间做设计，仅仅给出了一个匆忙做出的方案，缺乏对质量的预见。 
**谨慎，故意的**——尽管有很多已知的缺陷，但团队必须现在交付产品，同时对此造成的后果心中有数。  
**不计后果，无意的**——团队压根就不知道基本的设计原则，更不用说引入的坏味道了。  
**谨慎，无意的**——那些拥有优秀设计师的团队很容易遇到这种情况。他们交付的方案具有商业价值，但在完成方案后才明白什么才是最好的方案。  
原文地址：https://martinfowler.com/bliki/TechnicalDebtQuadrant.html

<img src="../images/2017/01/technicalTebt_20.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

下面举了一个例子，支付宝的例子，简单的介绍了支付宝是啥（毕竟是老外，虽然在国内很火，对于国外人一脸懵逼啊）

<img src="../images/2017/01/technicalTebt_21.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

支付宝于2004年末发布，实际在这个时候阿里巴巴几乎完成数据往oracle的迁移。实际他们已经意识到了MYSQL数据库的安全问题，oracle在当时提供了几乎完美的安全解决方案，成了当时支付宝能迅速崛起的一个重要支撑。

<img src="../images/2017/01/technicalTebt_22.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

话锋一转，如果他们当时么有意识到这个问题，可能问题就会很糟糕，在面对巨大是市场挤压的时候，在去调整数据库，数据库架构势必会拖后腿，可能会造成利益的损益。

<img src="../images/2017/01/technicalTebt_23.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

## 总结

最后总结一下今天所讲的东西，开始引入技术债务概念，简单介绍介绍下阿里巴巴的数据库变更，重点讲解了技术债务和数据库架构变更之间的关系，最后举出了技术债务的分类在实际项目的应用。

<img src="../images/2017/01/technicalTebt_24.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />

最后：我不得不说虽然写了很多，有些推论还是不够严谨，可能导致数据库的变更的原因比我这里复杂的多，我在这里想强调是其中一定有技术债务占得份额，所以请各位在开发设计的时候意识到这些问题。（我也不爱弄这些理论， 但我常常劝自己你成了架构师这些东西就变了就有意义了）

## 声明
本文10%为翻译组合,**90%为原创**
## 引用

[1] Publicnow.com. (2017). Alibaba Group Holding Ltd. (via Public) / Alibaba Group Generated RMB 120.7 Billion (USD 17.8 Billion) of GMV .... [online] Available at: http://www.publicnow.com/view/D5A8827A60D3A2CE13AAF687DEA41FA68F6616DD?2016-11-14-17:01:57+00:00-xxx642 [Accessed 6 Jan. 2017].

[2] Tom, E., Aurum, A. and Vidgen, R. (2013). An exploration of technical debt. Journal of Systems and Software, 86(6), pp.1498- 1516. 

[3] Alibabagroup.com. (2016). Alibaba Group. [online] Available at: http://www.alibabagroup.com/en/about/history [Accessed 8 Dec. 2016]. 

[4] Fowler, M. (2016). bliki: TechnicalDebtQuadrant. [online] martinfowler.com. Available at: http://www.martinfowler.com/bliki/TechnicalDebtQuadrant.html [Accessed 7 Dec. 2016]. 

[6] Gao, Y., Shim, K., Ding, Z., Jin, P., Zujie, R., Xiao, Y., Liu, A. and Qiao, S. (2013). Web-Age information management. 1st ed. Berlin: Springer, p.3.

[7] Marketing China. (2017). Review of the Chinese online payments - Marketing China. [online] Available at: http://marketingtochina.com/review-chinese-online-payments/ [Accessed 6 Jan. 2017].

[7] Horkoff, J., Li, T., Li, F., Salnitri, M., Cardoso, E., Giorgini, P., Mylopoulos, J. and Pimentel, J. (2014). Taking goal models downstream: A systematic roadmap. In: 2014 IEEE Eighth International Conference on Research Challenges in Information Science (RCIS). IEEE. 

[8] Fowler, M. (2016). bliki: CannotMeasureProductivity. [online] martinfowler.com. Available at: http://martinfowler.com/bliki/CannotMeasureProductivity.html [Accessed 8 Dec. 2016].

[10] DeMarco, T. (1982). Controlling software projects. Management, measurement and estimation. 1st ed. New York,N.Y.,Yourdon,1982,: Prentice Hall;, p.3.

[11] Chhetri, S. (2017). How we used unit testing to tackle technical debt. [online] Shhetri.github.io. Available at: http://shhetri.github.io/unit-testing-to-tackle-technical-debt [Accessed 6 Jan. 2017].

[13] New Health Advisor. (2017). Why Can't I Make Decisions?. [online] Available at: http://www.newhealthadvisor.com/why-can't-i-make-decisions.html [Accessed 6 Jan. 2017].

[14] Persson, A. and Stirna, J. (2015). Advanced Information Systems Engineering Workshops. In: CAiSE 2015 International Workshops. p.215. 


