---
title: 【编程语言】聊聊TCP协议 Version 0.1
id: 813
categories:
  - 网络知识
date: 2016-11-12 18:05:54
tags:
---
<script type="text/javascript" src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=default"></script>
## TCP的报文结构（TCP segment structure）
### basic structure
Having taken a brief look at the TCP connection, let’s examine the TCP segment
structure. The TCP segment consists of header fields and a data field. The data
field contains a chunk of application data. As mentioned above, the MSS limits the
maximum size of a segment’s data field. When TCP sends a large file, such as an
image as part of a Web page, it typically breaks the file into chunks of size MSS
(except for the last chunk, which will often be less than the MSS).   

Interactive applications,however, often transmit data chunks that are smaller than the MSS; 
for example, with remote login applications like Telnet, the data field in the TCP segment
is often only one byte. Because the TCP header is typically 20 bytes (12 bytes
more than the UDP header), segments sent by Telnet may be only 21 bytes in length.
Figure bellow shows the structure of the TCP segment.   
<img src="https://rjgeek.github.io/images/2016/11/tcp_1.png?t=2>" width = "70%" height = "300" alt="图片名称" align=center />  
<!--more-->
As with UDP, the header includes <font color=#0099ff size=4>source and destination port numbers </font> , which are used for multiplexing/demultiplexing data from/to upper-layer applications. Also, as with
UDP, the header includes  <font color=#0099ff size=4> a checksum field </font>. A TCP segment header also contains the following fields:  

- The 32-bit sequence number field and the 32-bit <font color=#0099ff size=4> acknowledgment number field </font>are used by the TCP sender and receiver in implementing a reliable data transfer service, as discussed below.

- The 16-bit receive<font color=#0099ff size=4>  window field </font>is used for flow control. We will see shortly that it is used to indicate the number of bytes that a receiver is willing to accept.

-  The 4-bit  <font color=#0099ff size=4> header length field </font>specifies the length of the TCP header in 32-bit words. The TCP header can be of variable length due to the TCP options field.

- The optional and <font color=#0099ff size=4> variable-length options field </font> is used when a sender and receiver negotiate the maximum segment size (MSS) or as a window scaling factor for use in high-speed networks. A time-stamping option is also defined. See RFC 854 and RFC 1323 for additional details.

- The flag field contains 6 bits. The ACK bit is used to indicate that the value carried in the acknowledgment field is valid; that is, the segment contains an <font color=#0099ff size=4> acknowledgment </font> for a segment that has been successfully received. The <font color=#0099ff size=4> RST, SYN, and FIN bits</font> are used for connection setup and teardown, as we will discuss at the end of this section. Setting the <font color=#0099ff size=4>PSH bit </font>indicates that the receiver should pass the data to the upper layer immediately. Finally, <font color=#0099ff size=4> the URG bit</font> is used to indicate that there is data in this segment that the sending-side upper-layer entity has marked as “urgent.” The location of the last byte of this urgent data is indicated by the 16-bit urgent data pointer field. TCP must inform the receiving-side upper-layer entity when urgent data exists and pass it a pointer to the end of the urgent data. (In practice, the PSH, URG, and the urgent data pointer are not used. However, we mention these fields for completeness.)  
Demo:  
<img src="https://rjgeek.github.io/images/2016/11/tcp_2.png?t=2>" width = "70%" height = "300" alt="图片名称" align=center />  
### Sequence Numbers and Acknowledgment Numbers
Two of the most important fields in the TCP segment header are the sequence number
field and the acknowledgment number field. These fields are a critical part of TCP’s
reliable data transfer service. But before discussing how these fields are used to provide
reliable data transfer, let us first explain what exactly TCP puts in these fields.  

