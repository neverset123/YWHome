---
layout:     post
title:      recommendation engine
subtitle:   
date:       2020-11-15
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - python
---

## recommandation engine inside postgres
### madlib
### self-built engine
#### setup table structure

    CREATE TABLE orders (id int, product_id int);
    CREATE TABLE products(id serial, name text);

    INSERT INTO orders 
    VALUES (1,1),(1,2),(2,3),(2,10),(2,13),(3,3),(4,8),(4,9),(4,12),(5,3),(5,5),(5,7),(5,12),(6,1),(7,5),(7,13),(8,4),(9,3),(10,3),(10,13),(11,1),(11,8),(11,4),(12,8),(12,12),(13,5),(13,2),(13,7),(14,3),(14,13),(14,5),(15,3),(15,13);

    INSERT into products ("name") 
    VALUes ('Baseball Bat'), ('Baseball Glove'), ('Football'), ('Basketball Hoop'), ('Football Helmet'), ('Batting Gloves'), ('Baseball'), ('Hockey Stick'), ('Ice Skates'), ('Soccer Ball'), ('Goalie Mask'), ('Hockey Puck'), ('Cleats');

#### load data to dataframe

    CREATE OR REPLACE FUNCTION getrecommendations (id integer, orderids int[], orderedproducts int[], productids int[], productnames text[])
    RETURNS json
    AS $$
        import pandas as pd
    (SELECT ARRAY(SELECT id from orders order by id))
    o = {'order_id': orderids, 'product_id': orderedproducts}
    orders = pd.DataFrame(data=o)

    orders_for_product = orders[orders.product_id == id].order_id.unique();
    relevant_orders = orders[orders.order_id.isin(orders_for_product)]
    accompanying_products_by_order = relevant_orders[relevant_orders.product_id != id]
    num_instance_by_accompanying_product = accompanying_products_by_order.groupby("product_id")["product_id"].count().reset_index(name="instances")
    num_orders_for_product = orders_for_product.size
    product_instances = pd.DataFrame(num_instance_by_accompanying_product)
    product_instances["frequency"] = product_instances["instances"]/num_orders_for_product
    recommended_products = pd.DataFrame(product_instances.sort_values("frequency", ascending=False).head(3))
    CREATE OR REPLACE FUNCTION getrecommendations (id integer, orderids int[], orderedproducts int[], productids int[], productnames text[])
    RETURNS json
    AS $$
        import pandas as pd
        o = {'order_id': orderids, 'product_id': orderedproducts}
        orders = pd.DataFrame(data=o)    
        orders_for_product = orders[orders.product_id == id].order_id.unique();

        relevant_orders = orders[orders.order_id.isin(orders_for_product)]

        accompanying_products_by_order = relevant_orders[relevant_orders.product_id != id]
        num_instance_by_accompanying_product = accompanying_products_by_order.groupby("product_id")["product_id"].count().reset_index(name="instances")

        num_orders_for_product = orders_for_product.size
        product_instances = pd.DataFrame(num_instance_by_accompanying_product)
        product_instances["frequency"] = product_instances["instances"]/num_orders_for_product

        recommended_products = pd.DataFrame(product_instances.sort_values("frequency", ascending=False).head(3))

        p = {'product_id': productids, 'name': productnames}
        products = pd.DataFrame(data=p)

        recommended_products = pd.merge(recommended_products, products, on="product_id")

        return recommended_products.to_json(orient="table")
    $$ LANGUAGE 'plpython3u';
#### get recommandation

    SELECT json_pretty(getrecommendations(
         3, 
         (SELECT ARRAY(SELECT id from orders order by id)), 
         (SELECT ARRAY(SELECT product_id from orders order by id)), 
         (SELECT ARRAY(SELECT id from products order by id)), 
         (SELECT ARRAY(SELECT name from products order by id))
    ));

    {"schema": {"fields":[{"name":"index","type":"integer"},{"name":"product_id","type":"integer"},{"name":"instances","type":"integer"},{"name":"frequency","type":"number"},{"name":"name","type":"string"}],"primaryKey":["index"],"pandas_version":"0.20.0"}, "data": [{"index":0,"product_id":13,"instances":4,"frequency":0.5714285714,"name":"Cleats"},{"index":1,"product_id":5,"instances":2,"frequency":0.2857142857,"name":"Football Helmet"},{"index":2,"product_id":7,"instances":1,"frequency":0.1428571429,"name":"Baseball"}]}