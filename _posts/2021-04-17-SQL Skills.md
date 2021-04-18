---
layout:     post
title:      sql skills
subtitle:   
date:       2021-04-17
author:     neverset
header-img: img/post-bg-kuaidi.jpg
catalog: true
tags:
    - database
---


## tips
###  Filter Condition: HAVING and WHERE
1) find duplication

```
SELECT Email 
FROM Person
GROUP BY Email
HAVING COUNT(Email)>1
```

2) find distinct item in two table (Content and TVProgram)

```SELECT DISTINCT title 
FROM Content
LEFT JOIN TVProgram
USING(content_id)
WHERE content_type = ‘Movies’
AND Kids_content = “Y”
AND LEFT(program_date,7) = ‘2020–06’
```

### Self-Join
```SELECT e1.name AS Employee
FROM Employee e1
LEFT JOIN Employee e2
ON e1.ManagerId = e2.Id
WHERE e1.Salary > e2.Salary
```

### Subquery
```SELECT DISTINCT project_id
FROM Project
GROUP BY project_id
HAVING COUNT(employee_id) = (
                            SELECT COUNT(employee_id) AS count_num
                            FROM Project 
                            GROUP BY project_id
                            ORDER BY count_num DESC
                            LIMIT 1
                            )
```
### WITH() creates a temporary table
```WITH Sub_query AS (
                  SELECT project_id, COUNT(*) AS cnt 
                  FROM Project
                  GROUP BY project_id
)
SELECT project_id 
FROM Sub_query
WHERE cnt = (
            SELECT MAX(cnt)
            FROM Sub_query
)
```




