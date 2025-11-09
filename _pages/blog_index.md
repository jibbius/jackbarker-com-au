---
layout: page
permalink: /blog/
title: Blog
nav_title: Blog
adverts: disable
---


<div class="blog-roll">

    {% if site.show_drafts %}
    <h2>Drafts</h2>
    {% include post-list.html status="draftsonly" format="shortform" include_children=true %}
    {% endif %}

    <h2>Latest Posts</h2>
    {% include post-list-grid.html stagger="true" status="published" include_children=true %}
</div>