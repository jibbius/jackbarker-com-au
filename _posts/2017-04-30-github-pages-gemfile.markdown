---
layout: post
title:  "My Github Pages Gemfile"
desc:   "How to ensure the local environment uses Github versions, even when offline"
date:   2017-04-30
author: Jack Barker
tags:   [ Jekyll, Github Pages, hacks ]
image: "/images/2017/gemfile-300x254.jpg"
image-srcset: "
/images/2017/gemfile-300x162.jpg 300w,
/images/2017/gemfile-600x325.jpg 600w,
/images/2017/gemfile-800x433.jpg 800w,
/images/2017/gemfile-1000x542.jpg 1003w
"
---

## The Problem
When you run a (Jekyll) GitHub pages site locally, how do you ensure that you are using the same plugins + versions as will be used on GitHub?

Further - what happens if you don't have internet access, and can't check what versions Github is currently using?

## The Solution
### Part A: Using GitHub versions locally
Solving the first part of this problem was relatively straightforward;

{% highlight ruby %}
#Gemfile
source 'https://rubygems.org'
require 'json'

#Check what plugin versions GitHub is using:
github_versions_url = 'https://pages.github.com/versions.json'
versions = JSON.parse(open(github_versions_url).read)
 
#Load the same plugin versions locally:
gem 'github-pages', versions['github-pages']
 
{% endhighlight %}
The above (when internet access is available) shall check to see what plugin versions GitHub is using.

Perfect.

This means that when I run my Jekyll site locally, it will behave exactly in the same way as when Github builds my site.

Except - what happens when I take my dev environment on the road, and I can't connect to the internet?

### Part B: Dealing with internet connectivity issues
#### Checking for internet connectivity

Solving this part, was thanks to [fotanus's post on Stackoverflow][fotanus]{:target="_blank"}.

This caused me to include the following function within my Gemfile:

{% highlight ruby %}
#Function to check if can access a url (i.e. github)
require 'open-uri'
require 'active_support'
require 'active_support/core_ext'

def url_exist?(url_string)
  url = URI.parse(url_string)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = (url.scheme == 'https')
  path = url.path if url.path.present?
  res = req.request_head(path || '/')
  if res.kind_of?(Net::HTTPRedirection)
    url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
  else
    ! %W(4 5).include?(res.code[0]) # Not from 4xx or 5xx families
  end
rescue
  false #false if can't find the server
end
{% endhighlight %}

#### Reverting to local cache when connectivity is unavailable

However I still needed to write some logic to:
1. "Cache" the versions page (when internet connectivity exists)
1. Fall back to this cache when internet connectivity does not exist

In order to "cache" this information, I simply store a 'versions.json' in the project root.
The file gets updated whenever GitHub's version becomes changed.

That code looks like this:

{% highlight ruby %}
github_versions_url = 'https://pages.github.com/versions.json'
local_versions_path  = 'versions.json'

if url_exist?(github_versions_url)
    puts "***************************************"
    puts "ACCESSING GITHUB PAGES PACKAGE VERSIONS"
    puts "***************************************"
    download = open(github_versions_url)
    IO.copy_stream(download, local_versions_path)
    versions = JSON.parse(open(github_versions_url).read)
else
    # If offline will need to use cached local version (below), instead.
    puts "************"
    puts "OFFLINE MODE"
    puts "************"
    versions = JSON.parse(open(local_versions_path).read)
end

gem 'github-pages', versions['github-pages']
{% endhighlight %}

Note that I also included some printed output, so that when I run `jekyll serve` I am advised whether internet connectivity was able to be established.

## Finised Gemfile
The completed Gemfile:
{% highlight ruby %}
#Gemfile
source 'https://rubygems.org'
require 'json'
require 'open-uri'
require 'active_support'
require 'active_support/core_ext'

#Function to check if can access a url (i.e. github)
require "net/http"
def url_exist?(url_string)
  url = URI.parse(url_string)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = (url.scheme == 'https')
  path = url.path if url.path.present?
  res = req.request_head(path || '/')
  if res.kind_of?(Net::HTTPRedirection)
    url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
  else
    ! %W(4 5).include?(res.code[0]) # Not from 4xx or 5xx families
  end
rescue
  false #false if can't find the server
end

github_versions_url = 'https://pages.github.com/versions.json'
local_versions_path  = 'versions.json'

if url_exist?(github_versions_url)
    puts "***************************************"
    puts "ACCESSING GITHUB PAGES PACKAGE VERSIONS"
    puts "***************************************"
    download = open(github_versions_url)
    IO.copy_stream(download, local_versions_path)
    versions = JSON.parse(open(github_versions_url).read)
else
    # If offline will need to use cached local version (below), instead.
    puts "************"
    puts "OFFLINE MODE"
    puts "************"
    versions = JSON.parse(open(local_versions_path).read)
end

# This is the default theme for new Jekyll sites.
gem "minima" # https://github.com/jekyll/minima

# Load github pages gem
gem 'github-pages', versions['github-pages']

# Plugins for local livereload.
gem 'guard'
gem 'guard-jekyll-plus'
gem 'guard-livereload'
{% endhighlight %}


[fotanus]: http://stackoverflow.com/a/18582395 "fotanus on Stackoverflowu"
