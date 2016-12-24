---
title: 【编程语言】Runtime.getRuntime().addShutdownHook（Thread hook）
tags:
  - 编程语言
id: 375
categories:
  - 编程语言
date: 2016-12-22 17:02:09
keywords: java,addShutdownHook，编程语言
---

## 引言
最近在研究比特流的源码，看到Runtime.getRuntime().addShutdownHook（Thread hook）时，发现全然不知所云，速查之，特总结如下。
<img src="https://rjgeek.github.io/images/2016/12/MerkleTree_0.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
<!--more-->


## 何时调用

The Java virtual machine shuts down in response to two kinds of events:

The program exits normally, when the last non-daemon thread exits or when the exit (equivalently, System.exit) method is invoked, orThe virtual machine is terminated in response to a user interrupt, such as typing ^C, or a system-wide event, such as user logoff or system shutdown.

Thus, a shutdown hook is a initialized and unstarted thread that gets executed<font color=#00ffff>  when a JVM shutdown occurs.</font>

## 示例代码

```
public class MainClass {
	  public static void main(String args[]){
	        Runtime.getRuntime().addShutdownHook(new Thread(new ShutDownHook()));
	        System.out.println("Shutdown hook registered");
	        System.out.println("Before calling exit");
	        System.exit(0);
	        System.out.println("After exit");        
	    }
	}
	 
	class ShutDownHook implements Runnable{
	 
	    public void run() {
	        System.out.println("Inside Shutdown hook");
	        System.out.println("Shutdown hook thread sleeping for 2 seconds");
	        try {
	            Thread.sleep(2000);
	        } catch (InterruptedException e) {
	            e.printStackTrace();
	        }
	        System.out.println("Shutdown hook thread waking up");
	        System.out.println("Shutdown hook thread terminating");
	    }
}
```
代码输出：  

Shutdown hook registered  
Before calling exit  
Inside Shutdown hook  
Shutdown hook thread sleeping for 2 seconds  
Shutdown hook thread waking up  
Shutdown hook thread terminating  


```
public class MainClass {
	public static void main(String[] args) throws Exception {
	    Object f = new Object() {
	      public void finalize() {
	        System.out.println("Running finalize()");
	      }
	    };
	    Runtime.getRuntime().addShutdownHook(new Thread() {
	      public void run() {
	        System.out.println("Running Shutdown Hook");
	      }
	    });

	    f = null;
	    System.gc();

	    System.out.println("Calling System.exit()");
	    System.exit(0);
	  }
}
```

代码输出：  
Calling System.exit()  
Running finalize()  
Running Shutdown Hook  

总结：总是在虚拟机关闭之前调用

## 使用场景

- your program had created many temporary files in filesystem you want to delete it; 
- you need to send a distress signal to another process/machine before terminating;
- execute any clean-up actions, logging or after-error actions on unexpected behaviours.

## 声明
本文70%为翻译组合,30%为原创
## 引用
http://stackoverflow.com/questions/8722826/when-do-i-need-to-call-this-method-runtime-getruntime-addshutdownhook