TCP views data as an unstructured, but ordered, stream of bytes. TCP’s use of
sequence numbers reflects this view in that sequence numbers are over the stream of
transmitted bytes and not over the series of transmitted segments. <font color=#0099ff size=4>The sequence
number</font> for a segment is therefore the byte-stream number of the first byte in the
segment. Let’s look at an example. Suppose that a process in Host A wants to send a
stream of data to a process in Host B over a TCP connection. The TCP in Host A will
implicitly number each byte in the data stream. Suppose that the data stream consists
of a file consisting of 500,000 bytes, that the MSS is 1,000 bytes, and that the first
byte of the data stream is numbered 0.As shown in Figure bellow,
<img src="https://rjgeek.github.io/images/2016/11/tcp_3.png?t=2>" width = "70%" height = "300" alt="图片名称" align=center />  

TCP constructs 500 segments out of the data stream. The first segment gets assigned sequence number 0,
the second segment gets assigned sequence number 1,000, the third segment gets
assigned sequence number 2,000, and so on. Each sequence number is inserted in the
sequence number field in the header of the appropriate TCP segment.  

Now let’s consider acknowledgment numbers. These are a little trickier than
sequence numbers. Recall that TCP is full-duplex, so that Host A may be receiving
data from Host B while it sends data to Host B (as part of the same TCP connection).
Each of the segments that arrive from Host B has a sequence number for the data
flowing from B to A. The acknowledgment number that Host A puts in its segment
is the sequence number of the next byte Host A is expecting from Host B. It is good
to look at a few examples to understand what is going on here. Suppose that Host A
has received all bytes numbered 0 through 535 from B and suppose that it is about
to send a segment to Host B. Host A is waiting for byte 536 and all the subsequent
bytes in Host B’s data stream. So Host A puts 536 in the acknowledgment number
field of the segment it sends to B.  

As another example, suppose that Host A has received one segment from Host
B containing bytes 0 through 535 and another segment containing bytes 900 through
1,000. For some reason Host A has not yet received bytes 536 through 899. In this
example, Host A is still waiting for byte 536 (and beyond) in order to re-create B’s
data stream. Thus, A’s next segment to B will contain 536 in the acknowledgment
number field. Because TCP only acknowledges bytes up to the first missing byte in
the stream, TCP is said to provide cumulative acknowledgments.  

This last example also brings up an important but subtle issue. Host A received
the third segment (bytes 900 through 1,000) before receiving the second segment
(bytes 536 through 899). Thus, the third segment arrived out of order. The subtle
issue is: What does a host do when it receives out-of-order segments in a TCP connection?
Interestingly, the TCP RFCs do not impose any rules here and leave the
decision up to the people programming a TCP implementation. There are basically
two choices: either (1) the receiver immediately discards out-of-order segments
(which, as we discussed earlier, can simplify receiver design), or (2) the receiver
keeps the out-of-order bytes and waits for the missing bytes to fill in the gaps.
Clearly, the latter choice is more efficient in terms of network bandwidth, and is the
approach taken in practice.  

In Figure up, we assumed that the initial sequence number was zero. In truth,
both sides of a TCP connection randomly choose an initial sequence number. This is
done to minimize the possibility that a segment that is still present in the network
from an earlier, already-terminated connection between two hosts is mistaken for a
valid segment in a later connection between these same two hosts (which also happen
to be using the same port numbers as the old connection) [Sunshine 1978].

### Telnet: A Case Study for Sequence and Acknowledgment Numbers
Telnet, defined in RFC 854, is a popular application-layer protocol used for
remote login. It runs over TCP and is designed to work between any pair of hosts.
Unlike the bulk data transfer applications discussed in Chapter 2, Telnet is an
interactive application. We discuss a Telnet example here, as it nicely illustrates
TCP sequence and acknowledgment numbers. We note that many users now
prefer to use the SSH protocol rather than Telnet, since data sent in a Telnet connection
(including passwords!) is not encrypted, making Telnet vulnerable to
eavesdropping attacks 

Suppose Host A initiates a Telnet session with Host B. Because Host A initiates
the session, it is labeled the client, and Host B is labeled the server. Each character
typed by the user (at the client) will be sent to the remote host; the remote host will
send back a copy of each character, which will be displayed on the Telnet user’s
screen. This “echo back” is used to ensure that characters seen by the Telnet user
have already been received and processed at the remote site. Each character thus
traverses the network twice between the time the user hits the key and the time the
character is displayed on the user’s monitor

