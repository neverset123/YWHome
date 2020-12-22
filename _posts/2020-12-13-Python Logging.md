---
layout:     post
title:      python logging
subtitle:   
date:       2020-12-13
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

usually logging module is used to make python logs in files , console and elastic search

    import logging
    import sys
    from os import makedirs
    from os.path import dirname, exists

    from cmreslogging.handlers import CMRESHandler

    loggers = {}

    LOG_ENABLED = True  # enable logging
    LOG_TO_CONSOLE = True 
    LOG_TO_FILE = True 
    LOG_TO_ES = True  # enable log to Elasticsearch

    LOG_PATH = './runtime.log'  
    LOG_LEVEL = 'DEBUG'
    LOG_FORMAT = '%(levelname)s - %(asctime)s - process: %(process)d - %(filename)s - %(name)s - %(lineno)d - %(module)s - %(message)s'
    ELASTIC_SEARCH_HOST = 'eshost'  # Elasticsearch Host
    ELASTIC_SEARCH_PORT = 9200  # Elasticsearch Port
    ELASTIC_SEARCH_INDEX = 'runtime'  # Elasticsearch Index Name
    APP_ENVIRONMENT = 'dev'  # runtime environment

    def get_logger(name=None):
        """
        get logger by name
        :param name: name of logger
        :return: logger
        """
        global loggers

        if not name: name = __name__

        if loggers.get(name):
            return loggers.get(name)

        logger = logging.getLogger(name)
        logger.setLevel(LOG_LEVEL)

        # log to console
        if LOG_ENABLED and LOG_TO_CONSOLE:
            stream_handler = logging.StreamHandler(sys.stdout)
            stream_handler.setLevel(level=LOG_LEVEL)
            formatter = logging.Formatter(LOG_FORMAT)
            stream_handler.setFormatter(formatter)
            logger.addHandler(stream_handler)

        # log to file
        if LOG_ENABLED and LOG_TO_FILE:
            log_dir = dirname(log_path)
            if not exists(log_dir): makedirs(log_dir)
            file_handler = logging.FileHandler(log_path, encoding='utf-8')
            file_handler.setLevel(level=LOG_LEVEL)
            formatter = logging.Formatter(LOG_FORMAT)
            file_handler.setFormatter(formatter)
            logger.addHandler(file_handler)

        # log to Elasticsearch
        if LOG_ENABLED and LOG_TO_ES:
            # add CMRESHandler
            es_handler = CMRESHandler(hosts=[{'host': ELASTIC_SEARCH_HOST, 'port': ELASTIC_SEARCH_PORT}],
                                    # config auth type
                                    auth_type=CMRESHandler.AuthType.NO_AUTH,  
                                    es_index_name=ELASTIC_SEARCH_INDEX,
                                    # index frequency
                                    index_name_frequency=CMRESHandler.IndexNameFrequency.MONTHLY,
                                    # add runtime tag
                                    es_additional_fields={'environment': APP_ENVIRONMENT}  
                                    )
            es_handler.setLevel(level=LOG_LEVEL)
            formatter = logging.Formatter(LOG_FORMAT)
            es_handler.setFormatter(formatter)
            logger.addHandler(es_handler)

        # save to global logger
        loggers[name] = logger
        return logger

but it always need configuration for handler, which is not so elegent.

##  loguru
loguru is a libray that wrap logging module for elegent logging 

### install

    #pip install loguru

### usage

    from loguru import logger
    #defaul is only logging to console, if logging to file is needed then use add method to add the configuration
    logger.add('runtime.log')  
    logger.debug('this is a debug message')

    #traceback 
    @logger.catch
    def my_function(x, y, z):
        # An error? It's caught anyway!
        return 1 / (x + y + z)

