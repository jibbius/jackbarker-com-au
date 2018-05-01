---
layout: post
title:  "Photo Booth (Part 8): Post production"
desc:  "Image optimisation, Animated thumbnails, Upload to Dropbox, and Generating a website."
permalink: /photo-booth/8
author: Jack Barker
tags:   [ Raspberry Pi, hacks, Python ]
date: 2018-04-18
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
 - (and if you're keen to do some further coding, you can add even more functionality if you like) :wink:.
2. Upload our images to Dropbox.

## Why a separate application?
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

We install ImageMagick from our Rasberry Pi's `terminal` with the following commands:

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
The configuration file for our application is written using the YAML language.

To assist Python in being able to interpret this file, we are also going to ensure that the our YAML-parsing library is installed:

{% highlight sh %}
    # This python library will help us read our config file (written in YAML)
    pip install ruamel.yaml

    # Or, if using Python 3 instead:
    python3 -m pip install ruamel.yaml
{% endhighlight %}

## Step 2 : Installing the "Photo processing" application
As of version 3.0 of the Photo Booth (May 2018), the two applications (i.e. the 'Photo Booth' and the 'Photo Processor') are packaged together in the one download.

If you already have this verion of the code downloaded, then the file you are looking for is: `photo-processor.py`

If you are using an older version of the photo booth code (and want to upgrade to the latest version), the commands below will allow you to do that.

****

{% highlight sh %}
    #Please save any photos/config you wish to keep (into another folder), and then run the following:
    cd ~/photo-booth 
    git reset --hard 
    git fetch origin 
    git checkout master 
    git merge origin/master
{% endhighlight %}

Alternatively (if you encounter errors), you can:

1. Remove the previous version (remember to back up your photos first), and then
2. Reinstall the application per [Part 5](/photo-booth/5) of this series.

## Step 3 : Run the application
{% highlight sh %}
    cd ~/photo-booth 
    python photo-processor.py
{% endhighlight %}
Notice that our application now appears to be watching for files:

{% include image-2.html
    img="/2018/watching_for_new_files"
    ext=".png"
    alt="photo-processor.py"
    class="large"
%}

Also notice that we now have a set of additional folders created in our project directory:

## Step 4 : Testing the application
Now, as an experiment we can drop a set of 4 photos into `/photos-IN`:
{% include image-2.html
    img="/2018/placing_photos_into_photos-IN_1"
    ext=".png"
    alt="Placing images into [photos-IN] directory"
    class="medium"
%}

Our application will start spitting out information to us:
{% include image-2.html
    img="/2018/placing_photos_into_photos-IN_2"
    ext=".png"
    alt="Photos are getting processed"
    class="medium"
%}


Finally, if we check our `/photos-DONE` folder, we can see a number of things have happened to our photos:
1. Each of our 4 images has been reduced in file size. The files are now 1/4 their previous size, without a noticable drop in quality.
1. The 4 images have also each been "auto-levelled" to help optimise their brightness / contrast (Note: this may only be noticable in poor lighting conditions).
1. We now have an animated "thumbnail" image, which can great for posting on the web.
1. We have a couple of "photo strip" layouts (1x4) and (2x2); which may be useful if we want to print our images.

{% include image-2.html
    img="/2018/placing_photos_into_photos-3"
    ext=".png"
    alt="End result"
    class="medium"
%}

Nice one!

## Step 5 : Configuring our application
A configuration file gets created the 1st time the application is run.

If we close our 'photo processing' application (via `Ctrl` + `\`) then we can have a look at the configuration file `photo-processor-config.yaml`.

All of the images that are output by the application can be enabled/disabled/customised, within this file:

{% highlight yaml %}
    #photo-processor-config.yaml
    #---------------------------

    # Photo Processor Config:

    # Images to Output
    "OUTPUT_OPTIMISED_STILLS"    : True
    "OUTPUT_ANIMATED_THUMBNAILS" : True
    "OUTPUT_LAYOUTS"             : True

    # Directories
    "INPUT_DIRECTORY"      : "photos-IN"          # Files will be taken from here.
    "PROCESSING_DIRECTORY" : "photos-PROCESSING"  # Files will temporarily occupy this folder, whilst being processed.
    "OUTPUT_DIRECTORY"     : "photos-DONE"        # Files will be placed in this folder, once all processing is complete.

    # Image compression
    "IMAGE_QUALITY" : 90

    #Thumbnails config
    "THUMBNAILS_IMAGE_QUALITY" : 50
    "THUMBNAILS_SIZE"          : 50

    # List of print layouts to produce (1 column, 2 column)
    "LAYOUTS" :
    1:
        "TILE" : "1x"
        "SIZE" : "1920x1152"
        "MARGIN" : "20"
    2:
        "TILE" : "2x"
        "SIZE" : "1920x1152"
        "MARGIN" : "20"

    # Dropbox
    "DROPBOX_ENABLED" : False
    "DROPBOX_TOKEN"   : ""
{% endhighlight %}

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
    class="small"
%}

Once the token is generated, you need to copy it...

{% include image-2.html
    img="/2018/dropbox-token"
    ext=".jpg"
    alt="An example. Not my real Dropbox token."
    caption="An example. Not my real Dropbox token."
    class="large"
%}


... and paste the token into our configuration file (`photo-processor-config.yaml`):
{% highlight yaml %}
   
    # Dropbox
    "DROPBOX_ENABLED" : True
    "DROPBOX_TOKEN"   : "qwertyuiopAAA_This_Is_Not_My_Real_Token_But_You_Get_The_Idea_AAAplkdfnvlskdmf"
    
{% endhighlight %}

**Save** and **close** the configuration file.

### 6.4 : Test our changes

Start up the **Photo Processor** app again.

Copy a set of photos from the `photos` directory into the `photos-IN` directory.

Now watch as the photos also get uploaded to Dropbox.

## Step 7 : Completing the file pipeline

By default:
 - Our photo booth application (`camera.py`) saves all the photos it captures into a folder called `photos`.
 - Our **Photo Processor** application (`photo-processor.py`) watches the folder called `photos-IN`.
 - We need to manually copy our photos from the `photos` into the `photos-IN` folder.

If we want this manual step to be performed automatically, then we will make one more change to our photo-booth configuration file (`camera-config.yaml`):

{% highlight yaml %}

    # Additional location(s) where images will be saved to (optional):
    "COPY_IMAGES_TO" : ["photos-IN"]

{% endhighlight %}

Notice that the '#' character has been removed, which preceeded "COPY_IMAGES_TO".

This will cause our images to be copied into the `photos-IN` directory (in addition to saving the raw images into our `photos` directory).

## Step 8 : Updating our "Auto-start" script to also include the **Photo Processor** application.

We can update our autostart script, as follows.

This will ensure that both applications start automatically when we booth the Pi.

(This is, of course, optional).

- Update our a new text file;

{% highlight bash %}
sudo nano /etc/xdg/autostart/autostart_photo_processor.desktop
{% endhighlight %}

- Populate the file with the following content:

{% highlight bash %}
[Desktop Entry]
Type=Application
Name=photo-processor.py
Comment=Raspberry Pi Photo Processor 
NoDisplay=true
Exec=sudo python /home/pi/photo-booth/photo-processor.py
NotShowIn=GNOME;KDE;XFCE;
Name[en_US]=photo-processor.py
{% endhighlight %}

- Save and exit the file (`Ctrl` + `X`).

For more detail about autostart scripts, refer to the earlier discussion within [part 6]({{ "/photo-booth/6" | prepend: site.url }}).

## Step 9 (BONUS): Automatically posting images to social media and other sites

One of the great benefts of choosing Dropbox, is that is can be used in conjunction with ITTT. ITTT is a website that can be used to automate actions between different online platforms.

When a photo gets uploaded to Dropbox, when can use ITTT to trigger additional events such as:
 - We send a tweet on Twitter
 - We publish the photo on Tumbler
 - We share the photo on Facebook

ITTT is super easy to use and **you don't need to write any code**. Instead, ITTT provides a set of simple screens that are built around the phrase "If __this__ then __that__".

As an example, lets get our photo booth to start integrating with Twitter:

1. Go to [ITTT.com](https://ITTT.com), and Login / Register for an account.
1. Start a `New applet`
1. Click on "If **this**", to specify the condition under which our action will be triggered:
{% include image-2.html
    img="/2018/ITTT-01"
    ext=".jpg"
    alt="If 'this'..."
    caption="If 'this'..."
    class="medium"
%}

{:start="4"}
1. Locate Dropbox:
{% include image-2.html
    img="/2018/ITTT-02"
    ext=".jpg"
    alt="Select 'Dropbox'"
    class="medium"
%}

{:start="5"}
1. Complete the steps of connecting your Dropbox account with ITTT:
<div class="row">
<div class="column center-text" markdown="1">
{% include image-2.html
    img="/2018/ITTT-03"
    ext=".jpg"
    alt="Connect Dropbox"
%}
</div>
<div class="column center-text" markdown="1">
{% include image-2.html
    img="/2018/ITTT-04"
    ext=".jpg"
    alt="Dropbox oAuth"
%}
</div>
</div>

{:start="6"}
1. Choose the trigger "New photo in your folder"

{% include image-2.html
    img="/2018/ITTT-05"
    ext=".jpg"
    alt="5"
    class="medium"
    caption="Note: There is a limitation here. ITTT will post a maximum of 15 images per polling period (~per hour)." 
%}
{:start="7"}
1. Specify the **Dropbox subfolder** that ITTT will check for new images.
This will be `Apps\` + the name of your Dropbox app + `\thumbnails`:
{% include image-2.html
    img="/2018/ITTT-06"
    ext=".jpg"
    alt="6"
    class="medium"
%}
{:start="8"}
1. Click on "Then **that**", to specify the action to be performed:
{% include image-2.html
    img="/2018/ITTT-07"
    ext=".jpg"
    alt="7"
    class="medium"
%}
{:start="9"}
1. Locate Twitter (or another service of your choosing), and complete the remaining details:
<div class="row">
<div class="column center-text" markdown="1">
{% include image-2.html
    img="/2018/ITTT-08"
    ext=".jpg"
    alt="Choose 'Twitter' action"
%}
</div>
<div class="column center-text" markdown="1">
{% include image-2.html
    img="/2018/ITTT-09"
    ext=".jpg"
    alt="Post tweet with image"
%}
</div>
</div>
<div class="row">
<div class="column center-text" markdown="1">
{% include image-2.html
    img="/2018/ITTT-10"
    ext=".jpg"
    alt="Complete action fields"
%}
</div>
<div class="column center-text" markdown="1">
{% include image-2.html
    img="/2018/ITTT-11"
    ext=".jpg"
    alt="Review and finish"
%}
</div>
</div>