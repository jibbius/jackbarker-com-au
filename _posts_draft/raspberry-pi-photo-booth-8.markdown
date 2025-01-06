---
layout: post
title:  "How to build a Photo Booth (Part 8: Post production)"
desc:  "Converting your photos into a website."
permalink: /photo-booth/8
author: Jack Barker
tags:   [ Raspberry Pi, hacks, shell scripting ]
draft: true

---
{% include multi-post-photo-booth.html part=8 %}

## Post production
The steps below assume that you want to publish your photos to a website of your choice.
Depending upon how you want to distribute your photos, you may decide to skip some of the steps below.

### Colour Correction
{%include todo.html todo="how do I do this on a Pi?" %}

### Image Compression
{%include todo.html todo="how do I do this on a Pi?" %}

## Distribution
### via Dropbox
Installing Dropbox on Raspberry Pi is somewhat convoluted.

You can follow the steps here: https://www.raspberrypi.org/magpi/dropbox-raspberry-pi/

To install dropbox uploader;

    git clone github.com/andreafabrizi/Dropbox-Uploader.git
    cd Dropbox-Uploader
    ./dropbox_uploader.sh

You can create a Developer API key, there are the follwoing additional steps:

https://www.dropbox.com/developers/apps


### via Google Drive

### via GitHub Pages

## Other thoughts:

1. Listing out the requirements
1. Getting started with Pi and PiCamera
1. Building the Booth
1. Adding the 12volt Lights / Flash (Optional)
1. Writing the app
1. Adding a Power button
1. Adding a Printer (Optional)
1. Photo day!
1. Post-production
