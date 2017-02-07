@echo off
REM This file starts the server, and launches an
REM internet browser directed at the appropriate URL

set server=localhost
set port=4000

REM ------------
REM Start Jekyll
REM ------------
SET BUNDLE_GEMFILE=Gemfile_Offline
start bundle exec jekyll serve -D

REM ------------
REM Open Browser
REM ------------
start http://%server%:%port%
