---
layout:     post
title:      server side rendering
subtitle:   
date:       2021-04-02
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - react
---

a SPA page loading needs at least 3 cascading trips, which can not be execuated parallel.
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210402233050.png)
by code splitting the bundle size can be kept small, but main bundle doesn't know what page chunk to request until it executes.
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210402234132.png)

with Server Side Rendering it can load modules before the initial bundle even parses and executes. Additionally, it can start the async data loading immediately on receiving the request on the server and serialize the data back into the page.
![](https://raw.githubusercontent.com/neverset123/cloudimg/master/Img20210403001822.png)

## Optimizing component code size
When a server-rendered page arrives in the browser and we want to attach the interactive JavaScript to it we call this hydration.
## optimizing performance
1. Separate the data loading from the view componen with React Suspense

    // ProfilePage.js
    const ProfileDetails = lazy(() => import("./ProfileDetails.js"));

    function ProfilePage() {
    // This is not a Promise. It's a special object
    // from a Suspense integration.
    const resource = fetchProfileData();
    return (
        <Suspense fallback={<h1>Loading profile...</h1>}>
        <ProfileDetails user={resource.user} />
        </Suspense>
    );
    }

    // ProfileDetails.js
    function ProfileDetails(props) {
    // Try to read user info, although it might not have loaded yet
    const user = props.user.read();
    return <h1>{user.name}</h1>;
    }

2. Streaming (Progressive Rendering) 
browsers will eagerly render even drawing elements that they haven't yet received their closing tags and execute scripts inline as you send them on the page.

