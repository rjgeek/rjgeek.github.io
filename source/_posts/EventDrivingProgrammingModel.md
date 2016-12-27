---
title: 【编程语言】事件模型驱动编程
tags:
  - 编程语言
  - 事件驱动
id: 375
categories:
  - 编程语言
date: 2016-12-27 13:17:09
keywords: 设计原则，编程语言
---

## 引言
事件驱动模型与普通的编程模式的不同主要体现在数据的流向上，普通的编程模式是A调用B，B调用C,在此过程中一直是单项流向，而且C发挥着被调用的角色，事件驱动编程着力改变这一现状，C中去含有A，B，然后将自身传入到A，B中，然后在适当是时候在回调C的其他方法，在作者看来其实和上篇的文章的观察者模式么有什么差别，下面通过一个例子来说明  
<img src="https://rjgeek.github.io/images/2016/12/EventModel_1.jpg?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
事件驱动编程在java中包含了3类对象：数据源，监听者，事件
<!--more-->
为了更好的解释事件驱动模型的例子，文中借鉴了计算机大牛Lộc Nguyễn的代码，地址详见引用。
## Example
Now, we are modeling a simple car object, which can fire a SpeedEvent. The listener is SpeedListener interface. Max speed is temporarily set to 60MPH, min speed 40, and the default 50 when the car starts driving on the highway.
<font color=#00ffff>
如果没有事件对象这个传递者，其实这就是一个简化版的观察者模式的编程应用
</font>

```
public class SpeedEvent{
	private static final long serialVersionUID = 1L;
	private int maxSpeed;
	private int minSpeed;
	private int currentSpeed;
	
	public SpeedEvent(int maxSpeed,int minSpeed,int currentSpeed) {
		this.maxSpeed = maxSpeed;
		this.minSpeed = minSpeed;
		this.currentSpeed = currentSpeed;
	}

	public int getMaxSpeed() {
		return maxSpeed;
	}

	public void setMaxSpeed(int maxSpeed) {
		this.maxSpeed = maxSpeed;
	}

	public int getMinSpeed() {
		return minSpeed;
	}

	public void setMinSpeed(int minSpeed) {
		this.minSpeed = minSpeed;
	}

	public int getCurrentSpeed() {
		return currentSpeed;
	}

	public void setCurrentSpeed(int currentSpeed) {
		this.currentSpeed = currentSpeed;
	}	
}

```
Corresponding SpeedListener declares 2 handlers:

<font color=#00ffff>
这不就是观察者模式中的那个观察者角色的抽象么。
</font>

```
public interface SpeedListener{
	public void speedExceeded(SpeedEvent e);
	public void speedGoneBelow(SpeedEvent e);
}
```

Come back to the Car, it maintains a list of SpeedListeners:

<font color=#00ffff>
这个Car作为事件源，是不是和我们之前的被观察者特别相似，区别在于这是一个没有进一步抽象，而是直接作用于监听者，例如下面的例子，当汽车加速时候去通知循环通知所有的listener，然后listener根据做出相应的hander事件，从观察者的模式看其实就是通知各个观察者，然后进行update操作
</font>

This **processSpeedEvent(SpeedEvent e) method** is to be executed when the SpeedEvent is fired. It calls each handler of each SpeedListener object in the speedListenerList, to notify and do something about that event.

