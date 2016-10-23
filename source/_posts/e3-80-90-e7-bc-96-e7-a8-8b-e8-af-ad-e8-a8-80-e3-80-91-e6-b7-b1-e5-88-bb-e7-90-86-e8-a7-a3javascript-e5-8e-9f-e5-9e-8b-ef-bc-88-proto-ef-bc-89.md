---
title: 【编程语言】深刻理解javascript原型（_proto_）
id: 1056
categories:
  - 编程语言
date: 2016-05-10 21:19:47
tags:
---

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">原文作者：汤姆大叔</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">原文地址：</span><span style="font-family: Georgia;">http://www.cnblogs.com/TomXu/archive/2012/01/12/2308594.html
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">我们首先来看一下对象</span><span style="font-family: Georgia;">[Object]</span><span style="font-family: 宋体;">的概念，这也是</span><span style="font-family: Georgia;">ECMASript</span><span style="font-family: 宋体;">中最基本的概念。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: white; font-size: 15pt;">**<span style="font-family: 宋体;">对象</span><span style="font-family: Georgia;">Object
</span>**</span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: Georgia;">ECMAScript</span><span style="font-family: 宋体;">是一门高度抽象的面向对象</span><span style="font-family: Georgia;">(object-oriented)</span><span style="font-family: 宋体;">语言，用以处理</span><span style="font-family: Georgia;">Objects</span><span style="font-family: 宋体;">对象</span><span style="font-family: Georgia;">. </span><span style="font-family: 宋体;">当然，也有基本类型，但是必要时，也需要转换成</span><span style="font-family: Georgia;">object</span><span style="font-family: 宋体;">对象来用。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #ff6600; font-family: 宋体; font-size: 12pt;">An object is a collection of properties and has a single prototype object. The prototype may be either an object or the null value.</span>

<span style="color: #ff6600;">Object是一个属性的集合，并且都拥有一个单独的原型对象[prototype object]. 这个原型对象[prototype object]可以是一个object或者null值。</span>

<span style="color: #ff6600; font-family: 宋体; font-size: 12pt;"><span style="color: black;"><span style="color: #ff6600;"><span style="color: black;"><!--more-->
</span></span></span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">让我们来举一个基本</span><span style="font-family: Georgia;">Object</span><span style="font-family: 宋体;">的例子，首先我们要清楚，一个</span><span style="font-family: Georgia;">Object</span><span style="font-family: 宋体;">的</span><span style="font-family: Georgia;">prototype</span><span style="font-family: 宋体;">是一个内部的</span><span style="color: #ff6600;"><span style="font-family: Georgia;">[[prototype]]</span><span style="color: #333333;"><span style="font-family: 宋体;">属性的引用。</span><span style="font-family: Georgia;">
</span></span></span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">不过一般来说，我们会使用</span><span style="color: #ff6600;"><span style="font-family: Georgia;">__&lt;</span><span style="font-family: 宋体;">内部属性名</span><span style="font-family: Georgia;">&gt;__<span style="color: #333333;"> </span></span><span style="font-family: 宋体;">下划线来代替双括号，例如</span><span style="font-family: Georgia;">__proto__<span style="color: #333333;">(</span></span><span style="font-family: 宋体;">这是某<span style="color: #333333;">些脚本引擎比如</span></span><span style="font-family: Georgia;">SpiderMonkey</span><span style="color: #333333;"><span style="font-family: 宋体;">的对于原型概念的具体实现，尽管并非标准</span><span style="font-family: Georgia;">)</span><span style="font-family: 宋体;">。</span><span style="font-family: Georgia;">
</span></span></span></span>

<span style="color: blue; font-family: 宋体; font-size: 12pt;">var<span style="color: black;"> foo = {
x: 10,
y: 20
};
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">上述代码</span><span style="font-family: Georgia;">foo</span><span style="font-family: 宋体;">对象有两个显式的属性</span><span style="font-family: Georgia;">[explicit own properties]</span><span style="font-family: 宋体;">和一个自带隐式的</span><span style="font-family: Georgia;"> __proto__ </span><span style="font-family: 宋体;">属性</span><span style="font-family: Georgia;">[implicit __proto__ property]</span><span style="font-family: 宋体;">，指向</span><span style="font-family: Georgia;">foo</span><span style="font-family: 宋体;">的原型。</span><span style="font-family: Georgia;">
</span></span>

