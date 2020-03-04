---
title: React学习笔记-1
date: 2019-10-09 17:55:04
tags: [React]
---


## 组件基础

- 无论是类组件还是函数组件，组件名称首字母必须大写！
<!-- more -->
- render函数return的内容只能有一个根节点，需要一个包裹元素，
比如使用数组：

```javascript
render(
  [<h1 />,<h2 />]
)
```

  或者 Fragments:

```javascript
render(
  <React.Fragments>
    <h1 />
    <h2 />
  </React.Fragments>
)
// 短语法:
render(
  <>
    <h1 />
    <h2 />
  </>
)

```

### 函数组件

- 函数组件通常无状态，仅关注内容展示（Hooks除外）

### 类组件

- 类组件通常拥有状态和生命周期，继承于Component，实现render方法

### 组件的生命周期

- [v16.0之前的生命周期](https://upload-images.jianshu.io/upload_images/5287253-bd799f87556b5ecc.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/webp)

- [v16.4的生命周期](https://upload-images.jianshu.io/upload_images/5287253-82f6af8e0cc9012b.png?imageMogr2/auto-orient/strip|imageView2/2/w/1200/format/jpg)
