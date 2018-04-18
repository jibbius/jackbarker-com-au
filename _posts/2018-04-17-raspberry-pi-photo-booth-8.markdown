---
layout: post
title:  "Photo Booth (Part 8): Post production"
desc:  "Converting your photos into a website."
permalink: /photo-booth/8
author: Jack Barker
tags:   [ Raspberry Pi, hacks, Python ]
date: 2017-04-17
img: "/2018/post_production"
img-ext: ".jpg"
---
{% include multi-post-photo-booth.html part=8 %}

# Post-production Overview
Before I get into the detail I'd just like to say a quick **thank you** to everyone who's followed along with all the steps thus far. Also a **thanks** to those who waited so patiently for this post to come out.

It's been a journey to get this working *just right* (so I hope you like it!).

## Introducing: The "Photo Processing" application
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

# Installing and running the app
## Step 1 : Install Pre-requisisites
Let's install some additional apps onto our Raspberry Pi to help us with the tasks I've listed above.

### 1.1 : Installing ImageMagick
Imagemagick will help us fine tune our images (compression; brightness; layouts ...etc.).

We install ImageMagick from our `terminal` with the following commands:

{% highlight sh %}
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
{% endhighlight %}

We can confirm that the application installed correctly, by entering `magick -version`:
{% include image-2.html
    img="/2018/magick-version"
    ext=".jpg"
    alt="Checking the version of ImageMagick"
    class="large"
%}

### 1.2 : Installing the Dropbox Python SDK
We're also going to start interacting with Dropbox from within our Python application.

In order to do that we need to install the Dropbox Python SDK, also from the `terminal`:

{% highlight sh %}
    # This python library will help us upload our images to Dropbox:
    pip install dropbox

    # Or, if using Python 3 instead:
    python3 -m pip install dropbox
{% endhighlight %}

### 1.3 : Installing YAML parser
The configuration file for our application will be written using the YAML language.

To assist Python in being able to interpret this file, we are also going to ensure that the our YAML-parsing library is installed:

{% highlight sh %}
    # This python library will help us upload our images to Dropbox:
    pip install dropbox

    # Or, if using Python 3 instead:
    python3 -m pip install dropbox
{% endhighlight %}

## Step 2 : Installing the "Photo processing" application
As of version 2.1 of the Photo Booth (April 2018), the two applications (i.e. the 'Photo Booth' and the 'Photo Processor') are packaged together in the one download.

If you already have this verion of the code downloaded, then the file you are looking for is: `photo-post-production.py`

If you are using an older version of the photo booth code (and want to upgrade to the latest version), the following commands should allow you to do that:

{% highlight sh %}
    cd ~/photo-booth
    git clone https://github.com/jibbius/raspberry_pi_photo_booth.git ~/photo-booth
{% endhighlight %}

TODO: Fix the above; clone is not the correct command.

Alternatively (if you encounter errors), you can:

1. Remove the previous version (remember to back up your photos first), and then
2. Reinstall the application per [Part 5](/photo-booth/5) of this series.

## Step 3 : Run the application
Notice that our application now appears to be watching for files:

Also notice that we now have a set of additional folders created in our project directory:

## Step 4 : Testing the application
Now, as an experiment we can drop a set of 4 photos into `/photos-in`:

Our application will start spitting out information to us:

Finally, if we check our `/photos-out` folder, we can see a number of things have happened to our photos:
1. Each of our 4 images has been reduced in file size. The files are now 1/4 their previous size, without a noticable drop in quality.
1. The 4 images have also each been "auto-levelled" to help optimise their brightness / contrast (Note: this may only be noticable in poor lighting conditions).
1. We now have an animated "thumbnail" image, which can great for posting on the web.
1. We have a couple of "photo strip" layouts (1x4) and (2x2); which may be useful if we want to print our images.

Nice one!

## Step 5 : Configuring our application
A configuration file gets created the 1st time the application is run.

