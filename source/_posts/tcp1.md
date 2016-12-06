---
title: 【编程语言】聊聊网络传输层 Version 0.1
id: 813
categories:
  - 网络知识
date: 2016-11-12 18:05:54
tags:
---
## 声明
本文70%为组合翻译，详见最后引用，30%为原创内容
定版为version1.0,目前为 Version 0.1 表示正在撰写或者翻译
## 传输层（Transport layer） vs 网络层(network layer)
network layer: logical communication between hosts  
**网络层：主机之间的逻辑通信  **  
transport layer: logical communication between processes–relies on, enhances, network layer services  
**传输层:是主机之间的进程通信，是用来加强网络层的**  
<img src="https://rjgeek.github.io/images/2016/11/transport_layer_1.png?t=2>" width = "400" height = "300" alt="图片名称" align=center />  
<!--more-->
transport protocols run in end systems 		
&nbsp;&nbsp;&nbsp;&nbsp;–send side: breaks app messages into segments, passes to  network layer		
&nbsp;&nbsp;&nbsp;&nbsp;–rcv side: reassembles segments into messages, passes to app layer		
**传输层工作在系统末端，发送消息时传输的报文拆分成小的片段然后发给网络层，接收消息时将报文组装应用层**

### 传输层的协议（Internet transport-layer protocols）
reliable,in-order delivery(TCP)  
&nbsp;&nbsp;&nbsp;&nbsp;–congestion control  
&nbsp;&nbsp;&nbsp;&nbsp;–flow control  
&nbsp;&nbsp;&nbsp;&nbsp;–connetion setup  
**可信的有序的TCP协议，提供拥塞控制，流量控制等功能**  
unreliable,unordered delivery(UDP)  
**不可信的无序的UDP协议**  

### 复用和解复用（ Multiplexing and Demultiplexing）

Multiplexing is the process in which multiple Data Streams, coming from different Sources, are combined and Transmitted over a Single Data Channel or Data Stream.  
**并发传输是将多个数据流，从不同来源，合并和传播在一个单一的数据通道或数据流的过程。**
In Electronic Communications, the two basic forms of Multiplexing are Time Division Multiplexing (TDM) and Frequency Division Multiplexing (FDM).  
**在电子通信中，复用的两种基本形式是时分复用（TDM）和频分复用（FDM）。**
In Time Division Multiplexing, Transmission Time on a Single Channel is divided into non-overlapped Time Slots. Data Streams from different Sources are divided into Units with same size and interleaved successively into the Time Slots.  
**在时分复用，在一个通道传输时间被分为非重叠时隙。不同来源的数据流被分成大小相同的单位，先后交错成时隙。**  
In Frequency Division Multiplexing, Data Streams are carried simultaneously on the same Transmission medium by allocating to each of them a different Frequency Band within the Bandwidth of the Single Channel.  
**在频分复用，数据流同时相同的传输介质上的单信道的带宽内分配给他们每个人不同的频段进行。**    
Multiplexing is done by an equipment called Multiplexer (MUX). It is placed at the Transmitting End of the communication link. At the Receiving End, the Composite Signal is separated by an equipment called Demultiplexer (DEMUX). Demultiplexer performs the reverse process of Multiplexing and routes the separated signals to their corresponding Receivers or Destinations.  
**多路复用是通过称为多路复用器（MUX）的设备完成的。它被放置在通信链路的发送端。在接收端，复合信号是由称为解复用器（DEMUX）的设备分离。多路分解器执行复用和路由的分离的信号的逆过程到其对应的接收器或目的地。**    
Figure 1 shows how TDM interleaves small Units of each Data Stream into the corresponding Time Slots. It Transmits the Data Streams from three Signal Sources (Red, Green and Blue) simultaneously by combining them into a Single Data Stream.  
**图1显示了TDM如何交织每个数据流的小单位到相应的时隙。它通过将它们合并为单个数据流传输数据流从三个信号源（红，绿，蓝）同时进行。**  
<img src="https://rjgeek.github.io/images/2016/11/transport_layer_2.png" width = "350" height = "280" alt="图片名称" align=center /> 

