---
title: Vue关闭线上环境console
date: 2020-03-04 14:08:59
tags: [Vue,Webpack,部署]
---

## 关于关闭线上环境console

在之前，我通过这样一行代码实现...

```JavaScript
console.log=()=>{}
```

虽然够用，但是不够优雅，难以维护。

**而现在在前端工程化的环境下，这样的代码显然不易于维护，最好是通过配置的方式来解决**

<!-- more -->

`Vue-Cli 3.0`之后的版本中将`webpack.config.js`配置文件隐藏，转而使用`vue.config.js`来替代。

在vue.config.js中添加如下代码

```JavaScript
configureWebpack(config) {
    // 关闭线上环境console
    if (process.env.NODE_ENV === 'production') {
        config.optimization.minimizer[0].options.terserOptions.compress.drop_console = true
    }
}
```

## 在普通webpack4环境中则可以使用`terser-webpack-plugin`这个插件

关键代码如下

```JavaScript
module.exports = {
  optimization: {
    minimizer: [
      new TerserPlugin({
        terserOptions: {
          compress: {
              warnings: false,
              drop_console: true,
              drop_debugger: true,
              pure_funcs: ['console.log']
          },
        },
      }),
    ],
  },
};

// 作者：sakibcc
// 链接：https://juejin.im/post/5c84b709e51d4578ca71dde4
// 来源：掘金
```

> 解决问题很简单，而优雅的解决问题，让维护成本降低，是程序员的优雅追求。
