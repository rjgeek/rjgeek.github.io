---
title: Reading Notes Of 《RFC 2616, HTTP/1.1》 Part1
id: 1291
categories:
  - 网络知识
date: 2016-11-04 16:20:06
tags:
---
## Reading Notes Of 《RFC 2616, HTTP/1.1》 Part1
Copyright Notice  
1 Introduction  
&nbsp;  &nbsp; 1.1 Purpose  
&nbsp;  &nbsp;  1.2 Requirements  
&nbsp;  &nbsp; 1.3 Terminology  
&nbsp;  &nbsp; 1.4 Overall Operation  
# 1 Introduction
## 1.1 Purpose
The Hypertext Transfer Protocol (HTTP) is an application-level protocol for distributed, collaborative, hypermediainformation systems. HTTP has been in use by the World-Wide Web global information initiative since 1990. The first version of HTTP, referred to as HTTP/0.9, was a simple protocol for raw data transfer across the Internet. HTTP/1.0, as defined by RFC 1945 [6], improved the protocol by allowing messages to be in the format of MIMElike messages, containing metainformation about the data transferred and modifiers on the request/response semantics. However, HTTP/1.0 does not sufficiently take into consideration the effects of hierarchical proxies,caching, the need for persistent connections, or virtual hosts. In addition, the proliferation of incompletelyimplemented applications calling themselves “HTTP/1.0” has necessitated a protocol version change in order for two communicating applications to determine each other’s true capabilities.  

This specification defines the protocol referred to as “HTTP/1.1”. This protocol includes more stringent
requirements than HTTP/1.0 in order to ensure reliable implementation of its features.  

Practical information systems require more functionality than simple retrieval, including search, front-end update,and annotation. HTTP allows an open-ended set of methods and headers that indicate the purpose of a request [47].It builds on the discipline of reference provided by the Uniform Resource Identifier (URI) [3], as a location (URL)[4] or name (URN) [20], for indicating the resource to which a method is to be applied. Messages are passed in a format similar to that used by Internet mail [9] as defined by the Multipurpose Internet Mail Extensions (MIME) [7].  

HTTP is also used as a generic protocol for communication between user agents and proxies/gateways to other Internet systems, including those supported by the SMTP [16], NNTP [13], FTP [18], Gopher [2], and WAIS [10]protocols. In this way, HTTP allows basic hypermedia access to resources available from diverse applications.  

- 阐述了HTTP的发展历史，从版本0.9 到版本1.1 中间添加的新功能和新需求
- HTTP1.1重点增加了可靠性传输的功能

## 1.2 Requirements
The key words “MUST”, “MUST NOT”, “REQUIRED”, “SHALL”, “SHALL NOT”, “SHOULD”, “SHOULD
NOT”, “RECOMMENDED”, “MAY”, and “OPTIONAL” in this document are to be interpreted as described in
RFC 2119 [34].  

An implementation is not compliant if it fails to satisfy one or more of the MUST or REQUIRED level requirements for the protocols it implements. An implementation that satisfies all the MUST or REQUIRED level and all the SHOULD level requirements for its protocols is said to be “unconditionally compliant”; one that satisfies all the
MUST level requirements but not all the SHOULD level requirements for its protocols is said to be “conditionally compliant.”
## 1.3 Terminology(专业术语)
This specification uses a number of terms to refer to the roles played by participants in, and objects of, the HTTP communication.  

**connection（连接）**   
A transport layer virtual circuit established between two programs for the purpose of communication.  
**message（报文）**  
The basic unit of HTTP communication, consisting of a structured sequence of octets matching the syntax
defined in section 4 and transmitted via the connection.  
**request(请求) **   
An HTTP request message, as defined in section 5.  
**response（响应）**  
An HTTP response message, as defined in section 6.  
**resource（资源）**    
A network data object or service that can be identified by a URI, as defined in section 3.2. Resources may be
available in multiple representations (e.g. multiple languages, data formats, size, and resolutions) or vary in
other ways.
**entity(实体)**  
The information transferred as the payload of a request or response. An entity consists of metainformation in the form of entity-header fields and content in the form of an entity-body, as described in section 7.  
**representation**  
An entity included with a response that is subject to content negotiation, as described in section 12. There may exist multiple representations associated with a particular response status.  
**content negotiation （内容约定）**   
The mechanism（机制） for selecting the appropriate representation（表现） when servicing a request, as described in section 12.The representation of entities in any response can be negotiated（协定） (including error responses).  
**variant（变量）**  
A resource may have one, or more than one, representation(s) associated with it at any given instant（瞬间）. Each of these representations is termed a ‘variant.’ Use of the term ‘variant’ does not necessarily imply that the resource is subject to content negotiation.  
**client（客户端）**  
A program that establishes connections for the purpose of sending requests.  
**user agent（用户代理）**  
The client which initiates a request. These are often browsers, editors, spiders (web-traversing robots), or other end user tools.

