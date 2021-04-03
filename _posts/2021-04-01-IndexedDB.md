---
layout:     post
title:      IndexedDB
subtitle:   
date:       2021-04-01
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - react
---

IndexedDB is an inbuilt non-relational database for browser to persistently store data in the browser and to perform various types of queries on it. Dexie.js is a minimalistic wrapper for IndexedDB to handle offline data storage in our web applications.
* non-relational database
* support usage of web applications even in offline mode
* application can only access data from an IndexedDB database that runs on the same domain or subdomain as itself
## installation

    npm i -s dexie@next dexie-react-hooks

## usage
### create IndexedDB

    const initializeDb = indexedDB.open('name_of_database', version)

### create object

    initializeDb.onupgradeneeded = () => {
        const database = initializeDb.result
        database.createObjectStore('name_of_object_store', {autoIncrement: true})
    }

with Dexie the process of creating IndexedDB and objects are simplified:

    const db = new Dexie('exampleDatabase')
    db.version(1).stores({
        name_of_object_store: '++id, name, price',
        name_of_another_object_store: '++id, title'
    })

### query

    const items = await db.friends
        .where('price').above(10)
        .toArray();

## example
the template is here: https://github.com/ebenezerdon/market-list-template

    #./src/App.js
    import Dexie from 'dexie'
    import { useLiveQuery } from "dexie-react-hooks"
    const db = new Dexie('MarketList');
    db.version(1).stores(
    { items: "++id,name,price,itemHasBeenPurchased" }
    )

    const App = () => {
        //useLiveQuery hook is to watch for changes and re-render our React component when an update is made to the IndexedDB database
        const allItems = useLiveQuery(() => db.items.toArray(), []);
        if (!allItems) return null

        //add item
        const addItemToDb = async event => {
            event.preventDefault()
            const name = document.querySelector('.item-name').value
            const price = document.querySelector('.item-price').value
            await db.items.add({
            name,
            price: Number(price),
            itemHasBeenPurchased: false
            })
        }
        //delete item
        const removeItemFromDb = async id => {
            await db.items.delete(id)
            }
            //mark item as purchased
            const markAsPurchased = async (id, event) => {
            if (event.target.checked) {
                await db.items.update(id, {itemHasBeenPurchased: true})
            }
            else {
                await db.items.update(id, {itemHasBeenPurchased: false})
            }
        }

    }

    const itemData = allItems.map(({ id, name, price, itemHasBeenPurchased }) => (
        <div className="row" key={id}>
            <p className="col s5">
            <label>
                <input
                type="checkbox"
                checked={itemHasBeenPurchased}
                onChange={event => markAsPurchased(id, event)}
                />
                <span className="black-text">{name}</span>
            </label>
            </p>
            <p className="col s5">${price}</p>
            <i onClick={() => removeItemFromDb(id)} className="col s2 material-icons delete-button">
            delete
            </i>
        </div>
    ))
    return (
        <div className="container">
            <h3 className="green-text center-align">Market List App</h3>
            <form className="add-item-form" onSubmit={event => addItemToDb(event)} >
            <input type="text" className="item-name" placeholder="Name of item" required/>
            <input type="number" step=".01" className="item-price" placeholder="Price in USD" required/>
            <button type="submit" className="waves-effect waves-light btn right">Add item</button>
            </form>
            {allItems.length > 0 &&
            <div className="card white darken-1">
                <div className="card-content">
                <form action="#">
                    { itemData }
                </form>
                </div>
            </div>
            }
        </div>
    )
