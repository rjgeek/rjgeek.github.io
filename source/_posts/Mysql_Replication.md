---
title: 【数据库知识】MySQL英文文档翻译-16.0 复制配置
tags:
  - Mysql
id: 375
categories:
  - 数据库知识
date: 2016-12-22 02:02:09
keywords: MySQL,复制配置,数据库
---

## 引言 
最近加入了一个MySQL的开源组织，旨在将MySQL的英文官网文档翻译成中文，下面的内容为我负责的部分，因水平有限，在翻译过程中难免有纰漏，还请读者多多指教。
<img src="https://rjgeek.github.io/images/2016/12/MySQL_1.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
<!--more-->
## 原文

17.1 Replication Configuration  

17.1.1 How to Set Up Replication  
17.1.2 Replication Formats  
17.1.3 Replication with Global Transaction Identifiers  
17.1.4 Replication and Binary Logging Options and Variables  
17.1.5 Common Replication Administration Tasks  

Replication between servers in MySQL is based on the binary logging mechanism. The MySQL instance operating as the master (the source of the database changes) writes updates and changes as “events” to the binary log. The information in the binary log is stored in different logging formats according to the database changes being recorded. Slaves are configured to read the binary log from the master and to execute the events in the binary log on the slave's local database.

> Important  
> You cannot configure the master to log only certain events.

The master is “dumb” in this scenario. Once binary logging has been enabled, all statements are recorded in the binary log. Each slave receives a copy of the entire contents of the binary log. It is the responsibility of the slave to decide which statements in the binary log should be executed; you cannot configure the master to log only certain events. If you do not specify otherwise, all events in the master binary log are executed on the slave. If required, you can configure the slave to process only events that apply to particular databases or tables.

Each slave keeps a record of the binary log coordinates: The file name and position within the file that it has read and processed from the master. This means that multiple slaves can be connected to the master and executing different parts of the same binary log. Because the slaves control this process, individual slaves can be connected and disconnected from the server without affecting the master's operation. Also, because each slave records the current position within the binary log, it is possible for slaves to be disconnected, reconnect and then resume processing.

The master and each slave must be configured with a unique ID (using the server-id option). In addition, each slave must be configured with information about the master host name, log file name, and position within that file. These details can be controlled from within a MySQL session using the CHANGE MASTER TO statement on the slave. The details are stored within the slave's master info repository, which can be either a file or a table (see Section 17.2.2, “Replication Relay and Status Logs”).

This section describes the setup and configuration required for a replication environment, including step-by-step instructions for creating a new replication environment. The major components of this section are:

For a guide to setting up two or more servers for replication, Section 17.1.1, “How to Set Up Replication”, deals with the configuration of the systems and provides methods for copying data between the master and slaves.

Events in the binary log are recorded using a number of formats. These are referred to as statement-based replication (SBR) or row-based replication (RBR). A third type, mixed-format replication (MIXED), uses SBR or RBR replication automatically to take advantage of the benefits of both SBR and RBR formats when appropriate. The different formats are discussed in Section 17.1.2, “Replication Formats”.

Detailed information on the different configuration options and variables that apply to replication is provided in Section 17.1.4, “Replication and Binary Logging Options and Variables”.

Once started, the replication process should require little administration or monitoring. However, for advice on common tasks that you may want to execute, see Section 17.1.5, “Common Replication Administration Tasks”.

## 译文

16.1.1如何建立复制  
16.1.2复制格式  
16.1.3使用全局事务标识符进行复制  
16.1.4复制和二进制日志记录选项和变量  
16.1.5常见复制管理任务  

MySQL服务器之间的复制是基于二进制日志机制，MySQL主实例节点（数据库的变化源）将更新和变化作为“事件”写入二进制日志。不同的事件类型格式化成不同的二进制日志，从库读取主库二进制日志并在本地数据库上执行二进制日志中的事件。
> 重要  
> 您不能将主数据库配置为仅记录特定事件。

在这种情况下，主库是“哑的”。 一旦启用二进制日志记录，所有语句都记录在二进制日志中。 每个从库接收二进制日志的全部内容的副本。 决定在二进制日志中执行哪些语句是从库的责任; 您不能将主机配置为仅记录特定事件。 如果没有指定，则在从库上执行主库二进制日志中的所有事件。 如果需要，可以将从库配置为仅处理特定数据库或表的事件。

每个从库保存二进制日志的坐标：从主库读取和处理的文件中的文件名和位置。 这意味着多个从库可以连接到主站并执行相同二进制日志的不同部分。 由于从库控制此过程，因此可以在不影响主站操作的情况下将各个从站连接和断开与服务器的连接。 此外，由于每个从库记录二进制日志中的当前位置信息，因此可以断开重连然后恢复处理。

主库和每个从库必须配置唯一的ID（使用server-id选项）。此外，每个从库必须配置有关主库主机名，日志文件名和该文件中位置的信息。 这些细节可以在MySQL会话中使用从设备上的CHANGE MASTER TO语句来控制。 详细信息存储在从属主信息库中，可以是文件或表（请参见[第16.2.2节“复制中继和状态日志”](16.01.02_Replication_Formats.md)）。

本节介绍复制环境所需的体系和配置，包括创建新复制环境的分步说明。 本节的主要组成部分是：
- 有关设置两个或多个复制服务器的指南，请参见[第16.1.1节“如何设置复制”](16.01.01_How_to_Set_Up_Replication.md)，介绍系统的配置，并提供在主站和从站之间复制数据的方法。
- 二进制日志中的事件使用多种格式记录。 这些称为基于语句的复制（SBR）或基于行的复制（RBR）。 第三种类型的混合格式复制（MIXED）在适当时自动使用SBR或RBR复制来利用SBR和RBR格式的优点。 [第16.1.2节“复制格式”](16.01.02_Replication_Formats.md)中讨论了不同的格式。
- 有关适用于复制的不同配置选项和变量的详细信息，请参见[第16.1.4节“复制和二进制日志记录选项和变量”](16.01.04_Replication_and_Binary_Logging_Options_and_Variables.md)。
- 一旦开始，复制过程需要少量管理或监视。 但是，有关可能要执行的常见任务的建议，请参见[第16.1.5节“常见复制管理任务”](16.01.05_Common_Replication_Administration_Tasks.md)。
## 声明
本文100%为翻译组合,0%为原创
## 引用
http://dev.mysql.com/doc/refman/5.6/en/replication-configuration.html