![](http://helloword.1kapp.com/wp-content/uploads/2016/06/061016_1319_javas1.png)<span style="color: #333333; font-family: Georgia; font-size: 10pt;">
</span>

<span style="color: #333333;"><span style="font-size: 9pt;"><span style="font-family: 宋体;">图</span><span style="font-family: Verdana;"> 1\. </span><span style="font-family: 宋体;">一个含有原型的基本对象</span></span><span style="font-family: Georgia; font-size: 10pt;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">为什么需要原型呢，让我们考虑</span><span style="font-family: Georgia;">
</span><span style="font-family: 宋体;">原型链</span><span style="font-family: Georgia;">
</span><span style="font-family: 宋体;">的概念来回答这个问题。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: white; font-size: 15pt;">**<span style="font-family: 宋体;">原型链（</span><span style="font-family: Georgia;">Prototype chain</span><span style="font-family: 宋体;">）</span><span style="font-family: Georgia;">
</span>**</span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">原型对象也是普通的对象，并且也有可能有自己的原型，如果一个原型对象的原型不为</span><span style="font-family: Georgia;">null</span><span style="font-family: 宋体;">的话，我们就称之为原型链（</span><span style="font-family: Georgia;">prototype chain</span><span style="font-family: 宋体;">）。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #ff6600; font-family: 宋体; font-size: 12pt;">A prototype chain is a finite chain of objects which is used to implemented inheritance and shared properties.<span style="color: black;">
<span style="color: #ff6600;">原型链是一个由对象组成的有限对象链由于实现继承和共享属性。<span style="color: black;">
</span></span></span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">想象一个这种情况，</span><span style="font-family: Georgia;">2</span><span style="font-family: 宋体;">个对象，大部分内容都一样，只有一小部分不一样，很明显，在一个好的设计模式中，我们会需要重用那部分相同的，而不是在每个对象中重复定义那些相同的方法或者属性。在基于类</span><span style="font-family: Georgia;">[class-based]</span><span style="font-family: 宋体;">的系统中，这些重用部分被称为类的继承</span><span style="font-family: Georgia;"> – </span><span style="font-family: 宋体;">相同的部分放入</span><span style="color: #ff6600;"><span style="font-family: Georgia;">class A</span><span style="color: #333333;"><span style="font-family: 宋体;">，然后</span><span style="color: #ff6600;"><span style="font-family: Georgia;">class B</span><span style="color: #333333;"><span style="font-family: 宋体;">和</span><span style="color: #ff6600;"><span style="font-family: Georgia;">class C</span><span style="color: #333333;"><span style="font-family: 宋体;">从</span><span style="color: #ff6600;"><span style="font-family: Georgia;">A</span><span style="color: #333333;"><span style="font-family: 宋体;">继承，并且可以声明拥有各自的独特的东西。</span><span style="font-family: Georgia;">
</span></span></span></span></span></span></span></span></span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: Georgia;">ECMAScript</span><span style="font-family: 宋体;">没有类的概念。但是，重用</span><span style="font-family: Georgia;">[reuse]</span><span style="font-family: 宋体;">这个理念没什么不同（某些方面，甚至比</span><span style="font-family: Georgia;">class-</span><span style="font-family: 宋体;">更加灵活），可以由</span><span style="font-family: Georgia;">prototype chain</span><span style="font-family: 宋体;">原型链来实现。这种继承被称为</span><span style="font-family: Georgia;">delegation based inheritance-</span><span style="font-family: 宋体;">基于继承的委托，或者更通俗一些，叫做原型继承。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">类似于类</span><span style="font-family: Georgia;">"A"</span><span style="font-family: 宋体;">，</span><span style="font-family: Georgia;">"B"</span><span style="font-family: 宋体;">，</span><span style="font-family: Georgia;">"C"</span><span style="font-family: 宋体;">，在</span><span style="font-family: Georgia;">ECMAScript</span><span style="font-family: 宋体;">中尼创建对象类</span><span style="font-family: Georgia;">"a"</span><span style="font-family: 宋体;">，</span><span style="font-family: Georgia;">"b"</span><span style="font-family: 宋体;">，</span><span style="font-family: Georgia;">"c"</span><span style="font-family: 宋体;">，相应地，</span><span style="font-family: Georgia;">
</span><span style="font-family: 宋体;">对象</span><span style="font-family: Georgia;">"a" </span><span style="font-family: 宋体;">拥有对象</span><span style="font-family: Georgia;">"b"</span><span style="font-family: 宋体;">和</span><span style="font-family: Georgia;">"c"</span><span style="font-family: 宋体;">的共同部分。同时对象</span><span style="font-family: Georgia;">"b"</span><span style="font-family: 宋体;">和</span><span style="font-family: Georgia;">"c"</span><span style="font-family: 宋体;">只包含它们自己的附加属性或方法。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: blue; font-family: 宋体; font-size: 12pt;">var<span style="color: black;"> a = {
x: 10,
calculate: <span style="color: blue;">function<span style="color: black;"> (z) {</span></span></span></span>

<span style="color: blue;">return<span style="color: black;">
<span style="color: blue;">this<span style="color: black;">.x + <span style="color: blue;">this<span style="color: black;">.y + z
}
};</span></span></span></span></span></span>

