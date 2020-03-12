---
title: React学习笔记-2
date: 2019-10-13 10:59:59
tags: [React,学习笔记]
---


## 关于`this`的指向问题

- 函数内的`this`取决于函数在什么地方被调用

```javascript
export default class TodoList extends Component {
    constructor(props) {
        super(props)
        this.state = {
            list: [],
            text:''
        }
        // 官方建议 在这里 bind(this)  onChange事件里就不用显式声明e
        this.handleChange = this.handleChange.bind(this)
        // 即使不使用 e 但只要是在onClick事件中调用的函数，都要绑定this
    }
    handleChange(e) {
        console.log(e.target.value);
        this.setState({
            text: e.target.value
        }, () => {
            // 回调函数，在这里拿到正确的修改后的值
            console.log(this.state.text);
        })
    }
    ...
}
```
