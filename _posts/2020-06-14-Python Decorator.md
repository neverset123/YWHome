---
layout:     post
title:      python decorator
subtitle:   
date:       2020-06-14
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

python decorator is used in Logging, type checking, exception handling without making the functional code dirty

## logging

    def log_decorator(log_name):
    def log_this(function):
        logger = logging.getLogger(log_name)
        def new_function(*args,**kwargs):
            logger.debug(f"{function.__name__} - {args} - {kwargs}")
            output = function(*args,**kwargs)
            logger.debug(f"{function.__name__} returned: {output}")
            return output
        return new_function
    return log_this

## type checking

    def accepts(*types):
        def check_accepts(function):
            assert len(types) == function.__code__.co_argcount,\
                "Number of typed inputs must match the function inputs"
            def new_function(*args, **kwargs):
                for (a, t) in zip(args, types):
                    assert isinstance(a, t), \
                        "arg %r does not match %s" % (a,t)
                return function(*args, **kwargs)
            return new_function
    return check_accepts

## error handling
    def error_handling(api_function):
        def trial(*args, num_retries=0, **kwargs):
            try:
                return api_function(*args, **kwargs)
            except api.error.RateLimitError:
                if num_retries > MAX_RETRIES:
                    raise RuntimeError("Too many retries")
                else:
                    msg = f"rate limit reached. Waiting {API_WAIT_TIME} minutes ..."
                    time.sleep(API_WAIT_TIME * 60)
             return trial(*args, num_retries=num_retries + 1, **kwargs)    
        return trial