<span style="color: blue;">var<span style="color: black;"> b = {
y: 20,
__proto__: a
};</span></span>

<span style="color: blue;">var<span style="color: black;"> c = {
y: 30,
__proto__: a
};</span></span>

<span style="color: green;">// 调用继承过来的方法
<span style="color: black;">b.calculate(30); <span style="color: green;">// 60
<span style="color: black;">c.calculate(40); <span style="color: green;">// 80<span style="color: black;">
</span></span></span></span></span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">这样看上去是不是很简单啦。</span><span style="font-family: Georgia;">b</span><span style="font-family: 宋体;">和</span><span style="font-family: Georgia;">c</span><span style="font-family: 宋体;">可以使用</span><span style="font-family: Georgia;">a</span><span style="font-family: 宋体;">中定义的</span><span style="font-family: Georgia;">calculate</span><span style="font-family: 宋体;">方法，这就是有原型链来</span><span style="font-family: Georgia;">[prototype chain]</span><span style="font-family: 宋体;">实现的。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">原理很简单</span><span style="font-family: Georgia;">:</span><span style="font-family: 宋体;">如果在对象</span><span style="font-family: Georgia;">b</span><span style="font-family: 宋体;">中找不到</span><span style="font-family: Georgia;">calculate</span><span style="font-family: 宋体;">方法</span><span style="font-family: Georgia;">(</span><span style="font-family: 宋体;">也就是对象</span><span style="font-family: Georgia;">b</span><span style="font-family: 宋体;">中没有这个</span><span style="font-family: Georgia;">calculate</span><span style="font-family: 宋体;">属性</span><span style="font-family: Georgia;">), </span><span style="font-family: 宋体;">那么就会沿着原型链开始找。如果这个</span><span style="font-family: Georgia;">calculate</span><span style="font-family: 宋体;">方法在</span><span style="font-family: Georgia;">b</span><span style="font-family: 宋体;">的</span><span style="font-family: Georgia;">prototype</span><span style="font-family: 宋体;">中没有找到，那么就会沿着原型链找到</span><span style="font-family: Georgia;">a</span><span style="font-family: 宋体;">的</span><span style="font-family: Georgia;">prototype</span><span style="font-family: 宋体;">，一直遍历完整个原型链。记住，一旦找到，就返回第一个找到的属性或者方法。因此，第一个找到的属性成为继承属性。如果遍历完整个原型链，仍然没有找到，那么就会返回</span><span style="color: #ff6600;"><span style="font-family: Georgia;">undefined</span><span style="color: #333333;"><span style="font-family: 宋体;">。</span><span style="font-family: Georgia;">
</span></span></span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">注意一点，</span><span style="font-family: Georgia;">this</span><span style="font-family: 宋体;">这个值在一个继承机制中，仍然是指向它原本属于的对象，而不是从原型链上找到它时，它所属于的对象。例如，以上的例子，</span><span style="font-family: Georgia;">this.y</span><span style="font-family: 宋体;">是从</span><span style="font-family: Georgia;">b</span><span style="font-family: 宋体;">和</span><span style="font-family: Georgia;">c</span><span style="font-family: 宋体;">中获取的，而不是</span><span style="font-family: Georgia;">a</span><span style="font-family: 宋体;">。当然，你也发现了</span><span style="font-family: Georgia;">this.x</span><span style="font-family: 宋体;">是从</span><span style="font-family: Georgia;">a</span><span style="font-family: 宋体;">取的，因为是通过原型链机制找到的。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">如果一个对象的</span><span style="font-family: Georgia;">prototype</span><span style="font-family: 宋体;">没有显示的声明过或定义过，那么</span><span style="font-family: Georgia;">__prototype__</span><span style="font-family: 宋体;">的默认值就是</span><span style="font-family: Georgia;">object.prototype, </span><span style="font-family: 宋体;">而</span><span style="font-family: Georgia;">object.prototype</span><span style="font-family: 宋体;">也会有一个</span><span style="font-family: Georgia;">__prototype__, </span><span style="font-family: 宋体;">这个就是原型链的终点了，被设置为</span><span style="font-family: Georgia;">null</span><span style="font-family: 宋体;">。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">下面的图示就是表示了上述</span><span style="font-family: Georgia;">a,b,c</span><span style="font-family: 宋体;">的继承关系</span><span style="font-family: Georgia;">
</span></span>

