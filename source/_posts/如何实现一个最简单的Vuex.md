---
title: 如何实现一个简版的Vuex
date: 2019-09-05 21:42:20
tags:
---

## 如何实现一个最简单的Vuex
要自己实现一个mini版的Vuex，当然要先了解他（Vuex）的原理。以及他都做了些什么？

### Vuex的实现原理

先来看看Vuex官网对自己的介绍：

> Vuex 是一个专为 Vue.js 应用程序开发的状态管理模式。它采用集中式存储管理应用的所有组件的状态，并以相应的规则保证状态以一种可预测的方式发生变化。

那么本文中的mini版Vuex会简单实现一些Vuex的基础功能：
- 像真正的Vuex一样编写和引用
- 实现Vuex的state,getter,mutations,actions（仅基础实现）


#### 1. 提前扫盲，每次我们要引入Vuex都要使用以下代码来安装，

```
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

```
官方文档的解释：

> 安装 Vue.js 插件。如果插件是一个对象，必须提供 install 方法。如果插件是一个函数，它会被作为 install 方法。install 方法调用时，会将 Vue 作为参数传入。

``Vue.use()``会执行传入对象的install方法，以此安装插件

所以，想要我们的Vuex能够像官方的写法一致，除了提供类似的构造函数，还需要提供install方法。

#### 2. 编写Vuex类，以及他的构造函数

新建一个my-vuex.js

```
let Vue; // 通过插件传递进来的Vue对象

//创建Vuex类
class Store{

  //构造函数
  constructor(options) {
    
    // 将传入的options挂载到Store类上
    
    //使用一个Vue对象保存state中的值
    this.state = new Vue({
        data: options.state
    })

    // {mutations: {add:function(state){}}}
    this.mutations = options.mutations || {};

    // {actions: {add:function(ctx){}}}
    this.actions = options.actions || {};

    this.handleGetters(options.getters);

    this.$options = options;

  }
}

```


#### 3. 编写Vuex的install静态方法

使用``Vue.mixin()``将store对象绑定到Vue的原型链上

关于[混入](https://cn.vuejs.org/v2/api/#mixins)

```
//提供install方法
function install (_Vue) {
  Vue = _Vue;

  Vue.mixin({
    beforeCreate() {
      if (this.$options.store) {
        Vue.prototype.$store = this.$options.store
      }
    }
  })
}
export default {Store,install}

```


#### 4. handleGetters方法


```
handleGetters(getters) {
  this.getters = {};
  Object.keys(getters).forEach(key => {
    Object.defineProperty(this.getters, key, {
      get: () => {
        return getters[key](this.state)
      }
    })
  })
}


```


#### 5. commit,dispatch方法

解析option中的router

```
commit = (type, arg) => {
  this.mutations[type](this.state, arg)
}

dispatch = (type, arg) => {

  this.actions[type]({
    commit: this.commit,
    state: this.state,
    getters: this.getters
  }, arg)
}
```
#### 6. 完整Store类结构一览


```
let Vue;

class Store {

  constructor(options) {
    this.state = new Vue({
      data: options.state
      })
    this.mutations = options.mutations || {};
    this.actions = options.actions || {};
    this.handleGetters(options.getters);
  }

  commit = (type, arg) => {
    this.mutations[type](this.state, arg)
  }

  dispatch = (type, arg) => { 
    this.actions[type]({
      commit: this.commit,
      state: this.state,
      getters: this.getters
    }, arg)
  }

  handleGetters(getters) {
    this.getters = {};
    Object.keys(getters).forEach(key => {
      Object.defineProperty(this.getters, key, {
        get: () => {
          return getters[key](this.state)
        }
      })
    })
  }
}
function install (_Vue) {
  Vue = _Vue;

  Vue.mixin({
    beforeCreate() {
      if (this.$options.store) {
        Vue.prototype.$store = this.$options.store
      }
    }
  })
}
export default {Store,install}

```

## 结尾

[关键代码片段github地址](https://github.com/zhangpeng2k/my-vue-practice/blob/master/src/my-vuex.js)




