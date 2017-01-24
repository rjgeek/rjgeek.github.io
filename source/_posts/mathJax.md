---
title: 【算法整理】聊聊算法的复杂度 
tags:
  - 算法整理
id: 375
categories:
  - 算法整理
date: 2017-01-12 16:20:09
keywords: 算法整理，时间复杂度，空间复杂度
---
## 引文

我有个朋友有算法强迫症，每次一看到别人写的算法，就有上去改的冲动，不然就会偏头疼，最近为了治愈他，我特地写了这篇文章。
算法的衡量从两个方向出发：时间复杂度和空间复杂度。本文主要是不讲具体算法，只将算法的衡量，重点讲解如何衡量算法的复杂度，解决平时见到的XX算法时间复杂是$O(\ln_{2}^3)$,其中这个结果是怎么推导出来的，大写的$O$是什么意思，为什么用这个符号表示等类似问题,为了兼顾外文读者，本文段落同时使用你中英文。
<img src="../images/2017/01/complexity_0.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />
<!--more-->

## Big O notation

<math xmlns="http://www.w3.org/1998/Math/MathML" display="block">
<mtable columnalign="left" rowspacing="4pt" columnspacing="1em">
  <mtr>
    <mtd>
      <mo stretchy="false">&#x2190;<!-- ← --></mo>
    </mtd>
    <mtd>
      <mtext>\leftarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x27F5;<!-- ⟵ --></mo>
    </mtd>
    <mtd>
      <mtext>\longleftarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x2191;<!-- ↑ --></mo>
    </mtd>
    <mtd>
      <mtext>\uparrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x21D0;<!-- ⇐ --></mo>
    </mtd>
    <mtd>
      <mtext>\Leftarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x27F8;<!-- ⟸ --></mo>
    </mtd>
    <mtd>
      <mtext>\Longleftarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x21D1;<!-- ⇑ --></mo>
    </mtd>
    <mtd>
      <mtext>\Uparrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x2192;<!-- → --></mo>
    </mtd>
    <mtd>
      <mtext>\rightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x27F6;<!-- ⟶ --></mo>
    </mtd>
    <mtd>
      <mtext>\longrightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x2193;<!-- ↓ --></mo>
    </mtd>
    <mtd>
      <mtext>\downarrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x21D2;<!-- ⇒ --></mo>
    </mtd>
    <mtd>
      <mtext>\Rightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x27F9;<!-- ⟹ --></mo>
    </mtd>
    <mtd>
      <mtext>\Longrightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x21D3;<!-- ⇓ --></mo>
    </mtd>
    <mtd>
      <mtext>\Downarrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x2194;<!-- ↔ --></mo>
    </mtd>
    <mtd>
      <mtext>\leftrightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x27F7;<!-- ⟷ --></mo>
    </mtd>
    <mtd>
      <mtext>\longleftrightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x2195;<!-- ↕ --></mo>
    </mtd>
    <mtd>
      <mtext>\updownarrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x21D4;<!-- ⇔ --></mo>
    </mtd>
    <mtd>
      <mtext>\Leftrightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x27FA;<!-- ⟺ --></mo>
    </mtd>
    <mtd>
      <mtext>\Longleftrightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x21D5;<!-- ⇕ --></mo>
    </mtd>
    <mtd>
      <mtext>\Updownarrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x21A6;<!-- ↦ --></mo>
    </mtd>
    <mtd>
      <mtext>\mapsto</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x27FC;<!-- ⟼ --></mo>
    </mtd>
    <mtd>
      <mtext>\longmapsto</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x2197;<!-- ↗ --></mo>
    </mtd>
    <mtd>
      <mtext>\nearrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x21A9;<!-- ↩ --></mo>
    </mtd>
    <mtd>
      <mtext>\hookleftarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x21AA;<!-- ↪ --></mo>
    </mtd>
    <mtd>
      <mtext>\hookrightarrow</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x2198;<!-- ↘ --></mo>
    </mtd>
    <mtd>
      <mtext>\searrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x21BC;<!-- ↼ --></mo>
    </mtd>
    <mtd>
      <mtext>\leftharpoonup</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x21C0;<!-- ⇀ --></mo>
    </mtd>
    <mtd>
      <mtext>\rightharpoonup</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x2199;<!-- ↙ --></mo>
    </mtd>
    <mtd>
      <mtext>\swarrow</mtext>
    </mtd>
    <mtd />
  </mtr>
  <mtr>
    <mtd>
      <mo stretchy="false">&#x21BD;<!-- ↽ --></mo>
    </mtd>
    <mtd>
      <mtext>\leftharpoondown</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x21C1;<!-- ⇁ --></mo>
    </mtd>
    <mtd>
      <mtext>\rightharpoondown</mtext>
    </mtd>
    <mtd>
      <mo stretchy="false">&#x2196;<!-- ↖ --></mo>
    </mtd>
    <mtd>
      <mtext>\nwarrow</mtext>
    </mtd>
    <mtd />
  </mtr>
</mtable>
</math>

## 总结



## 声明
本文45%为翻译组合,**55%为原创**
## 引用
http://bigocheatsheet.com/
https://www.cs.northwestern.edu/academics/courses/311/html/space-complexity.html  
https://rob-bell.net/2009/06/a-beginners-guide-to-big-o-notation/