![](http://helloword.1kapp.com/wp-content/uploads/2016/06/061016_1319_javas2.png)<span style="color: #333333; font-family: Georgia; font-size: 10pt;">
</span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">图</span><span style="font-family: Georgia;"> 2\. </span><span style="font-family: 宋体;">原型链</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">原型链通常将会在这样的情况下使用：对象拥有</span><span style="font-family: Georgia;">
</span><span style="font-family: 宋体;">相同或相似的状态结构</span><span style="font-family: Georgia;">(same or similar state structure) </span><span style="font-family: 宋体;">（即相同的属性集合）与</span><span style="font-family: Georgia;">
</span><span style="font-family: 宋体;">不同的状态值</span><span style="font-family: Georgia;">(different state values)</span><span style="font-family: 宋体;">。在这种情况下，我们可以使用</span><span style="font-family: Georgia;">
</span><span style="font-family: 宋体;">构造函数</span><span style="font-family: Georgia;">(Constructor) </span><span style="font-family: 宋体;">在</span><span style="font-family: Georgia;">
</span><span style="font-family: 宋体;">特定模式</span><span style="font-family: Georgia;">(specified pattern) </span><span style="font-family: 宋体;">下创建对象。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: white; font-size: 15pt;">**<span style="font-family: 宋体;">构造函数</span><span style="font-family: Georgia;">(Constructor)
</span>**</span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">除了创建对象，构造函数</span><span style="font-family: Georgia;">(constructor) </span><span style="font-family: 宋体;">还做了另一件有用的事情</span><span style="font-family: Georgia;">—</span><span style="font-family: 宋体;">自动为创建的新对象设置了原型对象</span><span style="font-family: Georgia;">(prototype object) </span><span style="font-family: 宋体;">。原型对象存放于</span><span style="font-family: Georgia;"> ConstructorFunction.prototype </span><span style="font-family: 宋体;">属性中。</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">例如，我们重写之前例子，使用构造函数创建对象</span><span style="font-family: Georgia;">"b"</span><span style="font-family: 宋体;">和</span><span style="font-family: Georgia;">"c"</span><span style="font-family: 宋体;">，那么对象</span><span style="font-family: Georgia;">"a"</span><span style="font-family: 宋体;">则扮演了</span><span style="font-family: Georgia;">"Foo.prototype"</span><span style="font-family: 宋体;">这个角色：</span><span style="font-family: Georgia;">
</span></span>

<span style="color: green; font-family: 宋体; font-size: 12pt;">// 构造函数
<span style="color: blue;">function<span style="color: black;"> Foo(y) {</span></span></span>

<span style="color: green;">// 构造函数将会以特定模式创建对象：被创建的对象都会有"y"属性
<span style="color: black;">
<span style="color: blue;">this<span style="color: black;">.y = y;
}</span></span></span></span>

<span style="color: green;">// "Foo.prototype"存放了新建对象的原型引用
// 所以我们可以将之用于定义继承和共享属性或方法
// 所以，和上例一样，我们有了如下代码：
</span>

<span style="color: green;">// 继承属性"x"
<span style="color: black;">Foo.prototype.x = 10;</span></span>

<span style="color: green;">// 继承方法"calculate"
<span style="color: black;">Foo.prototype.calculate = <span style="color: blue;">function<span style="color: black;"> (z) {</span></span></span></span>

<span style="color: blue;">return<span style="color: black;">
<span style="color: blue;">this<span style="color: black;">.x + <span style="color: blue;">this<span style="color: black;">.y + z;
};</span></span></span></span></span></span>

<span style="color: green;">// 使用foo模式创建 "b" and "c"
<span style="color: blue;">var<span style="color: black;"> b = <span style="color: blue;">new<span style="color: black;"> Foo(20);
<span style="color: blue;">var<span style="color: black;"> c = <span style="color: blue;">new<span style="color: black;"> Foo(30);</span></span></span></span></span></span></span></span></span>

<span style="color: green;">// 调用继承的方法
<span style="color: black;">b.calculate(30); <span style="color: green;">// 60
<span style="color: black;">c.calculate(40); <span style="color: green;">// 80
</span></span></span></span></span>

<span style="color: green;">// 让我们看看是否使用了预期的属性
</span>

console.log(

b.__proto__ === Foo.prototype, <span style="color: green;">// true
<span style="color: black;"> c.__proto__ === Foo.prototype, <span style="color: green;">// true
</span></span></span>

<span style="color: green;">// "Foo.prototype"自动创建了一个特殊的属性"constructor"
<span style="color: black;">
<span style="color: green;">// 指向a的构造函数本身
<span style="color: black;">
<span style="color: green;">// 实例"b"和"c"可以通过授权找到它并用以检测自己的构造函数
</span></span></span></span></span>

b.constructor === Foo, <span style="color: green;">// true
<span style="color: black;"> c.constructor === Foo, <span style="color: green;">// true
<span style="color: black;"> Foo.prototype.constructor === Foo <span style="color: green;">// true
</span></span></span></span></span>

b.calculate === b.__proto__.calculate, <span style="color: green;">// true
<span style="color: black;"> b.__proto__.calculate === Foo.prototype.calculate <span style="color: green;">// true
</span></span></span>

);

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">上述代码可表示为如下的关系：</span><span style="font-family: Georgia;">
</span></span>

![](http://helloword.1kapp.com/wp-content/uploads/2016/06/061016_1319_javas3.png)<span style="color: #333333; font-family: Georgia; font-size: 10pt;">
</span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">图</span><span style="font-family: Georgia;"> 3\. </span><span style="font-family: 宋体;">构造函数与对象之间的关系</span><span style="font-family: Georgia;">
</span></span>

<span style="color: #333333; font-size: 10pt;"><span style="font-family: 宋体;">上述图示可以看出，每一个</span><span style="font-family: Georgia;">object</span><span style="font-family: 宋体;">都有一个</span><span style="font-family: Georgia;">prototype. </span><span style="font-family: 宋体;">构造函数</span><span style="font-family: Georgia;">Foo</span><span style="font-family: 宋体;">也拥有自己的</span><span style="font-family: Georgia;">__proto__, </span><span style="font-family: 宋体;">也就是</span><span style="font-family: Georgia;">Function.prototype, </span><span style="font-family: 宋体;">而</span><span style="font-family: Georgia;">Function.prototype</span><span style="font-family: 宋体;">的</span><span style="font-family: Georgia;">__proto__</span><span style="font-family: 宋体;">指向了</span><span style="font-family: Georgia;">Object.prototype. </span><span style="font-family: 宋体;">重申一遍，</span><span style="font-family: Georgia;">Foo.prototype</span><span style="font-family: 宋体;">只是一个显式的属性，也就是</span><span style="font-family: Georgia;">b</span><span style="font-family: 宋体;">和</span><span style="font-family: Georgia;">c</span><span style="font-family: 宋体;">的</span><span style="font-family: Georgia;">__proto__</span><span style="font-family: 宋体;">属性。</span></span>