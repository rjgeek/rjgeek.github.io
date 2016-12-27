---
title: 【编程语言】Java设计模式-观察者模式
tags:
  - 编程语言
  - 设计模式
id: 375
categories:
  - 编程语言
date: 2016-12-25 22:02:09
keywords: 设计原则，编程语言
---

## 引言
java的设计模式之观察者模式，因为最近读BitTorrent的源码，因为其中用到了java的观察者模式，因此特整理复习一下，观察者模式简单点讲就是允许一个对象去观察其他的对象的活动，观察者与被观察者之间是一种订阅的关系。
<img src="https://rjgeek.github.io/images/2016/12/Observer_1.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  
<!--more-->

## 观察者模式
观察者模式定义了一种一对多的依赖关系，让多个观察者对象同时监听某一个主题对象。这个主题对象在状态上发生变化时，会通知所有观察者对象，让它们能够自动更新自己。
- 抽象主题角色:把所有对观察者对象的引用保存在一个集合中，每个抽象主题角色都可以有任意数量的观察者。抽象主题提供一个接口，可以增加和删除观察者角色。一般用一个抽象类和接口来实现。
- 抽象观察者角色：为所有具体的观察者定义一个接口，在得到主题的通知时更新自己。
- 具体主题角色：在具体主题内部状态改变时，给所有登记过的观察者发出通知。具体主题角色通常用一个子类实现。
- 具体观察者角色：该角色实现抽象观察者角色所要求的更新接口，以便使本身的状态与主题的状态相协调。通常用一个子类实现。如果需要，具体观察者角色可以保存一个指向具体主题角色的引用。    

<font color=#00ffff>吐槽：真正的布道者就应该把知识尽量简化,每次看上面的东西都一脸懵逼，简单的知识用学术的语言一解释，然后大家都不懂了，都不明白这群人实在装逼还是在分享，最后知识是用来解决问题的！！！，下面从问题开始说起</font>

观察者模式就是一种订阅模式，对象A有两种行为模式，如何会学习和会运动，对象B，C，D 就是想知道A从事这些活动的时候告知他们一下，仅此而已。在上面A扮演了被观察者，B,C，D扮演了观察者的角色。首先解决A的问题，对象A有自己的属性，有自己的方法，如下所示：  
```
public class ObjectA {
	private int i;  // 私有属性

	public void doStudy(){ //会学习
		System.out.println("A is studying");
	}
	
	public void doSport(){ //会运动
		System.out.println("A is doing sport");
	}
}
```
对象A想告诉B，C，D，那么至少A中有一个方法是干这个事情的，直接将告知B,C,D这个事情抽象成一个方法，那么就是这样的

