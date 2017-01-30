---
title: 【区块链】区块链中的 Merkle Tree 的java实现.
tags:
  - 区块链
id: 375
categories:
  - 区块链
date: 2017-01-28 17:02:09
keywords: Blockchain,Merkle tree，区块链
---

## 引言
这篇文章介绍了MerkleTree，MerkleTree被广泛的应用在比特币技术中，本文旨在通过代码实现一个简单的MerkleTree，并计算出Merkle tree的 TreeRoot
<img src="https://rjgeek.github.io/images/2016/12/MerkleTree_0.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
<!--more-->

## Merkle Tree简介

Merkle Tree 是一种数据结构，用于验证在计算机之间和之间存储，处理和传输的任何类型的数据。  

目前，Merkle树的主要用途是确保从对等网络中接收的数据块未受损和未改变，和检查其他对等网络没有撒谎发送假数据块。

## Merkle tree 应用例子
- 比特币
- Git
- Amazon's Dynamo
- Gassandra

## 环境
- windows 7
- oracle jdk 1.8.2
- Eclipse Java EE IDE for Web Developers. 
- Version: Neon.1a Release (4.6.1)

## 比特币中的应用
比特币中每个块中都包含了所有交易的集合签名，这个签名就是用Merkle tree实现的
<img src="https://rjgeek.github.io/images/2016/12/MerkleTree_1.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  

Merkle树用于比特币以汇总块中的所有事务，产生整个事务集合的整体数字指纹，提供非常有效的过程来验证事务是否包括在块中。

Merkle树一个很重要的用处是检查块中是否包含指定的交易，Merkle树是通过递归哈希节点对来构造的，直到只有一个哈希

<img src="https://rjgeek.github.io/images/2016/12/MerkleTree_2.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  

## Merkle tree 算法和实现
这个哈希树的跟节点称为Merkle根，Merkle树可以仅用log2(N)的时间复杂度检查任何一个数据元素是否包含在树中，

```
package test;

import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

public class MerkleTrees {

	  // transaction List
	  List<String> txList;
	  // Merkle Root
	  String root;
	  
	  /**
	   * constructor
	   * @param txList transaction List 交易List
	   */
	  public MerkleTrees(List<String> txList) {
	    this.txList = txList;
	    root = "";
	  }
	   
	  /**
	   * execute merkle_tree and set root.
	   */
	  public void merkle_tree() {
	    
	    List<String> tempTxList = new ArrayList<String>();
	    
	    for (int i = 0; i < this.txList.size(); i++) {
	      tempTxList.add(this.txList.get(i));
	    }
	   
	    List<String> newTxList = getNewTxList(tempTxList);
	   
	    while (newTxList.size() != 1) {
	      newTxList = getNewTxList(newTxList);
	    }
	    
	    this.root = newTxList.get(0);
	  }
	  
	  /**
	   * return Node Hash List.
	   * @param tempTxList
	   * @return
	   */
	  private List<String> getNewTxList(List<String> tempTxList) {
	    
	    List<String> newTxList = new ArrayList<String>();
	    int index = 0;
	    while (index < tempTxList.size()) {
	      // left
	      String left = tempTxList.get(index);
	      index++;

	      // right
	      String right = "";
	      if (index != tempTxList.size()) {
	        right = tempTxList.get(index);
	      }

	      // sha2 hex value
	      String sha2HexValue = getSHA2HexValue(left + right);
	      newTxList.add(sha2HexValue);
	      index++;
	      
	    }
	    
	    return newTxList;
	  }
	  
	  /**
	   * Return hex string
	   * @param str
	   * @return
	   */
	  public String getSHA2HexValue(String str) {
	        byte[] cipher_byte;
	        try{
	            MessageDigest md = MessageDigest.getInstance("SHA-256");
	            md.update(str.getBytes());
	            cipher_byte = md.digest();
	            StringBuilder sb = new StringBuilder(2 * cipher_byte.length);
	            for(byte b: cipher_byte) {
	              sb.append(String.format("%02x", b&0xff) );
	            }
	            return sb.toString();
	        } catch (Exception e) {
	                e.printStackTrace();
	        }
	        
	        return "";
	  }
	  
	  /**
	   * Get Root
	   * @return
	   */
	  public String getRoot() {
	    return this.root;
	  }
	    
	}
```
### 数据准备
我们将交易的数据，放入到List中
```
List<String> tempTxList = new ArrayList<String>();
tempTxList.add("a");
tempTxList.add("b");
tempTxList.add("c");
tempTxList.add("d");
tempTxList.add("e");
```
<img src="https://rjgeek.github.io/images/2016/12/MerkleTree_3.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
### 实现过程
- 准备交易数据
- 计算出每个数据的hash值，从左到右逐步组成树的左右节点
- 执行循环知道最后只剩下一个数据

<img src="https://rjgeek.github.io/images/2016/12/MerkleTree_4.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  

### 核心代码
```
  private List<String> getNewTxList(List<String> tempTxList) {

    List<String> newTxList = new ArrayList<String>();
    int index = 0;
    while (index < tempTxList.size()) {
      // left
      String left = tempTxList.get(index);
      index++;

      // right
      String right = "";
      if (index != tempTxList.size()) {
        right = tempTxList.get(index);
      }

      // sha2 hex value
      String sha2HexValue = getSHA2HexValue(left + right);
      newTxList.add(sha2HexValue);
      index++;

    }
```

### 测试代码
```
package test;
import java.util.ArrayList;
import java.util.List;
public class App {
	  public static void main(String [] args) {
	    List<String> tempTxList = new ArrayList<String>();
	    tempTxList.add("a");
	    tempTxList.add("b");
	    tempTxList.add("c");
	    tempTxList.add("d");
	    tempTxList.add("e");
	    
	    MerkleTrees merkleTrees = new MerkleTrees(tempTxList);
	    merkleTrees.merkle_tree();
	    System.out.println("root : " + merkleTrees.getRoot());
	  }
	}
```
### 执行结果

<img src="https://rjgeek.github.io/images/2016/12/MerkleTree_5.png?t=2>" width = "85%" height = "65%" alt="图片名称" align=center />  
## 总结
本文从简单二叉树的形式实现了简单的MerkleTree，并且计算出了TreeRoot，但是实际上的的MerkleTree不拘谨与二叉树还可能是多叉树。MerkleTree应用广泛，尤其在各类校验中，下一部分我们将着重探讨MerkleTree和传统的HashList校验的差别。
## 声明
本文90%为翻译组合,10%为原创
## 引用
http://java-lang-programming.com/en/articles/29





