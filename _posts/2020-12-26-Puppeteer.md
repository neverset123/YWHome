---
layout:     post
title:      puppeteer
subtitle:   
date:       2020-12-26
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - frontend
---

A Node library which provides a high-level API to control headless Chrome or Chromium over the DevTools Protocol

## setup environment

    #npm install puppeteer

## usage

### build API

    #an example api to convert webpage to pdf
    #for example: http://localhost:3000/pdf?target=https://google.com
    const express = require("express");
    const puppeteer = require("puppeteer");
    const app = express();

    app.get("/pdf", async (req, res) => {
        const url = req.query.target;

        const browser = await puppeteer.launch({
            headless: true
        });

        const webPage = await browser.newPage();

        await webPage.goto(url, {
            waitUntil: "networkidle0"
        });
        
        const pdf = await webPage.pdf({
            printBackground: true,
            format: "Letter",
            margin: {
                top: "20px",
                bottom: "40px",
                left: "20px",
                right: "20px"
            }
        });

        await browser.close();

        res.contentType("application/pdf");
        res.send(pdf);
    })

    app.listen(3000, () => {
        console.log("Server started");
    });