## 解复用是如何工作的 How demultiplexing works
### 发送和接收
delivering	received segments to correct socket    
**发送：从多个套接字收集数据，用传输层首部封装数据(以后用于分解 )  **  
Multiplexing at send host    
**接收：将接收的段交付给正确的套接字，(利用传输层首部信息进行分解)**  
host receive IP datagrams,each datagrams hava source IP address,destination address,Each datagrams carreies transport-layer segment,each segment have source destination port number,host use IP address and port to appropriate socket
**实际上，复用与分解是针对多个SOCKET与一个网络层通道的关系**  
<img src="https://rjgeek.github.io/images/2016/11/transport_layer_3.png" width = "300" height = "280" alt="图片名称" align=center /> 
### 面向连接的分解（connection-oriented demux）
TCP socket identified by 4-tuple:  
&nbsp;&nbsp;&nbsp;&nbsp;–source IP address  
&nbsp;&nbsp;&nbsp;&nbsp;–source port address  
&nbsp;&nbsp;&nbsp;&nbsp;–dest IP address  
&nbsp;&nbsp;&nbsp;&nbsp;–dest port address  
demux: receiver uses all four values to direct segment to approprite socket  
**接收主机使用这四个值将段定位到对应的套接字(也就对应了特定应用程序)  **    
<img src="https://rjgeek.github.io/images/2016/11/transport_layer_4.png" width = "420" height = "350" alt="图片名称" align=center />   
server host may support many simultaneous TCP socket,web servers have different sockets for each connecting client,non-persistent HTTP will have different socket for each resquest  
**服务器可以同时支持很多个TCP套接字同时工作，对于非持续连接的HTTP的请求，每次都要建立一个请求套接字**
<img src="https://rjgeek.github.io/images/2016/11/transport_layer_5.png" width = "420" height = "350" alt="图片名称" align=center />   

### 无连接分解(Connectionless demultiplexing)
Create socket with port numbers:
DatagarmSocket mysocket = new DatagarmSocket(11111);
UDP socket identified by two tuple:
&nbsp;&nbsp;&nbsp;&nbsp;–dest IP address  
&nbsp;&nbsp;&nbsp;&nbsp;–dest port address  
when host receives UDP segment,checks destination in segement.directs UDP segment to socket with that port number,IP datagrams with different source IP addresses and/or source port numbers can be directed to same socket  
**一个应用程序可以有多个套接字,一个套接字只能属于一个应用程序**  
**无连接的分解只考虑目的IP和目的地址，如果目的IP和地址相同，他们可以被分配到相同的套接字**  
<img src="https://rjgeek.github.io/images/2016/11/transport_layer_6.png" width = "420" height = "350" alt="图片名称" align=center />  
## UDP: User Datagram Protocol [RFC 768]
“best effort” service, UDP segments may be “尽力而为”服务，UDP段可能：  
&nbsp;&nbsp;&nbsp;&nbsp;– lost 丢包   
&nbsp;&nbsp;&nbsp;&nbsp;– delivered out-of-order to app 交付给应用程序的报文可能失序  
connectionless: 无连接:  
&nbsp;&nbsp;&nbsp;&nbsp;– no handshaking between UDP sender, receiver   在UDP发送方和接收方之间无握手  
&nbsp;&nbsp;&nbsp;&nbsp;– – each UDP segment handled independently of others每个UDP段的处理独立于其他段，无状态传递  
**UDP应用场景，对数据丢失不敏感的流式数据（视屏，音频），DNS，SNMP**

### UDP头格式化 （UDP segment header）
<img src="https://rjgeek.github.io/images/2016/11/transport_layer_7.png" width = "320" height = "300" alt="图片名称" align=center />  
其中length为UDP数据和头的长度
### UDP校验和 （UDP checksum）
Goal:detect "errors" in transmitted segment
sender:  
**目标：监听传输过程中的错误 **
The checksum field is the 16 bit one's complement of the one's complement sum of all 16-bit words in the header and text.If a segment contains an odd number of header and text octets to be checksummed, the last octet is padded on the right with zeros to form a 16-bit word for checksum purposes. The pad is not transmitted as part of the segment. While computing the checksum, the checksum field itself is replaced with zeros.

