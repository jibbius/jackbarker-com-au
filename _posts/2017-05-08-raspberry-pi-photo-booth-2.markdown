---
layout: post
title:  "Photo Booth (Part 2): Getting started with Pi and PiCamera"
desc:   "Breadboarders, assemble!"
permalink: /photo-booth/2
date:   2017-05-08
author: Jack Barker
tags:   [ Raspberry Pi , hacks ]
img: "/2017/photo_booth/1_Breadboarding_2"
img-thumb: "/2017/photo_booth/1_Breadboarding_2"

---

{% include multi-post-photo-booth.html part=2 %}

## Overview of Part 2
Before providing a full set of components and plans for the Photo Booth, I'd recommend breadboarding out a simple version to get you started.

If you want to skip that step, then feel free to jump ahead.


## Getting Started with Pi and PiCamera
To start breadboarding out the photo booth, you will need:
 - A Raspberry Pi
   - I am version 3 of the Raspberry Pi
   - I have also tested my code against Pi version 2B (also works fine)
 - An SD card
   - I am using a 16Gb card, although smaller cards will probably be fine.
 - A Pi Camera
   - I am using PiCamera version 2
   - The earlier version of the camera will also be fine (although fewer megapixels)
 - An LED screen <br>To power the screen, you will also need:
   - a spare USB phone charger, and
   - a spare micro USB cable
 - Jumper wires
   - Get a mix of M-M, M-F, and F-F
 - A momentary push button
   - Later on in the project, we will use a large arcade button w/ LED
   - If you don't have this right now, then you can proceed with a simple momentary switch button, or by just connecting and disconnecting a wire within the circuit
 - A breadboard
 - A keyboard you can borrow, and connect up to the Pi.
 - **Optional materials**:
   - A raspberry Pi breakout breadboard<br>(you will see that I was using this in a couple of the images below. I should note that for this project, it's overkill and not required)


## Preparing your Pi

### Installing the Operating System
For prototyping, I am running:
 - [The NOOBs version of Raspian][noobs]{:target="_blank"}

If this is new to you, there are plenty of [online tutorials][pi-software-guide]{:target="_blank"} that will help you in completing this step. For this reason I won't bother detailing it further here.

#### Alternatives
Using Raspian, the boot time for the Photo Booth is roughly <strong>40 seconds</strong>, and (for me) I was content enough with this duration that I haven't looked into alternatives at this stage.

If you want the booth to boot faster, then you may want to look at running a more light-weight OS. This is also not a topic that I intend to cover right now, but I may cover this later after testing a few different options out.

After installing the operating system I generally find it is best to connect the Pi to your WIFI network and then connect to it from another computer via `ssh`. Again, this is slightly outside the scope of what I intend to cover here, and you can (of course) connect a keyboard and mouse to the Pi instead.


### Connecting the LCD Screen

My screen connected to the Pi via HDMI.

The screen also requires a separate power source (until I get around to tidying that up).
The easiest way to do this is a via a spare USB phone charger and micro-USB cable.

### Connecting the Camera

If you've gone with a PiCamera per my recommendation then installation is straight-forward (although perhaps a bit fiddly). The camera will connect to your Pi via a Ribbon Connector.

Here is an image showing how the latch operates (it's a bit unnerving the first time you try it):

After connecting the camera, you need to enable it, via the command line.


#### Enabling PiCamera
Connect a keyboard to the Pi, and open up the Terminal.

    sudo raspbi-config
    #Note: You will be prompted to enter your password

From the menu, you need to enable 'PiCamera'.

Other useful options to enable here are:
- 'SSH', which allows you to connect remotely to the pi via an SSH terminal
- 'VNC', which lets you remotely connect to the Pi from another computer (using the RealVNC Viewer client). Again, I'll leave this decision up to you.


## A Test Run of the Camera
To familiarise yourself with the PyCamera library, begin by starting a terminal on the Pi.
It's best to connect to the pi from another computer (via `SSH` or `RealVNC`)

If you connected via RealVNC, open `Terminal` or `UXTerm` on the Pi.
You will be greeted with a command prompt.

If you connected via SSH, you will already be inside a command prompt.

From here, we can access the python interpreter by typing `python`.

### Test run via Python interpreter
Within the interpreter, enter the following commands:

    import picamera
    camera = picamera.PiCamera()
    camera.start_preview()

The camera will now be displaying your picture on the screen that is connected to the Pi.

### Flip and Rotate the camera

You may need to flip and/or rotate the picture, such that it suits the angle your camera has been mounted at.

    camera.hflip = True
    camera.rotation = 90

### Save a photo

Enter a couple more commands into the terminal, to save a photo

    filename = ~\my_test_photo.jpg
    camera.capture(filename)

Exit the python interpreter

    exit()

You can now see that the photo has been saved to the Pi.

    ls ~

## Connecting up the button
Now that we have a basic understanding of how our PiCamera will work, it is time to connect our button.

Shutdown the Pi and disconnect the power supply.

    sudo shutdown now

Connect your button to the Pi, as follows:

{% include image-2.html
    img="/2017/photo_booth/1_Breadboarding_2"
    alt="Breadboarding"
    caption="Breadboarding"
%}

## Connecting up the button
Once the button is connected we can run a "simple version" of our photo booth code.

The button needs to connect to **GPIO21** and **Ground**.

(I will provide some more instructions/images on this soon).

This piece of code doesn't have the full functionality of my finished photo booth, but it contains "just enough" to test out the functionality that we care about and get an idea of how the finished code might look.

Boot up your Raspberry Pi again.

The code we are going to run is shown here: [gist.github.com/jibbius/8105081adfc0d6dd7da77cd813c69593](https://gist.github.com/jibbius/8105081adfc0d6dd7da77cd813c69593){:target="_blank"}.

You can either copy across the code manually, or enter the following at the command line (on the Pi) to download it.

    mkdir ~/simple-photo-booth
    git clone https://gist.github.com/8105081adfc0d6dd7da77cd813c69593.git ~/simple-photo-booth

Run the code via:

    cd ~/simple-photo-booth
    python simple-photo-booth.py

Press the button to test the code.

To exit the **simple photo booth** app, press `ctrl` + `c`.

## Next article
For the [next article]({{ "/photo-booth/3" | prepend: site.url }}) in this series, I'll be talking about <strong>building the wood cabinet</strong> that houses the photo booth.

[noobs]: https://www.raspberrypi.org/downloads/noobs/ "The NOOBs version of Raspian"
[pi-software-guide]: https://www.raspberrypi.org/learning/software-guide/ "RasberryPi.org - Software Guide"