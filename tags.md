---
layout: page
title: Tags
---


{% capture tags %}
  {% for tag in site.tags %}|{{ tag[0] }}{% endfor %}
{% endcapture %}
{% assign sortedtags = tags | normalize_whitespace | split:'|' | sort %}

<div class="tags-expo">

  <div class="tags-expo-list">
    {% for tag in sortedtags %}
      {% if tag != '' %}
      <a href="#{{ tag | slugify }}" class="post-tag">{{ tag }}</a>
      {% endif %}
    {% endfor %}
  </div>

  <hr/>

  <div class="tags-expo-section">
    {% for tag in sortedtags %}
    <h2 id="{{ tag | slugify }}">{{ tag }}</h2>
    <ul class="tags-expo-posts">
      {% for post in site.tags[tag] %}
        <a href="{{ site.baseurl }}{{ post.url }}">
      <li>
        {{ post.title }}
      <small class="post-date">( {{ post.date | date_to_string }} )</small>
      </li>
      </a>
      {% endfor %}
    </ul>
    {% endfor %}
  </div>
</div>