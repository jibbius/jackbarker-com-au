---
layout: page
permalink: /blog/
title: Blog
---

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