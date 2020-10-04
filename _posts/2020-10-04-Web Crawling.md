---
layout:     post
title:      web crawling
subtitle:   
date:       2020-10-04
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - Python
---


## selenium
selenium is a test framework for web application, which can also be used in web crawling.
drawback: speed too low, version configuration, driver update, cookies storage
## pyppeteer
puppeteer is a Chrome API tool base on Node.js. It can operate Chrome brower with javascript, such as web scrawling, web testing.   
pyppeteer is the python version of puppeteer, which uses Chromium as browser

### Install

    pip3 install pyppeteer
    import pzppeteer

### Usage
pyppeteer is based on async IO, so async/await structure is needed. 

    import asyncio
    from pyppeteer import launch
    import random
    def screen_size():
        import tkinter
        tk = tkinter.Tk()
        width = tk.winfo_screenwidth()
        height = tk.winfo_screenheight()
        tk.quit()
        return width, height
    async def main():
        browser = await launch(headless=False)
        page = await browser.newPage()
        width, height = screen_size()
        await page.setViewport(viewport={'width': width, 'height': height})
        await page.goto('https://www.baidu.com/', options={'timeout': 5 * 1000})
        await asyncio.sleep(10)
        await page.screenshot({'path': 'example1.png'})
        await page.type('#kw', 'python Pyppeteer crawling')
        await page.click('#su')
        await asyncio.sleep(random.randint(1, 3))
        await page.screenshot({'path': 'example2.png'})
        await browser.close()
    asyncio.get_event_loop().run_until_complete(main())

