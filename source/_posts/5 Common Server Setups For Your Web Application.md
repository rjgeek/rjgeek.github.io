---
title: 【系统架构】五种通用WEB应用服务器（5 Common Server Setups For Your Web Application）
id: 813
categories:
  - 系统架构
date: 2016-11-25 18:05:54
tags:
---

## 简介（Introduction）
When deciding which server architecture to use for your environment, there are many factors to consider, such as performance, scalability, availability, reliability, cost, and ease of management.  
Here is a list of commonly used server setups, with a short description of each, including pros and cons. Keep in mind that all of the concepts covered here can be used in various combinations with one another, and that every environment has different requirements, so there is no single, correct configuration.    
<img src="https://rjgeek.github.io/images/2016/11/5_Common_Server_Setups_Twitter-01.png?t=2>" width = "90%" height = "90%" alt="图片名称" align=center /> 
<!--more-->

在决定为您的环境使用哪种服务器体系结构时，需要考虑很多因素，如性能，可扩展性，可用性，可靠性，成本和易于管理。  
这里是常用的服务器设置列表，每个都有简短的描述，包括利弊。 请记住，此处涵盖的所有概念可以彼此不同的组合使用，并且每个环境都有不同的要求，因此没有单一，正确的配置。
## 所有东西都放在一个服务器上（Everything On One Server）
The entire environment resides on a single server. For a typical web application, that would include the web server, application server, and database server. A common variation of this setup is a LAMP stack, which stands for Linux, Apache, MySQL, and PHP, on a single server.  

**Use Case:** Good for setting up an application quickly, as it is the simplest setup possible, but it offers little in the way of scalability and component isolation.  

**Pros:**Simple  

**Cons:**  
1.Application and database contend for the same server resources (CPU, Memory, I/O, etc.) which, aside from possible poor performance, can make it difficult to determine the source (application or database) of poor performance  
2.Not readily horizontally scalable  
整个环境驻留在单个服务器上。 典型的Web应用程序将包括Web服务器，应用程序服务器和数据库服务器。 这种设置的一个常见变体是LAMP堆栈，它的代表Linux，Apache，MySQL和PHP，部署在单个服务器上。    
**使用案例：**适合快速设置应用程序，因为它是可能的最简单的设置，但它不提供可扩展性和组件隔离的方式。 
<img src="https://rjgeek.github.io/images/2016/11/5_single_server.png?t=2>" width = "90%" height = "90%" alt="图片名称" align=center />  
**优点：**简单  
**缺点：**  
1.应用程序和数据库争用相同的服务器资源（CPU，内存，I / O等），除了可能的性能低下外，你也很难确定到底是谁的性能问题
2.不容易水平扩展  
## 数据服务器分离（Separate Database Server）
The database management system (DBMS) can be separated from the rest of the environment to eliminate the resource contention between the application and the database, and to increase security by removing the database from the DMZ, or public internet.    

**Use Case:** Good for setting up an application quickly, but keeps application and database from fighting over the same system resources.

**Pros:**  
1.Application and database tiers do not contend for the same server resources (CPU, Memory, I/O, etc.)
You may vertically scale each tier separately, by adding more resources to whichever server needs increased capacity  
2.Depending on your setup, it may increase security by removing your database from the DMZ  

**Cons:**
1.Slightly more complex setup than single server
2.Performance issues can arise if the network connection between the two servers is high-latency (i.e. the servers are geographically distant from each other), or the bandwidth is too low for the amount of data being transferred  

数据库管理系统（DBMS）可以与环境的其余部分分离，以消除应用程序和数据库之间的资源争用，并且通过从DMZ或公共因特网移除数据库来增加安全性。  
**使用案例：**适合快速设置应用程序，避免了应用程序和数据库在同一系统资源上的战斗。  
<img src="https://rjgeek.github.io/images/2016/11/5_separate_database.png?t=2>" width = "90%" height = "90%" alt="图片名称" align=center />  
**优点：**
1.应用程序和数据库层不竞争相同的服务器资源（CPU，内存，I / O等）,您可以通过向任何服务器需要增加的容量添加更多资源来单独垂直扩展每个层  
2.根据您的设置，它可以通过从DMZ中删除数据库来提高安全性  
**缺点：**
1.比单服务器设置更复杂  
2.如果两个服务器之间的网络连接是高延迟（即，服务器在地理上彼此远离），或者带宽对于传送的数据量太低，则可能出现性能问题    
## 负载均衡（Load Balancer-Reverse Proxy）
Load balancers can be added to a server environment to improve performance and reliability by distributing the workload across multiple servers. If one of the servers that is load balanced fails, the other servers will handle the incoming traffic until the failed server becomes healthy again. It can also be used to serve multiple applications through the same domain and port, by using a layer 7 (application layer) reverse proxy.
Examples of software capable of reverse proxy load balancing: HAProxy, Nginx, and Varnish.

