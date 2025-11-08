---
layout: post
title:  "Photo Booth (Part 8): Post production"
desc:  "Converting your photos into a website."
permalink: /photo-booth/8
author: Jack Barker
tags:   [ Raspberry Pi, hacks, Python ]
date: 2017-40-17
img: "/2018/post_production"
img-ext: ".jpg"
---
{% include multi-post-photo-booth.html part=8 %}

(A quick thank you to everyone who waited so patiently for this post to come out.
It's been a journey to get this working "just right", so I hope you like it!)

## A new "photo processing" application
In parts 1 through 7, we built a photo booth that is able to **save photos** and **store them on the Raspberry Pi's SD card**.

In this, part 8, we'll be looking to achieve the following:
1. Write a new "photo processing" application, that we can run alongside our "photo booth" application.
2. Our photo processing application will be configured to:
 - improve image brightness,
 - apply some image compression,
 - create animated gifs,
 - create a "photo strip" layout,
 - ( and if you're keen to do some further coding, you can add even more functionality if you like :wink: ).
2. Upload our images to Dropbox

## Why  a separate application?
I wanted a photo uploading solution that gives people the flexibility to choose how their photos get processed, published, shared;

 - Not everyone will want to publish their photo booth online.
 - Not everyone will want to publish their photos in the same way.

For this reason, my "photo publishing" is going to be a separate application which sits adjacent to the photo booth application.

The applications can either be run **simultaneously** (Photos will be captured, and uploaded, during the photo booth event), or at different times (i.e. "Photo booth" application can be run during a daytime event and the "Photo processing" application can be run afterwards). The latter option might be more suitable if you don't have internet access available.

When the photo publishing application is running, it will routinely check our photo directory to determine if any new photos have been saved, and will then execute the applicable logic.

## Additional things to install
Let's install some additional apps onto our Raspberry Pi to help us with the tasks I've listed above;

{% highlight bash %}

    # Imagemagick will help us fine tune our images:
    sudo apt-get update
    sudo apt-get install imagemagick libmagickcore-dev libmagickwand-dev libmagic-dev build-essential -y
    cd
    wget https://www.imagemagick.org/download/ImageMagick.tar.gz
    tar xvzf ImageMagick.tar.gz
    cd ImageMagick-*
    ./configure
    make clean
    make
    sudo make install
    sudo ldconfig /usr/local/lib

    # This python library will help us upload our images to Dropbox:
    pip install dropbox

    # Or, if using Python 3 instead:
    python3 -m pip install dropbox

{% endhighlight %}

TODO: Also install YAML support

## Obtaining the code
The code for the application is available as of version 2.1 of the Photo Booth (April 2018).

The file is: `postproduction.py`

If you are using an older version of the photo booth code, and want to upgrade to the latest version, the following commands should allow you to do that:
{% highlight sh %}
cd ~/photo-booth
git clone https://github.com/jibbius/raspberry_pi_photo_booth.git ~/photo-booth
{% endhighlight %}

TODO: Fix the above; clone is not the correct command.

Alternatively, you can remove the previous version (remember to back up your photos first), and then reinstall the application per [Part 5](/photo-booth/5) of this series.

## What does the code do?
The first time the code is run, a file is created called "".

This file contains a number of configuration options/settings that you might want to modify as part of customising your photo booth.

If you make a mistake, there is an example configuration file here:

TODO: Can I embed a config file here?

### Step 1: Reads a config file

### Step 2: Creates folders if they don't exist

### Step 3: Validates Dropbox credentials
By default, I've disabled Dropbox.
In order to enable Dropbox uploads, we need to do some additional setup which I've described below.

### Step 2: Monitors "input" folder for new files


### Step 3: Monitors "input" folder for new files

### Step 3: Monitors "input" folder for new files


Consider the following:

    import os, time
    path_to_watch = "/home/pi/photo-booth/photos/"
    while True:
    print('---------------')
    file_groups = array()
    
    for f in os.listdir(path_to_watch):
        filename = os.path.splitext(f)[0]
        ext = os.path.splitext(f)[1]
        if(filename.count('_') == 2 and ext == '.jpg'):
            #Filename matches our expected format;
            #(e.g. 2018-04-11_15-39-29_1of4.jpg )

            #Break filename into it's respective components:
            date_stamp,time_stamp,x_of_y=filename.split('_')
            x,y=x_of_y.split('of')
            file_group_id = date_stamp + '_' + time_stamp
            print(file_group_id + ' [' + x +'] of ['+ y + ']')
            
    time.sleep(5)

### Step 2: Adjusting the image brightness

http://www.imagemagick.org/script/command-line-options.php#auto-level

### Step 3: Creating animated thumbnails

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

### Step 4: Uploading to Dropbox

### Step 5: Posting to social media with ITTT

## Create website
The script above will result in the following directory structure;


## Preview the website
The script above will result in the following directory structure;

