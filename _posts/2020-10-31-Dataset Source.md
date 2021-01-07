---
layout:     post
title:      dataset source
subtitle:   
date:       2020-10-31
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data engineering
---


## data source

1. Awesome Data
data stored in github

https://github.com/awesomedata/awesome-public-datasets

2. Data Is Plural
data source in sheet file

https://docs.google.com/spreadsheets/d/1wZhPLMCHKJvwOkP4juclhjFgqIY8fQFMemwKL2c64vk/edit#gid=0

3. Kaggle

4. Data.world
https://data.world/

5. Google Dataset Search
https://datasetsearch.research.google.com/

6. OpenDaL
search engine for data

https://opendatalibrary.com/

7. Pandas Data Reader

Pandas Data Reader fetch online data and put them in pandas dataframe

https://pandas-datareader.readthedocs.io/en/latest/remote_data.html

8. API

https://towardsdatascience.com/how-to-get-data-from-apis-with-python-dfb83fdc5b5b

https://towardsdatascience.com/the-top-10-best-places-to-find-datasets-8d3b4e31c442

9. Bifrost
this is a data search tool containing different kinds of datas

10. nhanes
National Health and Nutrition Examination Survey

11. Waymo Open Dataset
https://waymo.com/open

12. MS COCO dataset
https://cocodataset.org/#home

###  kaggle API
The Kaggle API allows Kaggle datasets to be downloaded programmatically/through the command line interface.

    import os
    import subprocess
    import zipfile
    import pandas as pd
    import numpy as np
    import kaggle 

    from typing import Optional

    kaggle.api.authenticate()

    class DataPipeline:
        def __init__(self):
            self.preprocessing_steps = [self.lowercase,
                                        self.impute_missing_comments,]
            self.train: Optional[pd.DataFrame]
            self.test: Optional[pd.DataFrame]

        # Kaggle API is smart enough to know when a file has been downloaded
        def load_data(self):
            data_path = os.path.join(os.getcwd(), 'data')
            kaggle.api.competition_download_files('jigsaw-toxic-comment-classification-challenge', path=data_path)
            with zipfile.ZipFile(data_path + '/jigsaw-toxic-comment-classification-challenge.zip') as z:
                with z.open('train.csv') as f:
                    self.train = pd.read_csv(f)
                with z.open('test.csv') as f:
                    self.test = pd.read_csv(f)

        def preprocess(self):
            self.load_data()
            for func in self.preprocessing_steps:
                self.train['comment_text'] = self.train['comment_text'].apply(func)
                self.test['comment_text'] = self.test['comment_text'].apply(func)
                print('Finished applying preprocessing step {}'.format(func.__name__))

        '''
            Transformative steps for data cleaning/preprocessing
        '''

        def lowercase(self, text: str) -> str:
            return text.lower()

        def impute_missing_comments(self, text: str) -> str:
            if text == '' or text is np.nan:
                return 'unknown'
            else:
                return text
