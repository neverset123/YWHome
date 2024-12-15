---
layout:     post
title:      python wheel
subtitle:   
date:       2020-09-07
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

a wheel name can be broken down like this:
{dist}-{version}(-{build})?-{python}-{abi}-{platform}.whl

wheel installation is much faster than source code installation(python -m pip install -e .)

you can try to download from pypi the binary(whl) or source code zip to check the installation speed
    #python -m pip download --only-binary :all: --dest . --no-cache six

## build wheel
1. first install wheel and setuptools   
python -m pip install -U wheel setuptools

2. build python distribution (source distribution (sdist) and wheel (bdist_wheel)) 

        python setup.py sdist bdist_wheel
        #Specifying a Universal Wheel(py2 and py3 compitable whl)
        python setup.py bdist_wheel --universal
        #or in setup.py
        from setuptools import setup
        setup(
            # ....
            options={"bdist_wheel": {"universal": True}}
            # ....
        )

3. build manylinux  wheel   
PyPA provides a set of Docker images for many linux environments

4. Bundling Shared Libraries    
auditwheel will bundle external libraries into an already-built wheel. auditwheel is present on the manylinux Docker images;    
delocate does the same on macOS.

        $ auditwheel repair <path-to-wheel.whl>  # For manylinux
        $ delocate-wheel <path-to-wheel.whl>  # For macOS

5. checking wheel 

        #check-wheel-contents 
        $ check-wheel-contents dist/*.whl
        dist/ujson-2.0.3-cp38-cp38-macosx_10_15_x86_64.whl: OK
        #TestPyPI.
        $ python -m twine upload \
        --repository-url https://test.pypi.org/legacy/ \
        dist/*
        $ python -m pip install \
        --index-url https://test.pypi.org/simple/ \
        <pkg-name>

6. publishing wheel  

        $ python -m pip install -U twine
        $ python -m twine upload dist/*