**Use Case:** Useful in an environment that requires scaling by adding more servers, also known as horizontal scaling.   

**Pros:**  
1.Enables horizontal scaling, i.e. environment capacity can be scaled by adding more servers to it  
2.Can protect against DDOS attacks by limiting client connections to a sensible amount and frequency  

**Cons:**  
1.The load balancer can become a performance bottleneck if it does not have enough resources, or if it is configured poorly  
2.Can introduce complexities that require additional consideration, such as where to perform SSL termination and how to handle applications that require sticky sessions  
3.The load balancer is a single point of failure; if it goes down, your whole service can go down. A high availability (HA) setup is an infrastructure without a single point of failure. To learn how to implement an HA setup, you can read this section of How To Use Floating IPs.  

负载平衡器可以添加到服务器环境中，以通过在多个服务器之间分配工作负载来提高性能和可靠性。如果其中一个负载平衡的服务器失败，其他服务器将处理传入流量，直到失败的服务器再次变得健康。它还可以用于通过使用第7层（应用层）反向代理通过相同的域和端口服务多个应用。能够进行逆向代理负载平衡的软件示例：HAProxy，Nginx和Varnish。  
**用例：**在需要通过添加更多服务器进行扩展的环境中有用，也称为水平缩放。
<img src="https://rjgeek.github.io/images/2016/11/5_load_balancer.png?t=2>" width = "90%" height = "90%" alt="图片名称" align=center />  
**优点：**
1.启用水平扩展，即可通过向其中添加更多服务器来扩展环境容量
2.通过将客户端连接限制在明显的数量和频率，可防止DDOS攻击  
**缺点：**  
1.如果负载均衡器没有足够的资源或者配置不当，它可能会成为性能瓶颈  
2.可能引入需要额外考虑的复杂性，例如在何处执行SSL终止以及如何处理需要粘性会话的应用程序  
3.负载均衡器是单点故障;如果它下降，你的整个服务可以下降。高可用性（HA）设置是没有单点故障的基础设施。要了解如何实施HA设置，您可以阅读如何使用浮动IP的此部分。  
## HTTP Accelerator (Caching Reverse Proxy)
An HTTP accelerator, or caching HTTP reverse proxy, can be used to reduce the time it takes to serve content to a user through a variety of techniques. The main technique employed with an HTTP accelerator is caching responses from a web or application server in memory, so future requests for the same content can be served quickly, with less unnecessary interaction with the web or application servers.

Examples of software capable of HTTP acceleration: Varnish, Squid, Nginx.

**Use Case:** Useful in an environment with content-heavy dynamic web applications, or with many commonly accessed files.    
**Pros:**  
1.Increase site performance by reducing CPU load on web server, through caching and compression, thereby increasing user capacity  
2.Can be used as a reverse proxy load balancer  
3.Some caching software can protect against DDOS attacks    
**Cons:**  
1.Requires tuning to get best performance out of it  
2.If the cache-hit rate is low, it could reduce performance  

HTTP加速器或缓存HTTP反向代理可用于减少通过各种技术向用户提供内容所需的时间。 HTTP加速器采用的主要技术是缓存来自内存中的Web或应用程序服务器的响应，因此可以快速提供对相同内容的未来请求，同时减少与Web或应用程序服务器之间的不必要的交互。  

能够进行HTTP加速的软件示例：Varnish，Squid，Nginx。  
<img src="https://rjgeek.github.io/images/2016/11/5_load_balancer.png?t=2>" width = "90%" height = "90%" alt="图片名称" align=center />  
**用例：**适用于内容繁多的动态Web应用程序或许多常用文件的环境。  
**优点：**  
1.通过减少Web服务器上的CPU负载，通过缓存和压缩来提高站点性能，从而提高用户容量  
可用作逆向代理负载均衡器  
2.一些缓存软件可以防止DDOS攻击  
**缺点：**  
1.需要调整以获得最佳性能  
2.如果缓存命中率低，则可能降低性能  

## 主备互用，读写分离（Master-Slave Database Replication）
One way to improve performance of a database system that performs many reads compared to writes, such as a CMS, is to use master-slave database replication. Master-slave replication requires a master and one or more slave nodes. In this setup, all updates are sent to the master node and reads can be distributed across all nodes.

**Use Case:** Good for increasing the read performance for the database tier of an application.

Here is an example of a master-slave replication setup, with a single slave node:

**Pros:**
1.Improves database read performance by spreading reads across slaves  
2.Can improve write performance by using master exclusively for updates (it spends no time serving read requests)   
**Cons:**  
1.The application accessing the database must have a mechanism to determine which database nodes it should send update and read requests to
2.Updates to slaves are asynchronous, so there is a chance that their contents could be out of date  
3.If the master fails, no updates can be performed on the database until the issue is corrected  
4.Does not have built-in failover in case of failure of master node  

