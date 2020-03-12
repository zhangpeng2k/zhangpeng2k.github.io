---
title: 解决npm权限问题
date: 2020-3-5 15:36:23
tags: [Mac,NPM,sudo]
---

我在github上新建了个[react练手项目](https://github.com/zhangpeng2k/my-react-practice)
本身在本地跑过`npm install`命令，今天想起来加个`.npmrc`文件，只是为了让npm跑的快一点，也不想用cnpm而已。
删除了`node_modules`目录，跑`npm install`的时候报错了，报错信息如下

```git
npm install

Unhandled rejection Error: EACCES: permission denied, open '/Users/xxx/.npm/_cacache/index-v5/38/59/44f5977494beb324f14d5d6076019a3d6719a5d78486a878288fd2328840'
...
```

<!-- more -->

一番菜鸡操作尝试无果后，求助了搜索引擎。

在[stackoverflow.com](http://stackoverflow.com/)上找到了答案：[答案链接](https://stackoverflow.com/questions/50639690/on-npm-install-unhandled-rejection-error-eacces-permission-denied)

**如果您第一次运行NPM时使用sudo，例如在尝试执行npm install -g时，就会发生这种情况。缓存文件夹需要由当前用户拥有，而不是root。**

看来是我之前`sudo`用的有点太过放肆了...

运行了答案提供的两条命令：

```cmd
sudo chown -R $USER:$GROUP ~/.npm
sudo chown -R $USER:$GROUP ~/.config
```

重新`npm install`，正常安装完成！

**注意一下，以后不能呢再放肆地使用`sudo`了呢(:з」∠)**

> 2020年03月05日14:52:04

## 我又来更新文章了

起因是疫情期间在家隔离，身边没有电脑玩，仅有的一台MacBook还是10.15系统... 运行不了我steam买的32位游戏....

所以趁机重装了10.14系统，系统和文件都全清掉了。

于是又遇到了npm权限不足问题...报错信息如下

```
Missing write access to /usr/local/lib/node_modules
...
```

使用之前的两条命令没法解决问题。百度了一下，找到了解决的办法。

官方给出的一个解决办法是给npm的global安装位置换个地方，因为默认的安装位置是/usr/local/lib文件夹，这是系统的文件夹所在地，所以可能会出现一些读写问题。将module的安装根目录设置在普通的文件夹下则没有问题

[官方建议](https://docs.npmjs.com/resolving-eacces-permissions-errors-when-installing-packages-globally)

```sh
# 第一步：在你的用户文件下新建一个文件夹，这个.npm-global 名字可以用你自己喜欢的名字替换，推荐直接使用这个名字。
mkdir ~/.npm-global
# 第二步：更改node的安装连接
npm config set prefix '~/.npm-global'
# 第三步：在用户的profile下增加path，为的是系统能够找到可执行文件的目录
export PATH=~/.npm-global/bin:$PATH
# 第四步：update profile。使其生效
source ~/.profile
```

