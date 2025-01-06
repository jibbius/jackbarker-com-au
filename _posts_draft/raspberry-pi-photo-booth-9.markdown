---
layout: post
title:  "How to build a Photo Booth (Part 9: Post production)"
permalink: /photo-booth/9
date:   2017-04-26
author: Jack Barker
tags:   [ Raspberry Pi , hacks ]
draft: true

---

1. Listing out the requirements
1. Getting started with Pi and PiCamera
1. Building the Booth
1. Adding the 12volt Lights / Flash (Optional)
1. Writing the app
1. Adding a Power button
1. Adding a Printer (Optional)
1. Photo day!
1. Post-production

## Post production
The steps below assume that you want to publish your photos to a website of your choice.
Depending upon how you want to distribute your photos, you may decide to skip some of the steps below.


## Step 0
Fork my github repository?

## Adjust image brightness levels (if required)
#TODO
(if you prefer, you can also do this via ImageMagic)

(Note to self - this may be easier to write about, rather than Photoshop...etc.)


## Install ImageMagic

{% highlight bash %}
#TODO
{% endhighlight %}

## Create thumbnails (animated gifs) with ImageMagic

{% highlight bash %}
#script1.sh
prev_filename_no_inc=""

for jpg_file in ./full-res-images/*.jpg;
do
    filename_no_ext="${jpg_file%.*}" # Example: 2017-04-15_15-07-08_1
    filename_no_inc="${filename_no_ext::${#filename_no_ext}-2}" # Example: 2017-04-15_15-07-08
    
    if [ "${prev_filename_no_inc}" != "${filename_no_inc}" ]; then
        echo "Processing: "${filename_no_inc}

        #Compression with ImageMagick
        GM convert -quality 50% -delay 100 -resize 200x120 ${filename_no_inc}*.jpg ${filename_no_inc}.gif

        #Don't double process any images
        prev_filename_no_inc=${filename_no_inc}
    fi
done
{% endhighlight %}

## Create website
The script above will result in the following directory structure;


## Preview the website
The script above will result in the following directory structure;


## ...TODO