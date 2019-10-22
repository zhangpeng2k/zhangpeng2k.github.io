---
title: 记npm在mac环境下遇到的一个坑
date: 2019-10-22 13:36:23
tags:
---

我在github上新建了个[react练手项目](https://github.com/zhangpeng2k/my-react-practice)
本身在本地跑过`npm install`命令，今天想起来加个`.npmrc`文件，只是为了让npm跑的快一点，也不想用cnpm而已。
删除了`node_modules`目录，跑`npm install`的时候报错了，报错信息如下
```
npm install

Unhandled rejection Error: EACCES: permission denied, open '/Users/xxx/.npm/_cacache/index-v5/38/59/44f5977494beb324f14d5d6076019a3d6719a5d78486a878288fd2328840'
...
```

<!-- more -->

一番菜鸡操作尝试无果后，求助了搜索引擎。

在[stackoverflow.com](http://stackoverflow.com/)上找到了答案：https://stackoverflow.com/questions/50639690/on-npm-install-unhandled-rejection-error-eacces-permission-denied

**如果您第一次运行NPM时使用sudo，例如在尝试执行npm install -g时，就会发生这种情况。缓存文件夹需要由当前用户拥有，而不是root。**

看来是我之前`sudo`用的有点太过放肆了...

运行了答案提供的两条命令：
```
sudo chown -R $USER:$GROUP ~/.npm
sudo chown -R $USER:$GROUP ~/.config
```
重新`npm install`，正常安装完成！

**注意一下，以后不能呢再放肆地使用`sudo`了呢** _(:з」∠)_