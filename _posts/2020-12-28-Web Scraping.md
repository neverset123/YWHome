---
layout:     post
title:      web scraping
subtitle:   
date:       2020-12-28
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - data engineering
---


## Tips
### request with API rather than front-end url

    #slow solution
    import requests
    from bs4 import BeautifulSoup

    def parsePrice():
    r = requests.get("https://finance.yahoo.com/quote/FB?p=FB")
    soup = BeautifulSoup(r.text, "lxml")
    price = soup.find('div', {'class':'My(6px) Pos(r) smartphone_Mt(6px)'}).find('span').text
    print(f'the current price: {price}')

    #can be optimized into api solution
    import requests

    r = requests.get("https://query2.finance.yahoo.com/v10/finance/quoteSummary/FB?modules=price")
    data = r.json()
    print(data)
    print(f"the current price: {data['quoteSummary']['result'][0]['price']['regularMarketPrice']['raw']}")

#### find API
* Examine XHR Requests
 More Tools->Developer Tools->Network->filter the results by “XHR”
* search “query1” and “query2”
In the top-right corner of the developer’s console, select the three vertical dots and then select “Search” in the dropdown->Search for “query2”or "query1"

### Don’t repeat yourself (DRY)
* search for properties in the developer’s console to find the API

