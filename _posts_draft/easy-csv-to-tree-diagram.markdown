---
layout: post
title:  "Converting a spreadsheet into an interactive tree diagram"
desc:   "D3.js and shell scripting!"
author: Jack Barker
tags:   [ javascript, data, data visualisation, shell scripting ]
include_d3_js: true
date: 2025-01-01
draft: true
---

## Background
A little while ago, I worked on a project that would let me create a tree diagram, based on the contents of an Excel file.

I wanted to build the diagram using an Excel file that I already had.

The Excel file looked like this:

| Parent node   | Child node     |
|---------------|----------------|
|               | Customer       |
| Customer      | Customer ID    |
| Customer      | Given name     |
| Customer      | Surname        |
| Customer      | Address        |
| Address       | Street Number  |
| Address       | Street Name    |
| Address       | State          |
| Address       | Suburb         |
| Customer      | Account        |
| Account       | Account ID     |
| Account       | Account Type   |

**Here is my resultant D3.js Tree Diagram:**
{% include d3js_tree_diagram.html %}

I wanted to use Excel because this made for easy collaboration with other users (technical and non-technical).

Once all the data had been entered into Excel, anybody on the team could run the script, and produce the resultant diagram.

## Solution
After a bunch of Googling (and visits to Stack Overflow), I finally [cobbled together a quick VB script](https://github.com/jibbius/D3js_ExcelToDiagram){:target="_blank"} (inspired by [Mike Bostok](https://bl.ocks.org/mbostock/4339083){:target="_blank"}) that would accept my file and then churn out the necessary javascript:

    //TODO: Insert Javascript

Perfect.

## Time for a new challenge!
The solution worked great for the above application, however I'd like to take this idea and make  the following enhancements;

#### Feature 1: It should be cross-platform.
- The script should run on **OSX**, or **Linux**, or **Windows**.
- Because of this change the script may need to take a .csv files as input (rather than .xlsx)

#### Feature 2: It should work with some other data visualisation libraries.
- I'd like to also try some different data visualisation libraries, so as to get an understanding of their complexity. 