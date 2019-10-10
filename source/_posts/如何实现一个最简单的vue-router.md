---
title: 如何实现一个最简单的Vue-Router
date: 2019-08-29 17:05:52
tags:
---

## 如何实现一个最简单的Vue-Router
要自己实现一个mini版的Vue-Router，当然要先了解他（Vue-Router）的原理。以及他都做了些什么？

### Vue-Router的实现原理

先来看看Vue-Router官网对自己的介绍：

> Vue Router 是 Vue.js 官方的路由管理器。**它和 Vue.js 的核心深度集成**，让构建单页面应用变得易如反掌。


那么本文中的mini版Vue-Router会简单实现一些Vue-Router的基础功能：
- 像真正的Vue-Router一样编写路由（仅基础实现）
- 实现Vue-Router的hash模式url
- 声明两个全局组件：router-link,router-view
- 响应式切换路由视图


#### 1. 提前扫盲，每次我们要引入Vue-Router都要使用以下代码来安装，

```javascript
import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

```
官方文档的解释：

> 安装 Vue.js 插件。如果插件是一个对象，必须提供 install 方法。如果插件是一个函数，它会被作为 install 方法。install 方法调用时，会将 Vue 作为参数传入。

``Vue.use()``会执行传入对象的install方法，以此安装插件

所以，想要我们的Vue-Router能够像官方的写法一致，除了提供类似的构造函数，还需要提供install方法。

#### 2. 编写VueRouter类，以及他的构造函数

新建一个my-vue-router.js

```javascript
let Vue; // 通过插件传递进来的Vue对象

//创建VueRouter类
export default class VueRouter{

  //构造函数
  constructor(options) {
    this.$options = options;
    // 声明map, 把path和component映射
    this.routeMap = {};

    // current保存当前hash
    // vue使其是响应式的
    this.app = new Vue({
      data: {
        current: "/",
      },
    });
  }
}

```


#### 3. 编写VueRouter的install静态方法

使用``Vue.mixin()``将router对象绑定到Vue的原型链上

关于[混入](https://cn.vuejs.org/v2/api/#mixins)

```javascript
//提供install方法
VueRouter.install = function(_Vue) {
  Vue = _Vue;

  // 混入：挂载$router
  Vue.mixin({
    beforeCreate() {
      // 希望接下来代码在每个组件创建时都执行
      // this指当前组件实例
      if (this.$options.router) {
        Vue.prototype.$router = this.$options.router;
        // 初始化router
        this.$options.router.init();
      }
    },
  });
};

```


#### 4. 梳理VueRouter类的结构与逻辑

```javascript
export default class VueRouter {

  constructor(options) {
    //...构造函数
  }

  init(){
    //执行VueRouter的install方法后在这里初始化router
    
    // 1.事件监听
    this.bindEvents();
    // 2.创建路由映射
    this.createRouteMap();
    // 3.声明两个全局组件
    this.initComponent();
  }

}

```
#### 5. bindEvents方法

监听hashchange事件，每当跟在＃符号后面的URL部分（包括＃符号）改变，就会触发该事件。
关于[hashchange](https://developer.mozilla.org/zh-CN/docs/Web/API/Window/hashchange_event)

```javascript
bindEvents(){
  window.addEventListener("hashchange", this.onHashChange.bind(this));
    window.addEventListener("load", this.onHashChange.bind(this));
}
onHashChange(){
  //处理一下url，并改变current的值
  this.app.current = window.location.hash.slice(1) || "/";
}


```


#### 6. createRouteMap方法

解析option中的router

```javascript
// 解析routes选项
  createRouteMap() {
    this.$options.routes.forEach(item => {
      this.routeMap[item.path] = item.component;
    });
  }
```
#### 7. initComponent方法（声明组件）

使用``Vue.component()``方法声明全局组件
使用``render()``函数渲染router-link组件的dom

```javascript
// 声明两个组件
  initComponent() {
    // Vue.component()
    Vue.component("router-link", {
      props: { to: { type: String, required: true } },
      //   template: '<a to="/">xxx</a>'
      render(h) {
        // 1. render生成虚拟dom
        // 2. 描述渲染dom结构
        // 3. h(tag, data, children)
        // return <a href={this.to}>{this.$slots.default}</a>
        const vdom = h('a', {attrs: {href: '#'+this.to}}, [this.$slots.default]);
        console.log(vdom);        
        return vdom;
      },
    });

    Vue.component('router-view', {
        render: h => {
            // this指向VueRouter实例
            const component = this.routeMap[this.app.current];
            return h(component);
        }
    })
  }
```

#### 8. 像真正的Vue-Router一样使用！

**在router.js中**

```javascript
import Vue from 'vue'
// import Router from 'vue-router'
// 注释掉真正的Vue-Router，使用我们的mini版本QvQ
import Router from './my-vue-router'
import Home from './views/Home.vue'
import About from './views/About.vue'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/about',
      name: 'about',
      component: About
    },
    // {
    //   path: '/about',
    //   name: 'about',
    //   // route level code-splitting
    //   // this generates a separate chunk (about.[hash].js) for this route
    //   // which is lazy-loaded when the route is visited.
    //   component: () => import(/* webpackChunkName: "about" */ './views/About.vue')
    // },
  ]
})
```

**App.vue中**

```javascript
<template>
  <div id="app">
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link>
    </div>
    <router-view/>
  </div>
</template>

<style>
···
</style>
```

**在main.js中引入**

```javascript
import Vue from 'vue'
import App from './App.vue'
import router from './router'

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')

```

### OK! 现在你应该可以在项目中看到效果了


## 小结
因为这是一个mini版本，非常简陋，仅仅实现了最基础的几个功能。

[关键代码片段github地址](https://github.com/zhangpeng2k/my-vue-practice/blob/master/src/my-vue-router.js)


