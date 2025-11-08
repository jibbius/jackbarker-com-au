---
layout: default
title: Tags
desc: Blog posts and portfolio projects organized by tags
permalink: /tags/
adverts: disable
---

<h2>Tags</h2>

{% comment %}
# Get all tags from both blog posts and portfolio projects
{% endcomment %} 
{% capture tags %}
  {% for tag in site.tags %}|{{ tag[0] }}{% endfor %}
  {% for project in site.portfolio %}
    {% for tag in project.tags %}|{{ tag }}{% endfor %}
  {% endfor %}
{% endcapture %}

{% comment %}
# Sort alphabetically.
# Unfortunately we need to convert all tags to lowercase to do this
# (Without doing this, result would be: A, D, G, a, b, c).
{% endcomment %}
{% assign sortedTagsLower = tags | normalize_whitespace | downcase | split:'|' | uniq | sort %}

{% comment %}
# This loop then uses the array above to construct the array we actually want
# (i.e. A, a, b, c, D, G)
# Check both blog post tags and portfolio project tags
{% endcomment %}
{% capture tags2 %}
  {% for tag1 in sortedTagsLower %}
    {% assign found = false %}
    {% comment %}Check blog post tags first{% endcomment %}
    {% for blog_tag in site.tags %}
      {% assign tag2 = blog_tag[0] | downcase %}
      {% if tag1 == tag2 and found == false %}
        |{{ blog_tag[0] }}
        {% assign found = true %}
      {% endif %}
    {% endfor %}
    {% comment %}If not found in blog tags, check portfolio tags{% endcomment %}
    {% if found == false %}
      {% for project in site.portfolio %}
        {% for portfolio_tag in project.tags %}
          {% assign tag2 = portfolio_tag | downcase %}
          {% if tag1 == tag2 and found == false %}
            |{{ portfolio_tag }}
            {% assign found = true %}
          {% endif %}
        {% endfor %}
      {% endfor %}
    {% endif %}
  {% endfor %}
{% endcapture %}
{% assign sortedTagsRaw = tags2 | normalize_whitespace | split:'|' %}
{% assign sortedTags = sortedTagsRaw | where_exp: "tag", "tag != ''" %}

<div class="tags-expo">

  <div class="tags-expo-list">
    {% for tag in sortedTags %}
      <a href="#{{ tag | slugify }}" class="post-tag">{{ tag }}</a>
    {% endfor %}
  </div>

  <hr/>

  <div class="tags-expo-section">
    {% for tag in sortedTags %}
    {% assign clean_tag = tag | strip %}
    <h2 id="{{ clean_tag | slugify }}">{{ clean_tag }}</h2>
    
    {% comment %}
    # Get blog posts with this tag
    {% endcomment %}
    {% assign tag_posts = site.tags[clean_tag] %}
    
    {% comment %}
    # Get portfolio projects with this tag
    {% endcomment %}
    {% assign tag_projects = site.portfolio | where_exp: "project", "project.tags contains clean_tag" %}
    
    {% if tag_posts.size > 0 or tag_projects.size > 0 %}
    <ul class="tags-expo-posts">
      
      {% comment %}
      # Display portfolio projects first
      {% endcomment %}
      {% for project in tag_projects %}
        <a class="tag-post-link portfolio-project"
        href="{{ site.baseurl }}{{ project.url }}"
        title="{{ project.title | escape }}{% if project.desc %}{% include linebreak.html %}{{ project.desc }}{% endif %}">
        <li {% if project.draft == true %}class="draft-post"{% else %}class="portfolio-item"{% endif %}>
          <span class="tag-post-title">{{ project.title }}</span>
          <small class="tag-post-date tag-post-type">(Portfolio Project)</small>
        </li>
        </a>
      {% endfor %}
      
      {% comment %}
      # Display blog posts
      {% endcomment %}
      {% for post in tag_posts %}
        <a class="tag-post-link blog-post"
        href="{{ site.baseurl }}{{ post.url }}"
        title="{{ post.title | escape }}{% if post.desc %}{% include linebreak.html %}{{ post.desc }}{% endif %}">
        <li {% if post.draft == true %}class="draft-post"{% else %}class="published-post"{% endif %}>
          <span class="tag-post-title">{{ post.title }}</span>
          <small class="tag-post-date">( {{ post.date | date_to_string }} )</small>
        </li>
        </a>
      {% endfor %}
    </ul>
    {% endif %}
    {% endfor %}
  </div>
</div>