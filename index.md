---
layout: home
title: Welcome
permalink: /
exclude_from_nav: true
---

Hi there!

Welcome to Jack Barker's personal blog.


<h2>Latest Posts</h2>
<ul class="post-list">
  {% for post in site.posts %}
    
   <li {% if post.draft == true %}class="draft-post"{% endif %}>
        <span class="post-meta">
            {{ post.date | date: "%b %-d, %Y" }}
        </span>
        <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">
            <h2 class="post-title">{{ post.title | escape }}</h2>
        </a>
        {% if post.desc %}
            <h3 class="post-subtitle">{{ post.desc }}</h3>
        {% endif %}
    </li>
  {% endfor %}
</ul>

<p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS</a></p>
