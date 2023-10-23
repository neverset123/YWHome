---
layout:     post
title:      pytorch tips
subtitle:   
date:       2023-10-23
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - pytorch
---

## hooks
get feature map and gradient map of selected layer with register_forward_hook，register_full_backward_hook
```
class SaveValues():
    def __init__(self, layer):
        self.model  = None
        self.input  = None
        self.output = None
        self.grad_input  = None
        self.grad_output = None
        # 注册hook
        self.forward_hook  = layer.register_forward_hook(self.hook_fn_act)
        self.backward_hook = layer.register_full_backward_hook(self.hook_fn_grad)
    # 定义正向传播hook
    def hook_fn_act(self, module, input, output):
        self.model  = module
        self.input  = input[0]
        self.output = output
    # 定义反向传播hook
    def hook_fn_grad(self, module, grad_input, grad_output):
        self.grad_input  = grad_input[0]
        self.grad_output = grad_output[0]
    # 移除hook
    def remove(self):
        self.forward_hook.remove()
        self.backward_hook.remove()

# 定义网络        
class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.l1 = nn.Linear(2, 5)
        self.l2 = nn.Linear(5, 10)

    def forward(self, x):
        x = self.l1(x)
        x = self.l2(x)
        return x
```
