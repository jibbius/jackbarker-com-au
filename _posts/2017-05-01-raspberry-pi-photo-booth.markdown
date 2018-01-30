---
layout: post
title:  "How to build a Photo Booth"
desc:   "My first Raspberry Pi project!"
date:   2017-05-01
author: Jack Barker
tags:   [ Raspberry Pi , hacks ]
permalink: /photo-booth/
img: "/2017/photo_booth/0_FinishedBooth_1b"
img-thumb: "/2017/photo_booth/0_FinishedBooth_2b"

---

{% include multi-post-photo-booth.html part=0 %}

## My DIY Photo Booth
### The Finished Product

{%include todo.html todo="Include Youtube video"%}

{% include image-2.html img="/2017/photo_booth/0_FinishedBooth_2b" alt="My kickass photo booth!" caption="Weddings, Parties, Anything: My kickass photo booth!" class="medium" %}

## Back story
Last weekend, I had an absolute blast at my wedding.

So too, apparently, did my guests - who absolutely loved taking shots with the photo booth!

{% include image-2.html img="/2017/photo_booth/JWLPhotography_201704152105_LANG1749" alt="Photo credit: Jonathan Lang Photography" caption="Photo credit: <a href='http://jonathanlangphotography.com.au/' target='_blank'>Jonathan Lang Photography</a>." class="medium" %}

{% include image-2.html img="/2017/photo_booth/JWLPhotography_201704152106_LANG1753" alt="Photo credit: Jonathan Lang Photography" caption="Photo credit: <a href='http://jonathanlangphotography.com.au/' target='_blank'>Jonathan Lang Photography</a>." class="medium" %}


## Where can I see the code?
The code for my photo booth is available here: 

[https://github.com/jibbius/raspberry_pi_photo_booth](https://github.com/jibbius/raspberry_pi_photo_booth){:target="_blank"}

## What makes **this** DIY photo booth special?
My photo booth is unique for the following reasons;
    
1. It was the 1st project I **ever** built with a Raspberry Pi, and it's a great starting point for beginners.
1. It takes a "less is more" approach;
 - I opted to exclude features that weren't essential. 
 - The code runs on both **Python 2.7** and **Python 3**.
 - The code introduces very few libraries/dependencies, in the hopes of delivering a solution that "just works".

## Publicity
Since writing about my photo booth, it's been featured in the following publications:
<div class="row">
<div class="column">
{% include image-2.html img="/2017/photo_booth/part0-DIYODE_1" ext=".png" alt="Photo credit: Jonathan Lang Photography" caption="<a href='https://diyodemag.com/features/pi_booth/' target='_blank'>DIYODE, #1</a>" class="medium" caption_placement="top" %}
</div>
<div class="column" markdown="1">
{% include image-2.html img="/2017/photo_booth/part0-TheMagPi_60" ext=".png" alt="Photo credit: Jonathan Lang Photography" caption="<a href='https://www.raspberrypi.org/magpi-issues/MagPi60.pdf#page=30' target='_blank'>The MagPi, #60</a>" class="medium" caption_placement="top" %}
</div>
</div>

Thanks to all the above for their support.

## Acknowledgements
I'd also like to thank the following;
- The [Ballarat Hackerspace](https://ballarathackerspace.org.au/){:target="_blank"}, and awesome community for their ideas and assistance.
- [DrumminHands' Photo Booth](http://www.drumminhands.com/2014/06/15/raspberry-pi-photo-booth/){:target="_blank"} which provided inspiration for parts of this build.

## Remixes
I love hearing from people that have built their own "photo booth" versions;
- Eric built [this brilliant photo booth](https://youtu.be/pOE7_-OhYhQ){:target="_blank"}. His version includes an impressive-looking marquee, a video light, and it writes the photos to a USB stick (if connected).
 

## Next article
For the [next article]({{ "/photo-booth/1" | prepend: site.url }}) in this series, I'll be talking about <strong>the requirements process</strong> that I went through when planning my photo booth.

[Subscribe]({{ "/subscribe" | prepend: site.url }}) to my blog to stay informed of my progress.
