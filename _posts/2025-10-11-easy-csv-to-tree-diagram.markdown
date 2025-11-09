---
layout: post
title:  "Converting a spreadsheet into an interactive tree diagram"
desc:   "A quick solution using D3.js"
author: Jack Barker
tags:   [ javascript, data, data visualisation, shell scripting, d3js, csv ]
include_d3_js: true
date: 2025-11-10
img: "/2025/d3js_howto"
img-ext: ".jpg"
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

(Click on the "Address" node, and watch the diagram collapse)

{% include d3js_tree_diagram.html %}

I wanted to use Excel because this made for easy collaboration with other users (technical and non-technical).

Once all the data had been entered into Excel, anybody on the team could run the script, and produce the resultant diagram.

## Solution
After a bunch of Googling (and visits to Stack Overflow), I finally cobbled together a quick VB script (inspired by [Mike Bostok](https://bl.ocks.org/mbostock/4339083){:target="_blank"}) that would accept my file and then output the necessary html and javascript.

Feel free to [try it out yourself](https://github.com/jibbius/D3js_ExcelToDiagram){:target="_blank"}:

{% include hero-image.html
    img="/2025/d3js_howto"
    ext=".jpg"
    alt="Interactive CSV to Tree Diagram conversion workflow showing Excel/CSV input transforming into beautiful D3.js visualizations"
    caption="Complete workflow: CSV data → Cross-platform processing → Interactive tree visualizations"
%}