- 用户代理包括了浏览器，爬虫，自动机器人

**server（服务端）**  
An application program that accepts connections in order to service requests by sending back responses. Any
given program may be capable of being both a client and a server; our use of these terms refers only to the role being performed by the program for a particular connection, rather than to the program’s capabilities in general. Likewise, any server may act as an origin server, proxy, gateway, or tunnel, switching behavior based on the nature of each request.  
**origin server（源服务器）**  
The server on which a given resource resides or is to be created.  
**proxy(代理)**  
An intermediary program which acts as both a server and a client for the purpose of making requests on behalf
of other clients. Requests are serviced internally or by passing them on, with possible translation, to other
servers. A proxy MUST implement both the client and server requirements of this specification. A “transparent
proxy” is a proxy that does not modify the request or response beyond what is required for proxy authentication
and identification. A “non-transparent proxy” is a proxy that modifies the request or response in order to provide some added service to the user agent, such as group annotation services, media type transformation, protocol reduction, or anonymity filtering. Except where either transparent or non-transparent behavior is explicitly stated, the HTTP proxy requirements apply to both types of proxies.

- 有时候为了提供更多的其他服务，可能会对HTTP的request or response进行适当调整

**gateway（网关）**  
A server which acts as an intermediary（中间阶段） for some other server. Unlike a proxy, a gateway receives requests as if it were the origin server for the requested resource; the requesting client may not be aware that it is communicating with a gateway.  

- 客户端意识不到它在和网关沟通

**tunnel（信道）**  
An intermediary program which is acting as a blind relay between two connections. Once active, a tunnel is not
considered a party to the HTTP communication, though the tunnel may have been initiated（发起） by an HTTP request. The tunnel ceases to exist when both ends of the relayed connections are closed.  

- HTTP发起信道通讯，一般信道用于HTTPS

**cache（缓存）**  
A program’s local store of response messages and the subsystem that controls its message storage, retrieval, and deletion. A cache stores cacheable responses in order to reduce the response time and network bandwidth
consumption on future, equivalent requests. Any client or server may include a cache, though a cache cannot be
used by a server that is acting as a tunnel.

- 缓存用户减少带宽消耗，减少相应时间，客户端和服务端均可以有缓存

**cacheable（是否能缓存）**  
A response is cacheable if a cache is allowed to store a copy of the response message for use in answering
subsequent requests. The rules for determining the cacheability of HTTP responses are defined in section 13.
Even if a resource is cacheable, there may be additional constraints on whether a cache can use the cached copy
for a particular request.  
**first-hand（首次握手）**  
A response is first-hand if it comes directly and without unnecessary delay from the origin server, perhaps via
one or more proxies. A response is also first-hand if its validity（有效性） has just been checked directly with the origin server.  
**explicit expiration time（显式过期时间）**  
The time at which the origin server intends that an entity should no longer be returned by a cache without further validation.  

- 可以设置的过期时间

**heuristic expiration time（启发式时间）**  
An expiration time assigned by a cache when no explicit expiration time is available.  

- 在没有设置的情况下，服务器自动给分配的过期时间

**age（存活时间）**  
The age of a response is the time since it was sent by, or successfully validated with, the origin server.
freshness lifetime The length of time between the generation of a response and its expiration time.

**fresh(刷新)**
A response is fresh if its age has not yet exceeded its freshness lifetime.  
**stale** 
A response is stale if its age has passed its freshness lifetime.  
**semantically transparent（语义透明）**   
A cache behaves in a “semantically transparent” manner, with respect to a particular response, when its use
affects neither the requesting client nor the origin server, except to improve performance. When a cache is
semantically transparent, the client receives exactly the same response (except for hop-by-hop headers) that it
would have received had its request been handled directly by the origin server.    
**validator（验证）**  
A protocol element (e.g., an entity tag or a Last-Modified time) that is used to find out whether a cache entry is an equivalent copy of an entity.

- 检验本次请求是否和上次一致，如果一致返回302

**upstream/downstream（上传流、下载流）**  
Upstream and downstream describe the flow of a message: all messages flow from upstream to downstream.  
**inbound/outbound**
Inbound and outbound refer to the request and response paths for messages: “inbound” means “traveling toward
the origin server”, and “outbound” means “traveling toward the user agent”

