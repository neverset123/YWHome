---
layout:     post
title:      pytorch lightning
subtitle:   
date:       2022-10-24
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - pytorch
---

Its core concept is to seperate model and the engineering code, to make user concentrate on model research.

## installation

pip install pytorch-lightning

## usage

import torch   
from torch import nn   
from torchvision import transforms as T  
from torchvision.datasets import MNIST  
from torch.utils.data import DataLoader,random_split  
import pytorch_lightning as pl   
from torchmetrics import Accuracy

 

class MNISTDataModule(pl.LightningDataModule):  
    def __init__(self, data_dir: str = "./minist/",   
                 batch_size: int = 32,  
                 num_workers: int =4):  
        super().__init__()  
        self.data_dir = data_dir  
        self.batch_size = batch_size  
        self.num_workers = num_workers  
  
    def setup(self, stage = None):  
        transform = T.Compose([T.ToTensor()])  
        self.ds_test = MNIST(self.data_dir, train=False,transform=transform,download=True)  
        self.ds_predict = MNIST(self.data_dir, train=False,transform=transform,download=True)  
        ds_full = MNIST(self.data_dir, train=True,transform=transform,download=True)  
        self.ds_train, self.ds_val = random_split(ds_full, [55000, 5000])  
  
    def train_dataloader(self):  
        return DataLoader(self.ds_train, batch_size=self.batch_size,  
                          shuffle=True, num_workers=self.num_workers,  
                          pin_memory=True)  
  
    def val_dataloader(self):  
        return DataLoader(self.ds_val, batch_size=self.batch_size,  
                          shuffle=False, num_workers=self.num_workers,  
                          pin_memory=True)  
  
    def test_dataloader(self):  
        return DataLoader(self.ds_test, batch_size=self.batch_size,  
                          shuffle=False, num_workers=self.num_workers,  
                          pin_memory=True)  
  
    def predict_dataloader(self):  
        return DataLoader(self.ds_predict, batch_size=self.batch_size,  
                          shuffle=False, num_workers=self.num_workers,  
                          pin_memory=True)  

    

data_mnist = MNISTDataModule()  
data_mnist.setup()  

for features,labels in data_mnist.train_dataloader():  
    print(features.shape)  
    print(labels.shape)  
    break 

torch.Size([32, 1, 28, 28])  
torch.Size([32])

## tricks


1，use multi-process to read data(num_workers=4)
2，use memory lock(pin_memory=True)
3，use accelerator(gpus=4,strategy="ddp_find_unused_parameters_false")
4，accumulate grads(accumulate_grad_batches=6)
5，use 16 precision(precision=16,batch_size=2*batch_size)
6，set search batch_size(auto_scale_batch_size='binsearch')