Header Checksum区域有16位。它是这样获得的，从header取得除checksum之外的0/1序列，比如：  
9194 8073 0000 4000 4011 C0A8 0001 C0A8 00C7 (十六进制hex, 这是一个为演示运算过程而设计的header)  
按照十六位(也就是4位hex)分割整个序列。将分割后的各个4位hex累积相加。如果有超过16位的进位出现，则将进位加到后16位结果的最后一位：

  Binary                Hex

  1001000110010100      9194

 +1000000001110011      8073

  ----------------

1 0001001000000111     11207

                 1

  ----------------
  0001001000001000      1208  
上面的计算叫做one's complement sum。求得所有十六位数的和，
one's complement sum(4500, 0073, 0000, 4000, 4011, C0A8, 0001, C0A8, 00C7) = 1433
然后，将1433的每一位取反(0->1, 1->0)， 就得到checksum：EBCC
这样，我们的header就是:
9194 8073 0000 4000 4011 EBCC C0A8 0001 C0A8 00C7
IP包的接收方在接收到IP包之后，可以求上面各个16位数的one's complement sum，应该得到FFFF。如果不是FFFF，那么header是不正确的，整个IP包会被丢弃。  
Here is Checksum calculation for a very small UDP user datagram with only 7 bytes of data. Because the number of bytes of data is odd, padding is added for checksum calculation.  
The pseudo header as well as the padding will be dropped when the user datagram is delivered to IP layer.
<img src="https://rjgeek.github.io/images/2016/11/transport_layer_8.png?" width = "500" height = "280" alt="图片名称" align=center />  

## 构造可靠的数据传输协议
### 完全可靠信道上的可靠数据传输(rdt1.0)
最简单的情况，假设底层的信道是完全可靠的，
所有分组从发送方流向接收方，有了完全可靠的信道，接收方不需要提供任何反馈消息给发送方，因为不会发生任何差错
### 完全可靠信道上的可靠数据传输(rdt2.0)
在现实中，在实际传输中有些比特可能会受损或者丢失，接了解决这个问题采用，服务应答机制
接收肯定确认（positive acknowledgment），否定确认(negative acknowledgment)，自动重传请求(Automatic Repeat Request ARQ)
ARQ协议提供了三种协议来处理比特差错，1差错检测，2接收方反馈，3重传  
rdt2.0 看着似乎可是运行了，但是有个致命的缺陷，没有考虑到ACK或者NAK的分组受损的情况，
rdt2.1  
为了解决ACK或者NAK丢失的问题，有三种方案可以考虑，  
第一种：重发ACK或者NAK，但是同样面临含糊丢失的问题  
第二种：增加足够的检测和比特，可以直接恢复比特差错
第三种：收到含糊不清的ACK，重发整个分组，但是会产生冗余分组（duplicate packet）的问题，解决此类问题的方法是在数据分组中添加一个新字段，即将发送的数据分组的序号放入字段中，接收方可以检测序号（sequence number）判断是否为冗余分组  
rdt2.2  
如果分组报文接收不成功接收方不发送NAC，转而发送上一次正确接收的ACK
### 具有比特差错的丢包信道上的可靠数据传输(rdt3.0)
除了比特受损之外，底层信道还会丢包，假定让发送方负责检测和恢复丢包，发送方确定一个合适的时间值  
倒数定时器（countdown timer）  
1.每次发送一个分组，启动定时器  
2.响应定时器中断（采取合适的动作）  
3.终止定时器  

