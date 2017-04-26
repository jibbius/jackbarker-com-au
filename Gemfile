source 'https://rubygems.org'
#ruby RUBY_VERSION
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

github_url = 'http://github.com'
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
gem 'github-pages', versions['github-pages']

# If you have any plugins, put them here!
group :jekyll_plugins do
end

gem 'guard'
gem 'guard-jekyll-plus'
gem 'guard-livereload'

#gem 'kramdown', versions['kramdown']
#gem 'rake'