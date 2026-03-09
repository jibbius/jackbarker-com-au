# The source code for jackbarker.com.au

[![JavaScript Tests](https://github.com/jibbius/jackbarker-com-au/actions/workflows/js-minification-tests.yml/badge.svg)](https://github.com/jibbius/jackbarker-com-au/actions/workflows/js-minification-tests.yml)

## Pre-requisites

- Ruby (see below)

### Ruby On WSL (preferred Windows method)

1. Install RVM: <https://github.com/rvm/ubuntu_rvm#rvm-package-for-ubuntu>
1. Install the applicable version of Ruby:

    curl <https://raw.githubusercontent.com/github/pages-gem/refs/heads/master/.ruby-version> -o .ruby-version

### install rbenv + ruby-build (instructions vary; using installer)

    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-installer | bash
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"

### Use rbenv to install the required version of Ruby

    rbenv install $(< .ruby-version)

### Ruby on Windows (legacy method)

In Windows, you can install the Chocolatey package manager (and subsequently, Ruby), via the following Powershell command (must be run with Administrator privileges):

    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Then:

    choco install ruby

## Installation

- `cd` into project directory

    gem install bundler
    bundle install
    bundle update

## Troubleshooting installation

For most with error with `bundle install`; delete `Gemfile.lock` and retry.

If confronted with the following error in when attempting to run `bundle install` PowerShell, *MSYS2 could not be found. Please run 'ridk install'*, then:

- Execute: `Set-ExecutionPolicy -Scope CurrentUser`
- Specify: `remotesigned`, and select `[A] Yes to All`
- Execute: `ridk install`

Another error (`bundle install` fails to build `bigdecimal`, per: [rubygems/issues/8015](https://github.com/rubygems/rubygems/issues/8015) ):

- Execute: `sudo apt install clang`
- Execute: `export CC=/usr/bin/clang`
- Execute: `export CXX=/usr/bin/clang++`

## Run locally

- Execute: `bundler exec jekyll serve` (or `bundler exec jekyll serve -D` to include 'Draft' content)
- Preview your local Jekyll site in your web browser at [localhost:4000](http://localhost:4000).

### WSL helper (recommended)

If you are editing in WSL and viewing in a Windows browser, use:

```bash
./start_jekyll_wsl.sh
```

This helper script:
- Stops stale Jekyll processes that are already occupying the target port.
- Starts Jekyll on `0.0.0.0` with LiveReload and file polling.
- Prints both `http://localhost:4000/` and a WSL-IP fallback URL.

Optional: choose a different port (for example `4001`):

```bash
./start_jekyll_wsl.sh 4001
```

## Live reload support (not supported by Windows... yet?)

- Install Livereload plugin for Chrome
- Execute: `bundler exec guard`

## LiveReloadX (including Windows support)

- Install node from command prompt (w/ admin privileges): `choco install nodejs`
- Reopen command prompt
- Run: `npm install -g livereloadx`
- Install the applicable [Browser Extension](http://livereload.com/extensions/)

 Once installed, run the following command in the project directory:

- `livereloadx _site`

Further command line options are described within the [LiveReloadX documentation](http://nitoyon.github.io/livereloadx/).

## Installing drafts

- Add bitbucket credentials
- `git clone git@bitbucket.org:jack_barker/jackbarker-com-au_drafts.git _drafts`

## Test suite

### JavaScript Minification Tests

Our automated test suite prevents JavaScript minification issues that can break GitHub Pages deployment:

```bash
# Quick source-only test (fastest)
./test_js.sh source

# Test with drafts included
./test_js.sh drafts

# Full production test (CI mode)
./test_js.sh full
```

### HTML Validation

- `bundle exec htmlproofer ./_site --only-4xx --check-favicon --check-html --check-opengraph --assume-extension`

### Continuous Integration

The project uses GitHub Actions for automated testing:
- **JavaScript Tests**: Validates all JavaScript for minification compatibility
- **HTML Validation**: Checks links, images, and HTML structure
- **Draft Testing**: Includes draft content to catch issues before publication

Tests run automatically on:
- Push to `gh-pages`, `main`, or `master` branches  
- Pull requests to these branches
- Manual workflow triggers

### Pre-commit Hook (Optional)

To catch JavaScript issues before committing:

```bash
# Install the pre-commit hook
cp pre-commit-hook.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

This will automatically run JavaScript tests before each commit and prevent commits that would break minification.

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
