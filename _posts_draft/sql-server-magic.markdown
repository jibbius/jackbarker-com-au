---
layout: post
title:  "SQL Server Magic"
desc: "A summary of unique and useful functions available on Microsoft SQL Server 2017"
author: Jack Barker
tags: [ SQL Server ]
draft: true
---

## About this post

If you've used other relational databases (MySQL, PostGres, DB2, perhaps even Access?) then you'll like find that the core syntax is pretty interchangable.
A quick `SELECT * FROM table_name`, and Bob's your auntie!

With that being said, however, SQL Server has a boatload of additional functions that you can't always get from other platforms... or alternatively, requires a unique syntax.

Here's a summary of these functions, with examples, to help you on your journey.


## Temp Tables

I'm starting this post with "Temp Tables" purely because so many of the examples I'll be demonstrating require a bit of data to get started.

Temp tables allow us to store data for the duration of our connected session. This data won't be accessible to other users.

# IF EXISTS

## Calculated columns

## Variables

Another

# WITH (Sub-queries)
Temp tables do have benefits, and some limitations.
A similar command is `WITH` which allows us to chain together multiple queries, for a similar effect.

Sometimes, we need to get all data in a single request to the server. At other times, perhaps we just don't want to bother with storing the temp table data.

(Note that there can be significant performance differences between `WITH` and the use of `TEMP TABLES`. Dependant upon the operation either may outperform the other. Table variables can also be a viable option)

## Using PARTITIONS for subtotals

## Using PARTITIONS to compare adjacent rows
### FIRST, LAST, LEAD and LAG

## The power of DATETIME and common traps
### CONVERT and TRY_CONVERT

### Calculating Age based on a Date of Birth

### Calculating "2 business days later"
A problem that emerges in financial services, is the calculation of a trade's settlement date.
Typically when a trade intiated on the market; settlement occurs 2 days later.
Further complicating matters;
 - We only count "business days"
 - This means we need to exclude i] Weekends, and ii] Public holidays
 - If the trade is requested after the market has closed, then we will need to wait till the market opens again (thus, adding an additional day)
To solve this challenge, let us assume that we have a set of "Public Holidays" stored as dates in a table.

## COALESCE and NULLIF
