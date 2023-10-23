---
layout:     post
title:      time series
subtitle:   
date:       2023-10-23
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## time series to supervised learning
```
from pandas import DataFrame
from pandas import concat

def series_to_supervised(data, n_in=1, n_out=1, dropnan=True):
	"""
	将时间序列重构为监督学习数据集.
	参数:
		data: 观测值序列，类型为列表或Numpy数组。
		n_in: 输入的滞后观测值(X)长度。
		n_out: 输出观测值(y)的长度。
		dropnan: 是否丢弃含有NaN值的行，类型为布尔值。
	返回值:
		经过重组后的Pandas DataFrame序列.
	"""
	n_vars = 1 if type(data) is list else data.shape[1]
	df = DataFrame(data)
	cols, names = list(), list()
	# 输入序列 (t-n, ... t-1)
	for i in range(n_in, 0, -1):
		cols.append(df.shift(i))
		names += [('var%d(t-%d)' % (j+1, i)) for j in range(n_vars)]
	# 预测序列 (t, t+1, ... t+n)
	for i in range(0, n_out):
		cols.append(df.shift(-i))
		if i == 0:
			names += [('var%d(t)' % (j+1)) for j in range(n_vars)]
		else:
			names += [('var%d(t+%d)' % (j+1, i)) for j in range(n_vars)]
	# 将列名和数据拼接在一起
	agg = concat(cols, axis=1)
	agg.columns = names
	# 丢弃含有NaN值的行
	if dropnan:
		agg.dropna(inplace=True)
	return agg
#example
raw = DataFrame()
raw['ob1'] = [x for x in range(10)]
raw['ob2'] = [x for x in range(50, 60)]
values = raw.values
data = series_to_supervised(values)
print(data)
```