与写操作（例如CMS）相比，提高执行许多读取操作的数据库系统性能的一种方法是使用主从数据库复制。主从复制需要主节点和一个或多个从节点。在此设置中，所有更新都发送到主节点，读取可以分布在所有节点上。

**用例：**适用于提高应用程序的数据库层的读取性能。

以下是具有单个从节点的主从复制设置的示例：
<img src="https://rjgeek.github.io/images/2016/11/5_master_slave_database_replication.png?t=2>" width = "90%" height = "90%" alt="图片名称" align=center />  
**优点：**
1.通过在从机之间传播读，提高数据库读性能
2.可以通过使用专用于更新的主机来提高写入性能（它不需要时间提供读取请求）
**缺点：**
1.访问数据库的应用程序必须有一个机制来确定它应该向其发送更新和读取请求的数据库节点
2.更新到从属设备是异步的，因此有可能它们的内容可能已过期
3.如果主服务器失败，则无法对数据库执行更新，直到问题得到纠正
4.在主节点故障的情况下没有内置故障转移

## 综合用法（Combining the Concepts）
It is possible to load balance the caching servers, in addition to the application servers, and use database replication in a single environment. The purpose of combining these techniques is to reap the benefits of each without introducing too many issues or complexity. Here is an example diagram of what a server environment could look like:  

Let's assume that the load balancer is configured to recognize static requests (like images, css, javascript, etc.) and send those requests directly to the caching servers, and send other requests to the application servers.

Here is a description of what would happen when a user sends a requests dynamic content:  

The user requests dynamic content from http://example.com/ (load balancer)  
The load balancer sends request to app-backend  
app-backend reads from the database and returns requested content to load balancer  
The load balancer returns requested data to the user  
If the user requests static content:  

The load balancer checks cache-backend to see if the requested content is cached (cache-hit) or not (cache-miss)  
If cache-hit: return the requested content to the load balancer and jump to Step 7. If cache-miss: the cache server forwards the request to app-backend, through the load balancer  
The load balancer forwards the request through to app-backend  
app-backend reads from the database then returns requested content to the load balancer  
The load balancer forwards the response to cache-backend  
cache-backend caches the content then returns it to the load balancer  
The load balancer returns requested data to the user  
This environment still has two single points of failure (load balancer and master database server), but it provides the all of the other reliability and performance benefits that were described in each section above.

除了应用程序服务器之外，还可以对缓存服务器进行负载平衡，并在单个环境中使用数据库复制。组合这些技术的目的是获得每个技术的益处而不引入太多的问题或复杂性。以下是服务器环境可能类似的示例图：
<img src="https://rjgeek.github.io/images/2016/11/5_combined.png?t=2>" width = "90%" height = "90%" alt="图片名称" align=center />  
让我们假设负载均衡器被配置为识别静态请求（如图像，css，javascript等），并将这些请求直接发送到缓存服务器，并向应用服务器发送其他请求。

以下是用户发送请求动态内容时会发生什么的说明：

用户从http://example.com/（负载平衡器）请求动态内容，
负载均衡器向app-backend发送请求
app-backend从数据库读取并将请求的内容返回到负载平衡器
负载平衡器将请求的数据返回给用户
如果用户请求静态内容：

负载平衡器检查缓存后端以查看请求的内容是否被缓存（缓存命中）或不缓存（缓存未命中）
如果cache-hit：将请求的内容返回到负载均衡器并跳转到步骤7.如果cache-miss：缓存服务器通过负载均衡器将请求转发到app-backend
负载平衡器将请求转发到应用后端
应用程序后端读取从数据库然后返回请求的内容到负载平衡器
负载平衡器将响应转发到缓存后端
缓存后端缓存内容，然后将其返回到负载均衡器
负载平衡器将请求的数据返回给用户
此环境仍然有两个单点故障（负载平衡器和主数据库服务器），但它提供了上面每个部分中描述的所有其他可靠性和性能优势。
## 结论（Conclusion）

Now that you are familiar with some basic server setups, you should have a good idea of what kind of setup you would use for your own application(s). If you are working on improving your own environment, remember that an iterative process is best to avoid introducing too many complexities too quickly.  

Let us know of any setups you recommend or would like to learn more about in the comments below!  

By Mitchell Anicas  

现在你已经熟悉了一些基本的服务器设置，你应该明白你将在你自己的应用程序中使用什么样的设置。 如果你正在努力改善你自己的环境，记住一个迭代的过程是最好避免太快地引入太多的复杂性。  

让我们知道您推荐的任何设置，或者想在下面的评论中了解更多信息！

作者：Mitchell Anicas

## 声明
本文100%为组合翻译，详见引用,0%为原创
## 引用
https://www.digitalocean.com/community/tutorials/5-common-server-setups-for-your-web-application


















