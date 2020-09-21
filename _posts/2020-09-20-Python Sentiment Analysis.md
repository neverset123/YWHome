---
layout:     post
title:      python sentiment analysis
subtitle:   
date:       2020-09-20
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---
sentiment analysis is useful to classifying text as positive, negtive, neutral

### preview data

#### histogram

        import matplotlib.pyplot as plt
        import seaborn as sns
        color = sns.color_palette()
        %matplotlib inline
        import plotly.offline as py
        py.init_notebook_mode(connected=True)
        import plotly.graph_objs as go
        import plotly.tools as tls
        import plotly.express as px# Product Scoresfig = px.histogram(df, x="Score")
        fig.update_traces(marker_color="turquoise",marker_line_color='rgb(8,48,107)',
                        marker_line_width=1.5)
        fig.update_layout(title_text='Product Score')
        fig.show()

#### wordcloud

        import nltk
        from nltk.corpus import stopwords# Create stopword list:
        stopwords = set(STOPWORDS)
        stopwords.update(["br", "href"])
        textt = " ".join(review for review in df.Text)
        wordcloud = WordCloud(stopwords=stopwords).generate(textt)plt.imshow(wordcloud, interpolation='bilinear')
        plt.axis("off")
        plt.savefig('wordcloud11.png')
        plt.show()

### classifying

#### generate new class

        # assign reviews with score > 3 as positive sentiment
        # score < 3 negative sentiment
        # remove score = 3df = df[df['Score'] != 3]
        df['sentiment'] = df['Score'].apply(lambda rating : +1 if rating > 3 else -1)

#### wordcloud with new class

        positive = df[df['sentiment'] == 1]
        negative = df[df['sentiment'] == -1]
        #positive wordcloud
        stopwords = set(STOPWORDS)
        stopwords.update(["br", "href","good","great"])
        pos = " ".join(review for review in positive.Summary)
        wordcloud2 = WordCloud(stopwords=stopwords).generate(pos)plt.imshow(wordcloud2, interpolation='bilinear')
        plt.axis("off")
        plt.show()

#### distribution of new classes

        df['sentimentt'] = df['sentiment'].replace({-1 : 'negative'})
        df['sentimentt'] = df['sentimentt'].replace({1 : 'positive'})
        fig = px.histogram(df, x="sentimentt")
        fig.update_traces(marker_color="indianred",marker_line_color='rgb(8,48,107)',
                        marker_line_width=1.5)
        fig.update_layout(title_text='Product Sentiment')
        fig.show()

### build sentiment model with sk-learn
#### data cleaning

        def remove_punctuation(text):
        final = "".join(u for u in text if u not in ("?", ".", ";", ":",  "!",'"'))
        return finaldf['Text'] = df['Text'].apply(remove_punctuation)
        df = df.dropna(subset=['Summary'])
        df['Summary'] = df['Summary'].apply(remove_punctuation)
        dfNew = df[['Summary','sentiment']]
        index = df.index
        df['random_number'] = np.random.randn(len(index))train = df[df['random_number'] <= 0.8]
        test = df[df['random_number'] > 0.8]
#### count vectorization

        from sklearn.feature_extraction.text import CountVectorizer
        vectorizer = CountVectorizer(token_pattern=r'\b\w+\b')
        train_matrix = vectorizer.fit_transform(train['Summary'])
        test_matrix = vectorizer.transform(test['Summary'])

#### train & predict

        X_train = train_matrix
        X_test = test_matrix
        y_train = train['sentiment']
        y_test = test['sentiment']

        from sklearn.linear_model import LogisticRegression
        lr = LogisticRegression()
        lr.fit(X_train,y_train)
        predictions = lr.predict(X_test)

        from sklearn.metrics import confusion_matrix,classification_report
        new = np.asarray(y_test)
        confusion_matrix(predictions,y_test)
        print(classification_report(predictions,y_test))