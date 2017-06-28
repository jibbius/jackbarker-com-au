# The source code for jackbarker.com.au
[![Build Status](https://travis-ci.org/jibbius/jackbarker-com-au.svg?branch=gh-pages)](https://travis-ci.org/jibbius/jackbarker-com-au)

## Pre-requisites:

- Ruby (v2.0.0 or higher)

## Installation:

- Execute: `bundle install`
- Execute: `bundle update` (also run to update Jekyll where required)


## Run locally:

- Execute: `bundle exec jekyll serve` (or `bundle exec jekyll serve -D` to include 'Draft' content)
- Preview your local Jekyll site in your web browser at [localhost:4000](http://localhost:4000).


## Live reload support (not supported by Windows... yet?):

- Install Livereload plugin for Chrome
- Execute: `guard`

## Installing drafts:

- `git clone git@bitbucket.org:jack_barker/jackbarker-com-au_drafts.git _drafts`

## Test suite

- `bundle exec htmlproofer ./_site --only-4xx --check-favicon --check-html --check-opengraph --assume-extension`