## 流水线可靠数据传输协议(Pipelined protocols)
模型：为了评估停等对性能的影响，可以考虑一种两台主机理想化的情况，一台位于美国位于美国东海岸，一台位于美国西海岸，两个系统光速往返传播时延（RTT）大约为30ms,假如彼此通过一条传输速率为R=1Gbps(10^9bps),包括首部字段和数据分组的长L=1000字节（8000比特），实际发送一个分组到1Gbps链路所需的时间是
$$\phi{n}=\frac{L}{R}=\frac{8000\quad bit/packet}{10^9\quad bit/s}=9us$$
如果发送方在t=0的时刻发送分组，在t=L/R=8us后，最后一个比特数据进入发送方信道，经过15ms的垮美国旅行后到达接收方，该分组的最后1比特在时刻t=RTT/2+L/R=15.008时到达接收方，接收方在收到最后一个分组的最后1个比特后立刻发动ACK，ACK在时刻t=RTT+L/R=30.008ms到达发送方，（假设ACK分组很小，我们忽略其发送时间），此时发送方可以发送下一个报文，因此在30.008ms内，发送方值发送了0.008ms
定义发送方信道的利用率：  
$$\phi{n}=\frac{L/R}{RTT+L/R}=\frac{0.008\quad ms}{30.008\quad ms}=0.000267us$$
发送方只有万分之2.67的时间是繁忙的，发送方在30.008ms内只发送了1000字节，有效的吞吐量为267kbps
为了解决这个问题引用新的方法：不使用停等协议，允许发送方发送多个分组，而且不用确认，下图的例子，在等待确认之前发送3个分组，利用率提高3倍，此种方式称为流水线，但是流水线对可靠数据传输协议带来的如下影响：  
1.每个传输分组必须有分组序号  
2.协议发发送方和接收方必须可以缓存多个分组，发送方最低限度是缓冲那些没有确认的分组  
3.所需的序号范围和对缓冲的要求取决于数据传输协议处理丢失、损坏以及过度延时分组的方式
解决流水线分的方式有两种：回退N部，选择重传，  
### 回退N部（Go-back-N）
Go-back-N简称GBN 
Go-back-N，sender can have up to N unacked packets in pipeline  
• receiver only sends cumulative ack doesn’t ack packet if there’s a gap  
• sender has timer for oldest unacked packet when timer expires, retransmit all unacked packets  
#### 滑动窗口协议（sliding-window protocol）
我么将最早的未确认的分组的序号定义为基序号(base)，下一个序号（nextsqnum）定义为最小的未使用的序号，可以将序号范围分为以下四部分，详见下图  
已经被发送，但是还么有收到确认的分组的许可范围可以被看成是一个在序号范围内长度为N的窗口，随着协议的运行，该窗口在序号空间内向前滑动，N被称为窗口长度，GBN协议被称为滑动窗口协议（slinding-window protocol）

GNB响应一下三种类型的事件  
1.上层的调用，上层调用rdt_send()时，发送方首先检查发送窗口是否已满，即是否有N个已经发送但是未被确认的分组，如果窗口未满，则创建一个分组将其发送，如果窗口已满，告诉上层一会重试，目前繁忙
2.收到ACK，采用累积确认的方式，如收到的序号为m,则m之前的序号已经完成发送
3.超时事件，收到下一组发送的ACK，但是上一组没有收到，则从上一组开始恢复

### 选择重传（Selective repeat）
GBN的问题，出现任何一个差错，其后的所有分组都将收到影响，为了解决这个问题引入了选择重传的功能  
发送：  
1.如果下一个可用的序号在窗口内，则发送包  
2.每个分组都拥有自己逻辑定时器，超时只发送当前这个分组
3.收到ACK，如果该分组在窗口内，在SR发送方将那个未被确认的分组标示为已经接收 ，如果该分组的序号等于send_base,则窗口基序号向前移动到最小序号的未确认分组处，如果窗口移动了并且有序号落在窗口内的未发送分组，则发送这些分组 
接收：
``` 
#include <stdio.h>
int main(){
	
    char a = 15;
	char *pa = &a;
	
    int b = 55;
	int *pb = &b;

    double c = 	11;
    double *pc = &c;
    
    printf("%#X,%#X,%#X\n" , pa, pb,pc);  
    printf("%d,%d,%d\n", *pa, *pb,c); 
    pa++;
    pb++;
    pc++;
    printf("%#X,%#X,%#X\n" , pa, pb,pc); 
    return 0;
}
```  

## 引用
http://macao.communications.museum/eng/exhibition/secondfloor/moreinfo/2_8_6_Multiplexing.html  
http://blog.chinaunix.net/uid-26758209-id-3146230.html  
《计算机网络-自顶向下方法(原书第4版)》  


















