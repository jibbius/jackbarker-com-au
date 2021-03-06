---
layout: post
title:  "Photo Booth (Part 1): Requirements"
desc:   "Planning the photo booth build"
date:   2017-05-01
author: Jack Barker
tags:   [ Raspberry Pi , hacks ]
permalink: /photo-booth/1
img: "/2017/photo_booth/photoBoothReqs"

---

{% include multi-post-photo-booth.html part=1 %}

## Step 1 : Listing out the requirements

Before we go into the specifics of how I built my Photo Booth, you should begin to think about the features and constraints affecting your (potential) photo booth.

> "Requirements?!
> <br/> ...typical bleeping Business Analyst!"

{% include image-2.html
    img="/2017/photo_booth/photoBoothReqs"
    alt="Planning"
    caption="Make sure you are clear of your photo booth's requirements, before delving too far into the design."
    class="medium"
%}

### How will the booth be powered?
For the photo booth I built, I needed the following;
 - a 5 volt power supply (for the Pi), and
 - a USB phone charger (also delivering 5 volt) for the screen, and
 - a 12 volt power supply (for the LED lights)

To achieve this, I:
1. included a small power board inside the photo booth cabinet, and ran an extension lead to the nearest power point.
1. attached each of the required power supplies to the power board.

An assumption that I was making, was that the booth would be powered from a power point. If you don't want your booth to depend on power point access, then you will need a different solution.

In a future build, I will look to tidy up the power supplies, and the possibility of running off a battery.

### How much light will you need?
My wedding tested both of these scenarios:
1. Outdoors, on a relatively sunny day. (Photos came out great!)
1. Indoors, function venue, at night.  (Camera struggled)

Here are some things to consider:
 - I had added some 12v Ultra-Bright LEDs, and a custom "flash diffuser" to my photo booth. 
 - This really didn't produce enough light (more on that later).
 - I was able to remedy the situation by "touching up" the photos later (adjusting the brightness + contrast levels...etc).
 - If I had my time again, I would rig up some free-standing external lights. I expect this would have made a substantial improvement to the night-time photos.
 - It is also possible to adjust the "exposure settings" within the PiCamera code library, which might also help.

### Internet access?
Internet access will help you for two reasons:
1. It will allow you to share (and backup) your photos - immediately
1. It will provide access to a real time clock

Options available to you might differ based on which version of the Pi you are using:
- The Raspberry Pi 2 will allow you to connect a wireless internet dongle (or via an Ethernet cable).
- The Raspberry Pi 3 comes with wireless internet out of the box (no adapter required).

If you choose to go without internet connectivity, then I highly recommend getting a RTC (Real Time Clock) module.
This means that you will be able to record the date + time that each photo was taken.
If the Photo Booth needs to be restarted for any reason, then this will be especially useful.

### How will you share your photos?
By default, photos will get written to your SD card, and you can distribute them after the event.

Some other options to consider;

1. Upload to Dropbox (internet access required)
1. Upload to Website (GitHub Pages)
- (This is how I distributed my photos).

1. Upload to Tumbler / Google Photos / Similar service
1. Printer
1. Email

### What will the booth be made out of?
I made my photo booth out of wood from the local hardware store.
That said, you might have a wooden box or crate that could easily be converted into a photo booth.


## Next article
For the [next article]({{ "/photo-booth/2" | prepend: site.url }}) in this series, I'll be talking about <strong>Getting started with the Raspberry Pi</strong>, and the other components that will form the photo booth.

[Subscribe]({{ "/subscribe" | prepend: site.url }}) to my blog to stay informed of my progress.
