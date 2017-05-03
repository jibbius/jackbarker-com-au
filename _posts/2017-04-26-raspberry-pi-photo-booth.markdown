---
layout: post
title:  "How to build a Photo Booth"
desc:   "My first Raspberry Pi project!"
date:   2017-04-26
author: Jack Barker
tags:   [ Raspberry Pi , hacks ]
permalink: /photo-booth/
image: "/images/2017/photo_booth_web/0_FinishedBooth_1a_300x225.jpg"
image-srcset: "
/images/2017/photo_booth_web/0_FinishedBooth_1a-300x195.jpg 300w,
/images/2017/photo_booth_web/0_FinishedBooth_1a-600x390.jpg 600w,
/images/2017/photo_booth_web/0_FinishedBooth_1a-800x521.jpg 800w,
/images/2017/photo_booth_web/0_FinishedBooth_1a-1000x651.jpg 1000w
"

---
This article is 'part 1' of my ['How to build a Photo Booth'][howtophotobooth] series.


## Back story
Last weekend, I had an absolute blast at my wedding.

So too, apparently, did my guests - who absolutely loved taking shots with the photo booth!

{% include image.html
    url="/images/2017/photo_booth_web/0_FinishedBooth_2a_300x400.jpg"
    srcset="
/images/2017/photo_booth_web/0_FinishedBooth_2a_300x400.jpg 300w,
/images/2017/photo_booth_web/0_FinishedBooth_2a_600x800.jpg 600w,
/images/2017/photo_booth_web/0_FinishedBooth_2a_900x1200.jpg 900w,
/images/2017/photo_booth_web/0_FinishedBooth_2a_1225x1500.jpg 1225w,
/images/2017/photo_booth_web/0_FinishedBooth_2a_2250x3000.jpg 2250w"
    alt="My kickass photobooth!"
    caption="Weddings, Parties, Anything: My kickass photobooth!"
    width="600px"
%}


## THe build process
Here are the high level steps:
1. [Listing out the requirements][howtophotobooth-1]
1. Getting started with Pi and PiCamera
1. Building the Booth
1. Adding the 12volt Lights / Flash (Optional)
1. Adding a Printer (Optional)
1. Adding a Power button
1. Fine-tuning
1. Photo day!
1. Post-production

I'll be writing articles for each of these steps in the coming days and weeks.

For now, we'll start with;

## Step 1 : Listing out the requirements

> Requirements?!
> <br/> ...typical bleeding Business Analyst!


Before we go into the specifics of how I built my Photo Booth, you should begin to think about the features and constraints affecting your (potential) photo booth.

Here are some things you need to consider:
 - How will the booth be powered?
 - How much light will you need?
 - Will I have internet access?
 - How will I share my photos?
 - What will you make the booth out of?

### How will the booth be powered?
For the photo booth I built, I needed the following;
 - a 5 volt power supply (for the Pi), and
 - a 12 volt power supply (for the LED lights)

To achieve this, I included a small power board inside the photo booth cabinet, and ran an extension lead to the nearest power point.

The critical decision I made, was that the booth would be powered from a power point. If you don't want to depend on power point access, then you will need a different solution.


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

The Raspberry Pi 2 will allow you to connect a wireless internet dongle.
The Raspberry Pi 3 comes with wireless internet, out of the box.

If you choose to go without internet connectivity, then I highly recommend getting a RTC (Real Time Clock) module.
This means that you will be able to record the date + time that each photo was taken.
If the PhotoBooth needs to be restarted for any reason, then this will be especially useful.

### How will you share your photos
By default, photos will get written to your SD card, and you can distribute them after the event.

Some other options to consider;

1. Upload to Dropbox (internet access required)

1. Upload to Website (GitHub Pages)
  - This is how I distributed my photos.

1. Upload to Tumbler / Google Photos / Similar service

1. Printer

1. Email

### What will the booth be made out of?
I made my photo booth out of wood from the local hardware store.
That said, you might have a wooden box or crate that could easily be converted into a photo booth.


## Next article
In my next article in this series, I'll be taking about <strong>Getting started with the Raspberry Pi</strong>, and the other components that will form the photo booth.

[Subscribe][subscribe] to my blog to stay informed of my progress.

[subscribe]: /subscribe "Subscribe"