If we close our 'photo processing' application (via `Ctrl` + `\`) then we can have a look at the configuration file `post-production-config.yaml`.

All of the images that are output by the application can be enabled/disabled/customised, within this file:

## Step 6 : Dropbox Integration
By default 'Dropbox Upload' is disabled.

In order to enable Dropbox uploads we need to do some additional setup which I've described below.

### 6.1 : Get a Dropbox Account
Dropbox is an online service which helps you to "store, share, and securely access files".

If you don't have a Dropbox Account, you can signup for a free account [here](https://db.tt/v2aokyF4) (using this link will give you an extra 500Mb of storage space).

### 6.2 : Create a Dropbox App within the Developer page
After signing into your account, you need to navigate to the Developer section of the Dropbox website, and create an 'Dropbox app'.

To do this:
 - Go to the Dropbox [App Console](https://www.dropbox.com/developers/apps) page.

Click the "Create app" button:

{% include image-2.html
    img="/2018/dropbox-create-app"
    ext=".jpg"
    alt="Click the 'Create app' button"
    class="large"
%}

Specify:

 - 'Dropbox API'
 - 'App folder'
 - A name for your app (`pi-photo-booth` or whatever else you would like to use :smile:)

{% include image-2.html
    img="/2018/dropbox-create-app-form"
    ext=".jpg"
    alt="The Dropbox 'Create app' form"
    class="large"
%}

Click "Create app".

### 6.3 : Generate a API token

After recording the details of our "app" with Dropbox, we also need to create a "token".

The token is similar to a password.
It allows our Raspberry Pi's **Photo booth** app to talk to the "app" we created within Dropbox.

To generate a token, we need to click the "Generate" button, per the illustration below:

{% include image-2.html
    img="/2018/dropbox-generate-token-button"
    ext=".jpg"
    alt="The Dropbox 'Generate token' button"
    class="medium"
%}

Once the token is generated, you need to copy it...

{% include image-2.html
    img="/2018/dropbox-token"
    ext=".jpg"
    alt="An example. Not my real Dropbox token."
    caption="An example. Not my real Dropbox token."
    class="large"
%}


... and paste the token into our configuration file:

qwertyuiopAAA_This_Is_Not_My_Real_Token_But_You_Get_The_Idea_AAAplkdfnvlskdmf

**Save** and **close** the configuration file.

### 6.4 : Test our changes

Start up the PPP app again.

Put another set of photos into the IN directory.

Now watch as the photos also get uploaded to Dropbox.

## Step 7 : Completing the file pipeline

By default:
 - Our photo booth saves all the photos it captures into a folder called `photos`.
 - Our ppp application watches the folder called `photos-IN`.
 - We need to manually copy our photos from the `photos` into the `photos-IN` folder.

If we want this manual step to be performed automatically, then we will make one more change to our configuration file:

TODO: insert config file change.


## Step 8 : Updating our "Auto-start" script to also include the PPP application.

TODO: insert step


## Step 9 (BONUS): Automatically posting images to social media and other sites

One of the great benefts of choosing Dropbox, is that is can be used in conjunction with ITTT. ITTT is a website that can be used to automate actions between different online platforms.

When a photo gets uploaded to Dropbox, when can use ITTT to trigger additional events such as:
 - We send a tweet on Twitter
 - We publish the photo on Tumbler
 - We share the photo on Facebook

ITTT is super easy to use and **you don't need to write any code**. Instead, ITTT provides a set of simple screens that are built around the phrase "If __this__ then __that__".

As an example, lets get our photo booth to start integrating with Twitter:

1. Go to [ifttt.com](https://ifttt.com), and Login / Register for an account.
1. Start a `New applet`
1. Click on the "if this", to specifiy the condition under which our workflow event will commence:{% include image-2.html
    img="/2018/ITTT-01"
    ext=".jpg"
    alt="1"
    caption="1"
    class="medium"
%}
4. Locate Dropbox
{% include image-2.html
    img="/2018/ITTT-02"
    ext=".jpg"
    alt="2"
    caption="2"
    class="medium"
%}
1. Complete the steps of connecting your Dropbox account with ITTT
{% include image-2.html
    img="/2018/ITTT-03"
    ext=".jpg"
    alt="3"
    caption="3"
    class="large"
%}

{% include image-2.html
    img="/2018/ITTT-04"
    ext=".jpg"
    alt="4"
    caption="4"
    class="large"
%}

{% include image-2.html
    img="/2018/ITTT-05"
    ext=".jpg"
    alt="5"
    caption="5"
    class="large"
%}

{% include image-2.html
    img="/2018/ITTT-06"
    ext=".jpg"
    alt="6"
    caption="6"
    class="large"
%}

{% include image-2.html
    img="/2018/ITTT-07"
    ext=".jpg"
    alt="7"
    caption="7"
    class="large"
%}

{% include image-2.html
    img="/2018/ITTT-08"
    ext=".jpg"
    alt="8"
    caption="8"
    class="large"
%}

{% include image-2.html
    img="/2018/ITTT-09"
    ext=".jpg"
    alt="9"
    caption="9"
    class="large"
%}

{% include image-2.html
    img="/2018/ITTT-10"
    ext=".jpg"
    alt="10"
    caption="10"
    class="large"
%}

{% include image-2.html
    img="/2018/ITTT-11"
    ext=".jpg"
    alt="11"
    caption="11"
    class="large"
%}