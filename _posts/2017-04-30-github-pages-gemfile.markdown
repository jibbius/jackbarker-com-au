---
layout: post
title:  "Working Offline with Github Pages"
desc:   "How to tailor your Gemfile, to ensure your local Jekyll environment uses Github Pages' plugin versions even when offline."
date:   2017-04-30
last-modified: 2017-05-03
author: Jack Barker
tags:   [ Jekyll, Github Pages, hacks ]
image: "/images/2017/gemfile-300x254.jpg"
image-srcset: "
/images/2017/gemfile-300x162.jpg 300w,
/images/2017/gemfile-600x325.jpg 600w,
/images/2017/gemfile-800x433.jpg 800w,
/images/2017/gemfile-1000x542.jpg 1000w
"
thumbnail-image: "/images/2017/gemfile2-crop-300x300.jpg"
banner-image: "/images/2017/gemfile2-crop-600x314.jpg"
---

{%include update.html
heading="Update - 3 May 2017"
text="Whilst the below is a novel solution to this problem, I have since found a far simpler solution (discussed at the end of the article). I am still undecided as to which solution is <strong>truly superior</strong>, however.
Have a read and judge for yourself?"
%}

## The Problem
When you run a (Jekyll) GitHub pages site locally, how do you ensure that you are using the same gems (plugins) and versions as will be used on GitHub?

Further - what happens if you don't have internet access, and can't check what versions Github is currently using?

## <s>The</s> <em>[edit: A Potential]</em> Solution

### Part A: Using GitHub's versions locally
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

Solving this part, first happened after I read [fotanus's post on Stackoverflow][fotanus]{:target="_blank"}.

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

### Finished Gemfile
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
local_versions_path = 'versions.json'

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

# Load github pages gem
gem 'github-pages', versions['github-pages']

# Plugins for local livereload.
gem 'guard'
gem 'guard-jekyll-plus'
gem 'guard-livereload'
{% endhighlight %}

## An even simpler solution?
{%include update.html
heading="Update - 3 May 2017"
text="Per earlier comment, I came across this simpler solution after posting the original article."
%}
It's actually possible to completely ignore this entire post, and instead make sure that you are running Jekyll via: `bundle exec jekyll serve` instead of `jekyll serve`.

But, you also need to make sure that you are:
1. running `bundle update` at regular intervals, and
1. checking `Gemfile.lock` into source control.

A detailed explanation of this, can be found here: [bundler.io/rationale][bundler-rationale]{:target="_blank"}.

## Which solution should you use?

Interestingly, the two solutions work in a very similar same way, ie;
 - Both solutions write a file to the project directory (versions.json / Gemfile.lock), listing out the gem versions that were utilised within the previous successful build.
 - The files even look loosely the same:

{% include image.html
    url="/images/2017/compare-versions-json-gemfile-lock-600x594.jpg"
    srcset="
    /images/2017/compare-versions-json-gemfile-lock-600x594.jpg 600w,
    /images/2017/compare-versions-json-gemfile-lock-800x792.jpg 800w,
    /images/2017/compare-versions-json-gemfile-lock-1000x990.jpg 1000w"
    alt="Gemfile.lock versus Versions.json"
    caption="<strong>Gemfile.lock</strong> versus <strong>Versions.json</strong>"
    width="600px"
%}

As I alluded to at the start of the article; the `bundler` solution **is** somewhat simpler and clearly more widely recognised. It also tracks changes to your local environment's other Jekyll dependencies. For these reasons it is currently the solution I would recommend.

That said; `bundler` does require you to run `bundle update` (and you must remember to do this regularly), whereas my **custom** _(read as: "proceed with caution"_) solution doesn't require you to do this. For this reason, I'm leaving this post here as food for thought.

Comments (constructive) are welcome :smile:.



[fotanus]: http://stackoverflow.com/a/18582395 "fotanus on Stackoverflow"
[bundler-rationale]: http://bundler.io/rationale.html "bundler.io/rationale"
