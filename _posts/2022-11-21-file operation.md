---
layout:     post
title:      file operation
subtitle:   
date:       2022-11-18
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

There are libraries that more efficient than with open function to deal with files in file system

## Path.open

```
from pathlib2 import Path
example_path = Path('./info.csv')
with example_path.open() as f:
   print(f.readline())
   print(f.read())
```

Path.read_text(): read file in text format
Path.read_bytes(): read file in binary format
Path.write_text(): write file in text format
Path.write_bytes(): write file in binay format

```
p = Path('my_binary_file')
p.write_bytes(b'Binary file contents')
```

## fileinput
### fileinput.input
as default fileinput take stdin as input source
```
import fileinput
for line in fileinput.input():
    print(line)
```
to read from file
```
import fileinput
with fileinput.input(files=('info1.csv', 'info2.csv')) as file:
    for line in file:
        print(f'{fileinput.filename()} 第{fileinput.lineno()}行: {line}', end='')
```
it works well with glob
```
import fileinput
import glob

for line in fileinput.input(glob.glob("*.csv")):
    if fileinput.isfirstline():
        print(f'Reading {fileinput.filename()}...'.center(50,'-'))
    print(str(fileinput.filelineno()) + ': ' + line.upper(), end=""
```

## codecs
it makes encoding/decoding automatically, if the source format is unknown
```
import codecs

src="......\\xxxx.csv"
dst="......\\xxx_utf8.csv"

def ReadFile(filePath):
    with codecs.open(filePath, "r") as f:
        return f.read()

def WriteFile(filePath, u, encoding="utf-8"):
    # with codecs.open(filePath,"w",encoding) as f:
    with codecs.open(filePath, "wb") as f:
        f.write(u.encode(encoding, errors="ignore"))

def CSV_2_UTF8(src, dst):
    content = ReadFile(src)
    WriteFile(dst, content, encoding="utf-8")
    
CSV_2_UTF8(src, dst)
```

## lazylines 
used for lazy reading large files without need of load all data into memory

```
import lazylines

with lazylines.open('large_file.txt') as lines:
    for line in lines:
        print(line.strip())
```