Now suppose the user types a single letter, ‘C,’and then grabs a coffee. Let’s examine
the TCP segments that are sent between the client and server. As shown in Figure
3.31, we suppose the starting sequence numbers are 42 and 79 for the client and server,
respectively.Recall that the sequence number of a segment is the sequence number of
the first byte in the data field. Thus, the first segment sent from the client will have
sequence number 42; the first segment sent from the server will have sequence number
Recall that the acknowledgment number is the sequence number of the next byte of
data that the host is waiting for. After the TCP connection is established but before any
data is sent, the client is waiting for byte 79 and the server is waiting for byte 42

As shown in Figure 3.31, three segments are sent. The first segment is sent from
the client to the server, containing the 1-byte ASCII representation of the letter ‘C’
in its data field. This first segment also has 42 in its sequence number field, as we
just described. Also, because the client has not yet received any data from the server,
this first segment will have 79 in its acknowledgment number field

The second segment is sent from the server to the client. It serves a dual purpose.
First it provides an acknowledgment of the data the server has received. By
putting 43 in the acknowledgment field, the server is telling the client that it has successfully
received everything up through byte 42 and is now waiting for bytes 43
onward. The second purpose of this segment is to echo back the letter ‘C.’ Thus, the
second segment has the ASCII representation of ‘C’ in its data field. This second
segment has the sequence number 79, the initial sequence number of the server-toclient
data flow of this TCP connection, as this is the very first byte of data that the
server is sending. Note that the acknowledgment for client-to-server data is carried
in a segment carrying server-to-client data; this acknowledgment is said to be
piggybacked on the server-to-client data segment

### Round-Trip Time Estimation and Timeout
TCP, like our rdt protocol in Section 3.4, uses a timeout/retransmit mechanism to
recover from lost segments. Although this is conceptually simple, many subtle
issues arise when we implement a timeout/retransmit mechanism in an actual protocol
such as TCP. Perhaps the most obvious question is the length of the timeout
intervals. Clearly, the timeout should be larger than the connection’s round-trip time
(RTT), that is, the time from when a segment is sent until it is acknowledged. Otherwise,
unnecessary retransmissions would be sent. But how much larger? How
should the RTT be estimated in the first place? Should a timer be associated with
each and every unacknowledged segment? So many questions! Our discussion in
this section is based on the TCP work in [Jacobson 1988] and the current IETF recommendations
for managing TCP timers [RFC 6298].
### Estimating the Round-Trip Time
Let’s begin our study of TCP timer management by considering how TCP estimates
the round-trip time between sender and receiver. This is accomplished as follows.
The sample RTT, denoted SampleRTT, for a segment is the amount of time
between when the segment is sent (that is, passed to IP) and when an acknowledgment
for the segment is received. Instead of measuring a SampleRTT for every
transmitted segment, most TCP implementations take only one SampleRTT measurement
at a time. That is, at any point in time, the SampleRTT is being estimated
for only one of the transmitted but currently unacknowledged segments, leading to a
new value of SampleRTT approximately once every RTT. Also, TCP never computes
a SampleRTT for a segment that has been retransmitted; it only measures
SampleRTT for segments that have been transmitted once [Karn 1987]. (A problem
at the end of the chapter asks you to consider why.)

Obviously, the SampleRTT values will fluctuate from segment to segment due
to congestion in the routers and to the varying load on the end systems. Because of
this fluctuation, any given SampleRTT value may be atypical. In order to estimate
a typical RTT, it is therefore natural to take some sort of average of the SampleRTT
values. TCP maintains an average, called EstimatedRTT, of the SampleRTT
values. Upon obtaining a new SampleRTT, TCP updates
EstimatedRTT according to the following formula:
$$EstimatedRTT = (1 – a) • EstimatedRTT +  a• SampleRTT$$



## 引用
http://macao.communications.museum/eng/exhibition/secondfloor/moreinfo/2_8_6_Multiplexing.html  
http://blog.chinaunix.net/uid-26758209-id-3146230.html  
《计算机网络-自顶向下方法(原书第4版)》  


















