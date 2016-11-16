@echo off
REM This file starts the server, and launches an
REM internet browser directed at the appropriate URL

set server=localhost
set port=4000

start http://%server%:%port%
start bundle exec jekyll serve -D
start bundle exec guard