```
public class ObjectA {
	ObjectB Objectb; //需要通知的对象
	ObjectC Objectc; //需要通知的对象
	ObjectD Objectd; //需要通知的对象
	
	
	private int i;  // 私有属性

	public void doStudy(){ //会学习
		System.out.println("A is studying");
		notifyObserver(); //告诉其他人我学习，弄得自己很爱学习似的
	}
	
	public void doSport(){ //会运动
		System.out.println("A is doing sport");
		notifyObserver();//告诉其他人我运动了，掩饰自己不是胖子
	}
	
	protected void notifyObserver(){
		Objectb.update(); //告知B  
		Objectc.update(); //告知C
		Objectd.update(); //告知D
    }
}
```
看似上面的东西已经实现了我们当初的功能，但是过于简单不够通用化，我们设想一种场景，假设我们需要通知对象E，那么我们势必需要姚调整上面的代码，我们能不能保存一个通知列表，然后直接维护这个通知列表，看似是可行的，还有一个问题，通知列表中假设我们用List对象，那么List中应该保存何种对象呢，我们可以找出素有的对象的公共特性，貌似所有对象都继承了Object
```
public class ObjectA {
	
	private List<Object> watcherObjectist = new ArrayList<Object>(); //需要通知的对象列表
	
	//维护这个列表的方法，新增观察者（通知对象）
	public void addWatcher(Object watcher){
		watcherObjectist.add(watcher);
    }
	//维护这个列表的方法，删除观察者（通知对象）
	public void removeWatcher(Object watcher){
		watcherObjectist.remove(watcher);
    }
	
	private int i;  // 私有属性

	public void doStudy(){ //会学习
		System.out.println("A is studying");
		notifyObserver(); //告诉其他人我学习，弄得自己很爱学习似的
	}
	
	public void doSport(){ //会运动
		System.out.println("A is doing sport");
		notifyObserver();//告诉其他人我运动了，掩饰自己不是胖子
	}
	
	protected void notifyObserver(){
		for(Object l: watcherObjectist){
			//经过判断决定通知哪一个
			//((ObjectB)l).update();
			//((ObjectC)l).update();
			//((ObjectD)l).update();
		}
    }
}
```
到目前为止，已经具备了一个观察者应该有的功能，但是还是有不完美之处，比如在最后通知的时候还要分别去判断各个对象然后一一通知，如果我们将所有的观察者抽象出一个接口，可能有人会问为什么不是抽象成父类，因为父类破坏了原有对象的结构，所谓的父类一定是一类，然后我们接受者并不一定是一类，所有在这里抽象成接口最为合适，接口中定义了观察者受到消息应该处理的方法，具体的方法在每个观察者中去实现，这样会更加灵活，因为每个观察者接收到消息后处理的方式可能不同，因为将以上代码变如何变更。  
1.增加观察者B，C，D的抽象类  
```
public interface ImplWatcher {
	public void update();
}
```
2.每个观察者实现这个接口，当然实现凡是可以不同
```
public class ObjectB implements ImplWatcher {
	@Override
	public void update() {
		System.out.println("ObjectB被通知");
	}
}
public class ObjectC implements ImplWatcher {
	@Override
	public void update(){
		System.out.println("ObjectC被通知");
	}
}
public class ObjectD implements ImplWatcher {
	@Override
	public void update(){
		System.out.println("ObjectD被通知");
	}
}
```
2.在原来的方法中直接执行接口中的方法，最后一部分抽象如下：
```
	protected void notifyObserver(){
		for(ImplWatcher l: watcherObjectist){
			l.update();
		}
    }
```
到这一步已经接近完美了，但是依然还有另外一个没有提及的问题，那就是如果有多个被观察者A1，A2，A3，上面的代码能否重用，答案是肯定的，我只需将上面的A进行抽象，将A中的操作观察者列表的部分抽象成接口，至于为什么是接口而不是父类，我上面已经提及，因此更改之后的代码，可以调整为如下：
```
public interface ImplWatched {
	//维护这个列表的方法，新增观察者（通知对象）
	public void addWatcher(ImplWatcher watcher);
	//维护这个列表的方法，删除观察者（通知对象）
	public void removeWatcher(ImplWatcher watcher);
	//通知事件
	public void notifyObserver();
}
```
```
public class ObjectA implements ImplWatched {
	
	private List<ImplWatcher> watcherObjectist = new ArrayList<ImplWatcher>(); //需要通知的对象列表
	
	//维护这个列表的方法，新增观察者（通知对象）
	@Override
	public void addWatcher(ImplWatcher watcher){
		watcherObjectist.add(watcher);
    }
	
	//维护这个列表的方法，删除观察者（通知对象）
	@Override
	public void removeWatcher(ImplWatcher watcher){
		watcherObjectist.remove(watcher);
    }
	
	private int i;  // 私有属性

	public void doStudy(){ //会学习
		System.out.println("A is studying");
		notifyObserver(); //告诉其他人我学习，弄得自己很爱学习似的
	}
	
	public void doSport(){ //会运动
		System.out.println("A is doing sport");
		notifyObserver();//告诉其他人我运动了，掩饰自己不是胖子
	}
	
	@Override
	public void notifyObserver(){
		for(ImplWatcher l: watcherObjectist){
			l.update();
		}
    }
}
```
到这里就演绎完了整个观察者模式的全过程。最后写个测试类，测试一下
```
public class Test {
	public static void main(String[] args)  {
		ObjectA oa = new ObjectA();
		oa.addWatcher(new ObjectB()); //添加观察者
		oa.addWatcher(new ObjectC()); //添加观察者
		oa.addWatcher(new ObjectD()); //添加观察者
		oa.doSport();
	}
}
```
结果输出：  
A is doing sport  
ObjectB被通知  
ObjectC被通知  
ObjectD被通知  


## JDK自带的观察者类Observer和Observable
java的jdk中提供了Observer和Observable可供直接调用，具体用法如下：  
被观察者  
```
public class ObjectF extends Observable{
	public void doSomething(){
		System.out.println("I am doing something");
		setChanged();
	    notifyObservers();
	}
}
```
观察者  
```
public class ObjectE implements Observer{
	@Override
	public void update(Observable o, Object arg) {
		System.out.println("观察者ObjectE 接收到了来自ObjectF的广播消息");
	}
}
```
测试类
```
public class Test {
	public static void main(String[] args)  {
		ObjectF of = new ObjectF();
		of.addObserver(new ObjectE());
		of.doSomething();
	}
}
```
输出结果  
I am doing something  
观察者ObjectE 接收到了来自ObjectF的广播消息  

## 总结
本文总结了原生态的观察者模式和java自带的观察者模式，最后总结一句话，就是拿着父类的指针到处传，这里的父类指的就是分发通知列表。
## 声明
本文30%为翻译组合,70%为原创
## 引用
http://www.javamex.com/tutorials/threads/context_switch.shtml  
http://bbs.csdn.net/topics/190140872  
http://www.java2s.com/Code/Java/Design-Pattern/AsimpledemoofObservableandObserver.htm