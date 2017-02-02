---
title: 【Docker】Spring Boot Docker MySQL Demo
tags:
  - Docker
id: 375
categories:
  - Docker
date: 2017-02-01 22:02:09
keywords: Spring,Docker，MySQL
---

## Introduction
Since this is the first time for me to use spring-boot project running in the docker with MySQL database, I use a lot of Yuan Ji's work for reference. you can also read his [web page](https://www.jiwhiz.com/blogs/Spring_Boot_Docker_MySQL_Demo) directly.  
In the learning of this project, I have met with many difficulties. To help others have a better understanding of spring-mysql running on the docker. I decide to write it down and you can find the demo project at [GitHub](https://github.com/rjgeek/spring-boot-mysql-docker).
<img src="https://rjgeek.github.io/images/2017/01/spring-boot-docker.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  
<!--more-->

## These steps are as follows
### 1.Clone the project:
```
git clone https://github.com/rjgeek/spring-boot-mysql-docker.git
cd spring-boot-docker-mysql
```

### 2.Run MySQL in Docker container:
```
docker run --name demo-mysql -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=demo -e MYSQL_USER=demo_user -e MYSQL_PASSWORD=demo_pass -d mysql:5.6
```

- -name demo-mysql to assign a name to the container.  
- -e to pass environment variables to the container, and create a demo database with a user demo-user and password. This user will be granted superuser permissions for the demo database.  
- -p 3306:3306 to expose MySQL port to the local host.  
- -d to tell Docker to daemonize the container and keep it running.mysql:5.6 to download MySQL 5.6 Server image from Docker public repo if not in your computer yet.  

### 3.Check the log to make sure MySQL is running OK
```
docker logs demo-mysql
```
<img src="https://rjgeek.github.io/images/2017/01/spring-boot-docker-2.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />
And you can access the server by localhost:3307/demo,the database instance is "demo", the user is "demo_user" and the password is "demo_pass".

### 4.Maven package and demo application docker build:
```
cd spring-boot-docker-mysql
mvn clean package docker:build
```
<img src="https://rjgeek.github.io/images/2017/01/spring-boot-docker-1.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  

### 5. Run demo application MySQL in Docker container and link to demo-mysql:
```
docker run -p 8080:8080 --name demo-app --link demo-mysql:mysql -d ehcoo/spring-boot-docker-mysql
```
### 6. Check the log to make sure Server is running OK
```
docker logs demo-app
```
<img src="https://rjgeek.github.io/images/2017/01/spring-boot-docker-4.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  

### 7. Test the whole project
Open http://127.0.0.1:8080 in browser and you should see the message
<img src="https://rjgeek.github.io/images/2017/01/spring-boot-docker-5.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  
Open http://127.0.0.1:8080/hotels/1 in browser and you should see the message
<img src="https://rjgeek.github.io/images/2017/01/spring-boot-docker-6.png?t=1>" width = "85%" height = "65%" alt="图片名称" align=center />  

***
This is the end!





