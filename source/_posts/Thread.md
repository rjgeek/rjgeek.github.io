---
title: 【编程语言】java的线程的实现方式
tags:
  - 编程语言
id: 375
categories:
  - 编程语言，java
date: 2016-12-24 17:02:09
keywords: Thread，线程，编程语言
---

## 引言
刚刚从Grove Park公园回来，心情还不错，准备整理一下java线程的实现方式（虽然我已经没有以前那么信仰java了），主要还是为了读区块链的java源码做知识准备。Java多线程实现方式主要有三种：继承Thread类、实现Runnable接口、使用ExecutorService、Callable、Future实现有返回结果的多线程。其中前两种方式线程执行完后都没有返回值，只有最后一种是带返回值的。
<img src="https://rjgeek.github.io/images/2016/12/thread_1.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  
<!--more-->

## 继承Thread类
启动线程的唯一方法就是通过Thread类的start()实例方法。start()方法是一个native方法，它将启动一个新线程，并执行run()方法。这种方式实现多线程很简单，通过自己的类直接extend Thread，并复写run()方法，就可以启动新线程并执行自己定义的run()方法。例如：
```
public class MyThread extends Thread {  
　　public void run() {  
　　 System.out.println("MyThread.run()");  
　　}  
} 
public static void main(String[] args){
    MyThread myThread1 = new MyThread();  
    MyThread myThread2 = new MyThread();  
    myThread1.start();  
    myThread2.start();  
}
```
Thread本质上也是实现了Runnable接口的一个实例，每次看到下面的写法就一脸懵逼，为什么已经是线程了里面还有传一个Runnable，其实Thread本身是不干活的，说白了他也实现了Runnable
```
	new Thread(new Runnable() {
			@Override
			public void run() {
				
				System.out.println("test");
			}
		});
```
分析下面的Thread的源码
```
public Thread(Runnable target) {
   init(null, target, "Thread-" + nextThreadNum(), 0);
}
public void run() {  
    if (target != null) {  
        target.run();  
    }  
} 
```
a. 如果子类覆盖了run()方法，则调用子类的run()   
b. 如果a不成立：   
   b1. 指定了target，则调用target的run()   
   b2. 没有指定target，该方法不做任何事并返回   

## 实现Runnable接口方式
实现一个Runnable接口好处是自身类的属性不受污染，因为java的单继承的原因，一旦继承了Thread，你将丧失集成其他类的能力,从面向对象的角度讲，实现Runnable接口更具有优越性
```
public class MyThread extends OtherClass implements Runnable {  
　　public void run() {  
　　 System.out.println("MyThread.run()");  
　　}  
} 
public static void main(String[] args){
    MyThread myThread = new MyThread();  
    Thread thread = new Thread(myThread);  
    thread.start();  
}
```
## 使用Executor框架
下面代码中Executors类，提供了一系列工厂方法用于创先线程池，返回的线程池都实现了ExecutorService接口。
public static ExecutorService newFixedThreadPool(int nThreads) 
创建固定数目线程的线程池。
public static ExecutorService newCachedThreadPool() 
创建一个可缓存的线程池，调用execute 将重用以前构造的线程（如果线程可用）。如果现有线程没有可用的，则创建一个新线程并添加到池中。终止并从缓存中移除那些已有 60 秒钟未被使用的线程。
public static ExecutorService newSingleThreadExecutor() 
创建一个单线程化的Executor。
public static ScheduledExecutorService newScheduledThreadPool(int corePoolSize) 
创建一个支持定时及周期性的任务执行的线程池，多数情况下可用来替代Timer类。
ExecutoreService提供了submit()方法，传递一个Callable，或Runnable，返回Future。如果Executor后台线程池还没有完成Callable的计算，这调用返回Future对象的get()方法，会阻塞直到计算完成。
此部分代码版权归wb_qiuquan.ying所有
```
public class Test {
public static void main(String[] args) throws ExecutionException,
    InterruptedException {
   System.out.println("----程序开始运行----");
   Date date1 = new Date();
   int taskSize = 5;
   // 创建一个线程池
   ExecutorService pool = Executors.newFixedThreadPool(taskSize);
   // 创建多个有返回值的任务
   List<Future> list = new ArrayList<Future>();
   for (int i = 0; i < taskSize; i++) {
    Callable c = new MyCallable(i + " ");
    // 执行任务并获取Future对象
    Future f = pool.submit(c);
    // System.out.println(">>>" + f.get().toString());
    list.add(f);
   }
   // 关闭线程池
   pool.shutdown();

   // 获取所有并发任务的运行结果
   for (Future f : list) {
    // 从Future对象上获取任务的返回值，并输出到控制台
    System.out.println(">>>" + f.get().toString());
   }

   Date date2 = new Date();
   System.out.println("----程序结束运行----，程序运行时间【"
     + (date2.getTime() - date1.getTime()) + "毫秒】");
}
}

class MyCallable implements Callable<Object> {
private String taskNum;

MyCallable(String taskNum) {
   this.taskNum = taskNum;
}

public Object call() throws Exception {
   System.out.println(">>>" + taskNum + "任务启动");
   Date dateTmp1 = new Date();
   Thread.sleep(1000);
   Date dateTmp2 = new Date();
   long time = dateTmp2.getTime() - dateTmp1.getTime();
   System.out.println(">>>" + taskNum + "任务终止");
   return taskNum + "任务返回运行结果,当前任务时间【" + time + "毫秒】";
}
}
```

## 总结
本文总结了线程的实现方式，源码位置：[点击这里](https://github.com/rjgeek/ExecutorService)
## 声明
本文80%为翻译组合,20%为原创
## 引用
http://blog.csdn.net/aboy123/article/details/38307539/