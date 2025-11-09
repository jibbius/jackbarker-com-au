---
layout: post
title:  "Connecting to my Raspberry Pi, from Windows, with SSHFS"
desc:  "A quick summary of SSHFS on Windows"
author: Jack Barker
tags: [ Raspberry Pi, Windows, shell scripting ]
img: "/2018/Using_SSHFS_in_WSL"
img-ext: ".png"
draft: true
---

Note that, at the time of writing development appears to have altogether ceased on win-sshfs.
As an alternative, I've been looking at sshfs-win.

# Why SSHFS?
The Raspberry Pi is a great device, but oftentimes, writing code is easier on my primary computer.
My main computer has apps and tools that maximise my productivity. It's already plugged in to my monitors, keyboard, ...etc.

It is not always appropriate to install of these apps onto my Raspberry Pi, especially when I am prototyping; or need to be "up and running" quickly.

Using SSHFS also means I can access the entire filesystem of the Pi; I don't need to go to the effort of sharing specific folders on my Pi that I don't intend to share across my network on a permanent basis.

# SSHFS on Windows
My primary computer is currently running Windows (although I've dabbled in Linux and Mac also). Unfortunately, Windows doesn't support SSHFS out of the box.

The Windows Subsystem for Linux ({% include abbr.html abbr="WSL" full="Windows Subsystem for Linux" %}), also doesn't support this (yet), although you can vote for it [here](https://wpdev.uservoice.com/forums/266908-command-prompt-console-windows-subsystem-for-l/suggestions/13522845-add-fuse-filesystem-in-userspace-support-in-wsl){:target="_blank"}.

{% include image-2.html
    img="/2018/Using_SSHFS_in_WSL"
    ext=".png"
    alt="Trying to get SSHFS working inside Windows Subsystem for Linux"
    caption="Trying to get SSHFS working inside Windows Subsystem for Linux."
%}

# Install SSHFS-WIN
1. If you have [chocolately](https://chocolatey.org/){:target="_blank"} installed on your Windows computer, then you can run: `choco install winfsp`.
2. Then install [sshfs-win](https://github.com/billziss-gh/sshfs-win/releases){:target="_blank"}.
  - (Unfortunately appears there is no Chocolatey package for sshfs-win at this time)
3. Restart the Windows computer.

# Using SSHFS-WIN
Once these steps are completed, you can access your linux files system over SSH.

For example:
{% highlight batch %}
    explorer \\sshfs\pi@192.168.1.121
{% endhighlight %}
...where:

 - `pi` is your username, and
 - `192.168.1.121` is the IP address of your Raspberry Pi.

(You will also be prompted to provide your password).

{% include image-2.html
    img="/2018/win-sshfs"
    ext=".png"
    alt="Using Win SSHFS to access a Raspberry Pi from Windows."
    caption="Using Win SSHFS to access a Raspberry Pi from Windows."
%}
