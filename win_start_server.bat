@echo off
REM This file starts the server, and launches an
REM internet browser directed at the appropriate URL

set server=localhost
set port=4000

REM ------------
REM Start Jekyll
REM ------------
start bundle exec jekyll serve -D

REM -----------------------------------------------
REM Live-reload is not supported for windows (yet).
REM -----------------------------------------------
REM start bundle exec guard

REM ------------
REM Open Browser
REM ------------
start http://%server%:%port%
