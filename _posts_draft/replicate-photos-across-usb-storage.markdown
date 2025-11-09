---
layout:  "post"
title:   "Replicate photos across USB storage"
#desc:    "(Work in progress)"
author:  "Jack Barker"
tags:    [ Raspberry Pi, Windows, shell scripting ]
#img:     ""
#img-ext: ""
draft: true
---

Hi,
Thanks for you patience on this.
Below is some code that will copy the photos onto all USB storage devices that have been attached.


# Step 1: Have a look at the camera.py file, and make sure each of the following lines are included:
import os
import shutil
from glob import glob

#(You will probably need to add the last line, the other two libraries should already be there).

#Step 2: Immediately after all of the "import" and "from" statements, we need to add the following function definiton.

#This function copies a file onto any USB storage devices that have been plugged in.
def copy_to_usb(filename):
  #Get directories which correspond to USB storage
  for dir in glob('/media/pi/*/'):

    #Need to exclude directories that include the string "SETTING", as these are system directories
    if "SETTING" not in dir:
    
      #Directory we will be saving to:
      copy_to_dir = dir + "photo-booth/"

      #Does the directory already exist?
      if not os.path.exists( copy_to_dir ):

        #Create directory to save photos in:
        os.makedirs( copy_to_dir )

      #Copy file into directory
      shutil.copy2(filename, copy_to_dir)


Step 3: We need to locate the code that saves our photos, and immediately after that, we add one additional line of code to utilise our new function:
          camera.capture(filename)
          copy_to_usb(filename)


Hopefully with all these changes, this will now resolve the issue for you.