## 1.4 Overall Operation
The HTTP protocol is a request/response protocol. A client sends a request to the server in the form of a request method, URI, and protocol version, followed by a MIME-like（多用途互联网邮件扩展类型） message containing request modifiers, client information, and possible body content over a connection with a server. The server responds with a status line, including the message’s protocol version and a success or error code, followed by a MIME-like message containing server information, entity metainformation, and possible entity-body content. The relationship between HTTP and MIME is described in appendix 19.4.     

- 常见的MIME类型(通用型)：  
超文本标记语言文本 .html text/html  
xml文档 .xml text/xml  
XHTML文档 .xhtml application/xhtml+xml  
普通文本 .txt text/plain  
RTF文本 .rtf application/rtf  
PDF文档 .pdf application/pdf  
Microsoft Word文件 .word application/msword  
PNG图像 .png image/png  
GIF图形 .gif image/gif  
JPEG图形 .jpeg,.jpg image/jpeg  
au声音文件 .au audio/basic  
MIDI音乐文件 mid,.midi audio/midi,audio/x-midi  
RealAudio音乐文件 .ra, .ram audio/x-pn-realaudio  
MPEG文件 .mpg,.mpeg video/mpeg  
AVI文件 .avi video/x-msvideo  
GZIP文件 .gz application/x-gzip  
TAR文件 .tar application/x-tar  
任意的二进制数据 application/octet-stream   

Most HTTP communication is initiated by a user agent and consists of a request to be applied to a resource on some origin server. In the simplest case, this may be accomplished via a single connection (v) between the user agent (UA) and the origin server (O).  
 request chain ------------------------>  
 UA -------------------v------------------- O  
 <----------------------- response chain  
 
 - 用户代理发起请求， 服务端返回响应 
 
A more complicated situation occurs when one or more intermediaries（中间） are present in the request/response chain.There are three common forms of intermediary: proxy, gateway, and tunnel. A proxy is a forwarding agent, receiving requests for a URI in its absolute form, rewriting all or part of the message, and forwarding the reformatted request toward the server identified by the URI. A gateway is a receiving agent, acting as a layer above some other server(s) and, if necessary, translating the requests to the underlying server’s protocol. A tunnel acts as a relay point between two connections without changing the messages; tunnels are used when the communication needs to pass through an
intermediary (such as a firewall) even when the intermediary cannot understand the contents of the messages.  
 request chain -------------------------------------->  
 UA -----v----- A -----v----- B -----v----- C -----v----- O  
 <------------------------------------- response chain  
The figure above shows three intermediaries (A, B, and C) between the user agent and origin server. A request or response message that travels the whole chain will pass through four separate connections. This distinction is important because some HTTP communication options may apply only to the connection with the nearest, non tunnel neighbor, only to the end-points of the chain, or to all connections along the chain. Although the diagram is linear（线性的）, each participant may be engaged in multiple, simultaneous communications. For example, B may be receiving requests from many clients other than A, and/or forwarding requests to servers other than C, at the same time that it is handling A’s request. Any party to the communication which is not acting as a tunnel may employ an internal cache for handling requests.  
The effect of a cache is that the request/response chain is shortened if one of the participants along the chain has a cached response applicable to that request. The following illustrates the resulting chain if B has a cached copy of an earlier response from O (via C) for a request which has not been cached by UA or A.  
 request chain ---------->  
 UA -----v----- A -----v----- B - - - - - - C - - - - - - O  
 <--------- response chain  
 
Not all responses are usefully cacheable, and some requests may contain modifiers which place special requirements on cache behavior. HTTP requirements for cache behavior and cacheable responses are defined in section 13.  
In fact, there are a wide variety of architectures and configurations of caches and proxies currently being
experimented with or deployed across the World Wide Web. These systems include national hierarchies of proxy
caches to save transoceanic bandwidth, systems that broadcast or multicast cache entries, organizations that
distribute subsets of cached data via CD-ROM, and so on. HTTP systems are used in corporate intranets over highbandwidth links, and for access via PDAs with low-power radio links and intermittent connectivity. The goal of HTTP/1.1 is to support the wide diversity of configurations already deployed while introducing protocol constructs that meet the needs of those who build web applications that require high reliability and, failing that, at least reliable indications of failure.  

HTTP communication usually takes place over TCP/IP connections. The default port is TCP 80 [19], but other ports can be used. This does not preclude HTTP from being implemented on top of any other protocol on the Internet, or on other networks. HTTP only presumes a reliable transport; any protocol that provides such guarantees can be used; the mapping of the HTTP/1.1 request and response structures onto the transport data units of the protocol in question is outside the scope of this specification.  

In HTTP/1.0, most implementations used a new connection for each request/response exchange. In HTTP/1.1, a
connection may be used for one or more request/response exchanges, although connections may be closed for a
variety of reasons (see section 8.1).
