---
layout: page
title: Welcome
permalink: /
exclude_from_nav: true
---

Hey there!

Welcome to Jack Barker's personal blog.


<h2>Latest Posts</h2>
<ul class="post-list">
  {% for post in site.posts %}
    
   <li {% if post.draft == true %}class="draft-post"{% endif %}>
      <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</span>
      <h2>
        <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">{{ post.title | escape }}</a>
      </h2>
    </li>
  {% endfor %}
</ul>

<p class="rss-subscribe">subscribe <a href="{{ "/feed.xml" | prepend: site.baseurl }}">via RSS</a></p>