```
public class Car {

	private int maxSpeed;
	private int minSpeed;
	private int currentSpeed;
	
	ArrayList<SpeedListener> speedListenerList = new ArrayList<SpeedListener>();
	
	// Register an event listener
    public synchronized void addSpeedListener(SpeedListener listener) {
        if (!speedListenerList.contains(listener)) {
            speedListenerList.add(listener);
        }
    }

	public Car(int maxSpeed, int minSpeed, int currentSpeed) {
		super();
		this.maxSpeed = maxSpeed;
		this.minSpeed = minSpeed;
		this.currentSpeed = currentSpeed;
	}
	
    public void speedUp(int increment) {
        this.currentSpeed += increment;
        if (this.currentSpeed > this.maxSpeed) {
            // fire SpeedEvent
            // processSpeedEvent(new SpeedEvent(this, this.maxSpeed, this.minSpeed, this.currentSpeed));
            // When SpeedEvent does not extend java.util.EventObject
            processSpeedEvent(new SpeedEvent(this.maxSpeed, this.minSpeed, this.currentSpeed));
        }
    }

    public void slowDown(int increment) {
        this.currentSpeed -= increment;
        if (this.currentSpeed < this.minSpeed) {
            // fire SpeedEvent
            // processSpeedEvent(new SpeedEvent(this, this.maxSpeed, this.minSpeed, this.currentSpeed));
            // When SpeedEvent does not extend java.util.EventObject
            processSpeedEvent(new SpeedEvent(this.maxSpeed, this.minSpeed, this.currentSpeed));
        }
    }
	private void processSpeedEvent(SpeedEvent speedEvent) {
		ArrayList<SpeedListener> tempSpeedListenerList;

        synchronized (this) {
            if (speedListenerList.size() == 0) {
                return;
            }
            tempSpeedListenerList = (ArrayList<SpeedListener>) speedListenerList.clone();
        }

        for (SpeedListener listener : tempSpeedListenerList) {
            listener.speedExceeded(speedEvent);
            listener.speedGoneBelow(speedEvent);
        }
    }
}

```

That we has created and fired the event, and delegated to the listener to process the event. It's up to the client code to implement the concrete **handler(s)**.Here we have two handers with differnt implementation.

Hander one:

```
public class MySpeedListener implements SpeedListener{

	 @Override
     public void speedExceeded(SpeedEvent e) {
         if (e.getCurrentSpeed() > e.getMaxSpeed()) {
             System.out.println("Alert! You have exceeded " + (e.getCurrentSpeed() - e.getMaxSpeed() + " MPH!"));
         }
     }

     @Override
     public void speedGoneBelow(SpeedEvent e) {
         if (e.getCurrentSpeed() < e.getMinSpeed()) {
             System.out.println("Uhm... you are driving " + e.getCurrentSpeed() + " MPH. Speed up!");
         }
     }
}
```
Hander two:
```
public class MySpeedListener1 implements SpeedListener{
	 @Override
     public void speedExceeded(SpeedEvent e) {
         if (e.getCurrentSpeed() > e.getMaxSpeed()) {
             System.out.println("警告! 您已经超过 " + (e.getCurrentSpeed() - e.getMaxSpeed() + " 公里/小时"));
         }
     }

     @Override
     public void speedGoneBelow(SpeedEvent e) {
         if (e.getCurrentSpeed() < e.getMinSpeed()) {
             System.out.println("您现在的时速是 " + e.getCurrentSpeed() + " 公里没小时. 请提速");
         }
     }
}
```

Write a test case: 
```
public class Test {
	 public static void main(String[] args) {
	        Car myCar = new Car(60, 40, 50);

	        SpeedListener listener = new MySpeedListener();
	        SpeedListener listener1 = new MySpeedListener1();
	        myCar.addSpeedListener(listener);
	        myCar.addSpeedListener(listener1);
	        // Add more listeners if you want

	        myCar.speedUp(50); // fires SpeedEvent
	        myCar.speedUp(50); // fires SpeedEvent
	        myCar.slowDown(70);
	        myCar.slowDown(70); // fires SpeedEvent
	    }

}
```
Result output will be:  
Alert! You have exceeded 40 MPH!  
警告! 您已经超过 40 公里/小时  
Alert! You have exceeded 90 MPH!  
警告! 您已经超过 90 公里/小时  
Uhm... you are driving 10 MPH. Speed up!  
您现在的时速是 10 公里没小时. 请提速  

## 总结
本文总结了java的事件驱动编程模型，抛去事件本身，其实就是一个观察者模型的应用，最后，源码地址：[点击这里](https://github.com/rjgeek/javaPatternStudy)
## 声明
本文50%为翻译组合,50%为原创
## 引用
https://www.codeproject.com/articles/677591/defining-custom-source-event-listener-in-java