source 'https://rubygems.org'
#ruby RUBY_VERSION
require 'json'
require 'open-uri'


# versions = JSON.parse(open('versions.json').read)
# If offline will need to use cached local version (above)

versions = JSON.parse(open('https://pages.github.com/versions.json').read)

# Hello! This is where you manage which Jekyll version is used to run.
# When you want to use a different version, change it below, save the
# file and run `bundle install`. Run Jekyll with `bundle exec`, like so:
#
#     bundle exec jekyll serve
#
# This will help ensure the proper Jekyll version is running.
# Happy Jekylling!
# gem "jekyll", "3.2.1"

# This is the default theme for new Jekyll sites. You may change this to anything you like.
gem "minima"

# If you want to use GitHub Pages, remove the "gem "jekyll"" above and
# uncomment the line below. To upgrade, run `bundle update github-pages`.
# gem 'github-pages', group: :jekyll_plugins
gem 'github-pages', versions['github-pages']

# If you have any plugins, put them here!
group :jekyll_plugins do

end

gem 'guard'
gem 'guard-jekyll-plus'
gem 'guard-livereload'

#gem 'kramdown', versions['kramdown']
#gem 'rake'