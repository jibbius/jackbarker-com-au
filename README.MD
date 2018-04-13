# The source code for jackbarker.com.au
[![Build Status](https://travis-ci.org/jibbius/jackbarker-com-au.svg?branch=gh-pages)](https://travis-ci.org/jibbius/jackbarker-com-au)

## Pre-requisites:

- Ruby ( >= v2.0.0 , < 2.5 )
- Python ( v2.7.x )

In Windows, you can install the Chocolatey package manager (and subsequently, Ruby + Python2), via the following Powershell command (must be run with Administrator privileges):

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Then:

    choco install ruby --version 2.4.3.1
    choco install Python2

## Installation:

- Execute: `gem install bundler`
- Execute: `bundle install`
- Execute: `bundle update` (also run to update Jekyll where required)

## Troubleshooting installation
If confronted with the following error in when attempting to run `bundle install` PowerShell, *MSYS2 could not be found. Please run 'ridk install'*, then:
- Execute: `Set-ExecutionPolicy -Scope CurrentUser`
- Specify: `remotesigned`, and select `[A] Yes to All`
- Execute: `ridk install`

## Run locally:

- Execute: `bundler exec jekyll serve` (or `bundler exec jekyll serve -D` to include 'Draft' content)
- Preview your local Jekyll site in your web browser at [localhost:4000](http://localhost:4000).


## Live reload support (not supported by Windows... yet?):

- Install Livereload plugin for Chrome
- Execute: `bundler exec guard`

## LiveReloadX (including Windows support):

 - Install node from command prompt (w/ admin privileges): `choco install nodejs`
 - Reopen command prompt
 - Run: `npm install -g livereloadx`
 - Install the applicable [Browser Extension](http://livereload.com/extensions/)

 Once installed, run the following command in the project directory:

 - `livereloadx _site`

Further command line options are described within the [LiveReloadX documentation](http://nitoyon.github.io/livereloadx/).

## Installing drafts:

- Add bitbucket credentials
- `git clone git@bitbucket.org:jack_barker/jackbarker-com-au_drafts.git _drafts`

## Test suite

- `bundle exec htmlproofer ./_site --only-4xx --check-favicon --check-html --check-opengraph --assume-extension`

## Spell checker

- `bundle exec yaspeller ./_site/**/*.html --ignore-urls`

## Image compile
Requires bash shell and imagemagick.

To install imagemagick within WSL (Windows Subsystem for Linux):

    sudo apt-get update
    sudo apt-get install -y build-essential checkinstall
    sudo apt-get install -y imagemagick libmagickcore-dev libmagickwand-dev libmagic-dev
    cd
    wget https://www.imagemagick.org/download/ImageMagick.tar.gz
    tar xvzf ImageMagick.tar.gz
    cd ImageMagick-*
    ./configure
    make clean
    make
    sudo make install
    sudo ldconfig /usr/local/lib

Then, to compile images:

    cd /mnt/c/.../jackbarker-com-au/images
    ./build_images.sh

## Emoji
Supported Markdown / Github emoji, is listed [here](https://gist.github.com/rxaviers/7360908).