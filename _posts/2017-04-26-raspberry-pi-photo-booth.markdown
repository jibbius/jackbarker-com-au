---
layout: post
title:  "How to build a Photo Booth"
desc:   "My first Raspberry Pi project!"
date:   2017-04-26
author: Jack Barker
tags:   [ Raspberry Pi , hacks ]
permalink: /photo-booth/
image: "/images/2017/photo_booth_web/0_FinishedBooth_1a_300x179.jpg"
image-srcset: "
/images/2017/photo_booth_web/0_FinishedBooth_1a_300x179.jpg 300w,
/images/2017/photo_booth_web/0_FinishedBooth_1a_400x238.jpg 400w,
/images/2017/photo_booth_web/0_FinishedBooth_2a_600x357.jpg 600w,
/images/2017/photo_booth_web/0_FinishedBooth_2a_900x536.jpg 900w,
/images/2017/photo_booth_web/0_FinishedBooth_1a_1400x834.jpg 1400w,
/images/2017/photo_booth_web/0_FinishedBooth_1a_1800x1072.jpg 1800w,
/images/2017/photo_booth_web/0_FinishedBooth_1a_3000x2250.jpg 3000w"

---

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

Here are the high level steps:
1. Listing out the requirements
1. Getting started with Pi and PiCamera
1. Building the Booth
1. Adding the 12volt Lights / Flash (Optional)
1. Adding a Printer (Optional)
1. Adding a Power button
1. Fine-tuning
1. Photo day!
1. Post-production

I'll be writing articles for each of these steps in the coming days :)
