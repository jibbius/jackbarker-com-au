---
layout: default
#title: Tags
permalink: /tags/
---

<h2>Tags</h2>

{% comment %}
# Get all tags in site.
{% endcomment %} 
{% capture tags %}
  {% for tag in site.tags %}|{{ tag[0] }}{% endfor %}
{% endcapture %}

{% comment %}
# Sort alphabetically.
# Unfortunately we need to convert all tags to lowercase to do this
# (Without doing this, result would be: A, D, G, a, b, c).
{% endcomment %}
{% assign sortedtagslower = tags | normalize_whitespace | downcase | split:'|' | uniq | sort %}

{% comment %}
# This loop then uses the array above to construct the array we actually want
# (i.e. A, a, b, c, D, G)
{% endcomment %}
{% capture tags2 %}
  {% for tag1 in sortedtagslower %}{% for tag in site.tags %}{% assign tag2 = tag[0] | downcase %}{% if tag1 == tag2 %}|{{ tag[0] }}{% endif %}{% endfor %}{% endfor %}
{% endcapture %}
{% assign sortedtags = tags2 | normalize_whitespace | split:'|' %}

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