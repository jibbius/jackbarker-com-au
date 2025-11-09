---
layout: post
title:  "A temperature-controlled exahaust fan"
desc:   "A simple project, build with a Raspberry Pi and DHT11 sensors"
author: Jack Barker
tags:   [  Raspberry Pi, hacks, electronics ]
draft: true

---

## Beating the Aussie Heat
I live in an area where, for a few weeks of the year during the height of summer, our temperatures soar to 45{% include symbol_degree.html %}C, and above. It doesn't happen often enough to warrant racing out for the latest and greatest air conditioner, but roughly 2 or 3 times a year, things get unbearably hot.

The high temperatures last for a **few days** (unfortunately the "[Freo Doctor](https://ballarathackerspace.org.au/){:target="_blank"}" doesn't visit in-land Ballarat) but eventually they subside.

The temperature outside drops far quicker than the temperature drop that occurs inside. All throughout the neibourhood windows and doors become propped open, with the goal of "sucking in that cool air" as fast as possible, and delivering some respite to the heat-exhausted residents. 

## Temperature controlled exhaust fans
The goal for this project is to detect the above weather event (i.e. cold air inside; warm air outside) and, when that occurs, trigger the operation of a 200mm fan that I've installed into the window of my home-office.

## Intake fan, or exhaust fan?
I used the following hypothesis, when thinking about this:

Intake fan
 - Better at cooling the immediate room in which the fan is placed
 - Given the source of the incoming air is known, it would be possible to filter the air for dust (prior to it's entering the home).

Exhaust fan
 - Better if trying to expell heat / pollutants from a specific source (i.e. if I'm creating solder fumes indoors; or if the GPUs in my cryptocurrency-mining rig are getting a little toasty).
 - The fan will cause the air pressure within the home to drop, and thus cool air will enter the home (to equalise the pressure) from a more distributed set of sources.
 - Adding a dust filter to the fan will have no benefit (you would need to figure out where the incoming air was arriving from).

 An argument can be made for including both the intake and exhaust fans, such that we control exactly where the air is entering and exiting and reap the benefits of both.

## Why the Raspberry Pi?
The Raspberry Pi Zero is pretty much the cheapest board on the market at the moment (~$5).

I could have looked at a solution using an Arduino Nano, but;
1. These are slightly more expensive option.
1. I had a Pi Zero on hand.
1. Additionally, being able to spin up a webserver (such that I can control / monitor the fan + sensors from my phone) was going to be far simpler with the Raspberry Pi.

## Getting started with the Pi
The setup instructions are much the same as my Photo Booth project;
 - Install the operating system, per the instructions [here]({{ "/photo-booth/2#preparing-your-pi" | prepend: site.url }})<br>(Skip the steps involving the camera/LCD screen).

