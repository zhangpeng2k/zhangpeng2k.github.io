---
title: 一个button标签的灵异bug？！
date: 2019-09-26 16:59:36
tags: [bug,html,javascript]
---

## 副标题：我是如何定位一个未知的bug的？

假设你是一个开开心心的程序员，正在快乐写代码。

突然，你发现了一个bug：点击一个按钮时，页面却意外刷新了。

<!-- more -->

这本是很简单的逻辑，点击按钮，触发click事件：给某个数组的尾部添加一个值。

```javascript
//html
<button onclick='addValue()'>点击添加</button>

//javascript
var list = [];
function addValue(){
  list.push('哇哦')
}

```

做过无数类似逻辑，处理过无数bug的你，自信一笑。

“呵呵” 你这样想着：不过一个小bug而已，我来看看是哪里的错误。

“点击事件里加上console打印改变前后的数组”

你在浏览器里按下F12，打开开发者控制台，点到netWork，刷新页面。 一切操作仿佛做过千百遍，一气呵成。

“嘿？真邪门了！”你一遍遍的点着button，看见控制台一次次闪过那个数组，页面却在下一个瞬间刷新。

终于，在点击上百次后，你仍然没能从其中找到任何能帮助你定位bug的信息。

让我们再来一遍吧！

## 1. 检查语法或者变量错误

无论是多么有经验的程序员，总是会犯一些小错误的。
如果在一顿调试后发现是语法问题，或者是少写了分号，这种小错误。想想也是十分尴尬的。
...
在一顿寻找后，并没有发现语法错误。
成功排除掉语法错误。

## 2. 缩小问题范围

有着以往解决bug的经验，你知道定位bug首先就要把问题范围缩小。

“首先...试着排除是其他代码导致的问题吧。” 最难解决的就是两个不同的代码块之间的‘化学反应’了

比如事件冒泡，有时无意间创作出的bug最难定位了

你把无关的代码通通注释，这个button标签显得如此孤单：“再来试试！”

点击button，控制台输出，下一瞬刷新

“靠...不过也至少排除了，不是别的代码导致的问题”

## 3. 沙盒Demo调试法

在项目代码里注释，总有一些高耦合的代码没办法注释。

最好的办法是将想要测试的部分抽离出来。
现在已经确定了，有问题的代码就在这里。

```javascript
//html
<button onclick='addValue()'>点击添加</button>

//javascript
var list = [];
function addValue(){
  list.push('哇哦')
}

```

我们可以将这些代码分开测试：

- UI层（button标签）
- 逻辑层（addValue函数）

### 可以分离出如下代码：

```javascript
var list = [];
function addValue(){
  list.push('哇哦')
}
```

以及

```javascript
<button>test</button>
```

经过万全的测试，发现addValue函数并没有问题。
而button标签抽离掉业务代码后却还是会导致页面刷新。

新机词挖一此莫禾多此！（真相只有一个）

真正导致bug的凶手...就是这个button标签！
表面上看上去毫无问题，如此简洁的代码，我的vscode都没能识别出语法错误！
但，我无法识别出的问题，有人能够识别出！他就是[MDN文档](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button)!

文档中的demo如下

```javascript
<button class="favorite styled" type="button">
    Add to favorites
</button>

```

对比之下，button多了两个属性 class,type 毫无疑问！
问题就出在...class上！（吃错药

咳咳，当然是type了，而vscode并没能识别出语法错误，令我很疑惑。
查了一下相关文档后发现，type确实不是必填属性：

> 请始终为按钮规定 type 属性。Internet Explorer 的默认类型是 "button"，而其他浏览器中（包括 W3C 规范）的默认值是 "submit"。

打扰了，怪不得会刷新页面。原来是触发了表单提交行为...

> 假酒害人_(:з」∠)_
