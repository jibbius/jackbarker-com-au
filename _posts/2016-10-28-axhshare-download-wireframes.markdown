---
layout: post
title:  "How To Download Wireframe Images from AxShare"
desc:   "My tutorial on bulk downloading images of wireframes, which have been hosted using Axure's AxShare cloud hosting service."
date:   2016-10-28
author: Jack Barker
tags:   [Axure, hacks]
---
Here is a guide for bulk downloading images of wireframes, where the wireframes have been hosted using Axure's
cloud hosting service; AxShare.

The wireframes will be downloaded, and saved as (.png) and/or (.jpg) format.

This may be useful if:

- You are working in collaboration with a design partner agency, and want to ensure that wireframes are not
  "tampered with" after scope has been agreed.
- You need to work offline for a period, but still need access to some wireframe resources.
- You prefer working with paper (i.e. hard copies), and you need to be able to bulk-print a set of hosted wireframes.

### You will need:

- [Mozilla Firefox](firefox){:target="_blank"}
- The **Grab them all** Firefox extension.
  - To download, visit this link using Firefox: [Grab them all](grab-them-all){:target="_blank"}
- A link to an AxureShare site for which you intend to download wireframe images from (and the password, if applicable).

### Optional extras:

- An image compare tool (i.e. BeyondCompare; DeltaWalker; Kaleidoscope; Araxis Merge)
- Microsoft Powershell (for the purpose of scripting an image comparison)

## Step 1

- Navigate to the Axure Wireframes page you want to download.
- Login with your password (if applicable).
- For example: http://YourLinkID.axshare.com/

## Step 2
Open the JavaScript console (within Firefox), by pressing `Ctrl` + `Shift` + `I` on the keyboard, and ensure "Console" is selected.

## Step 3
Copy the following JavaScript code:

{% highlight javascript %}
// Get Sitemap
var axureNodes = $axure.document.sitemap.rootNodes;

// Parse sitemap for URLs
var key = 'url';
var normalisedAxureNodes = function getValues(obj, key) {
    var objects = [];
    for (var i in obj) {
        if (!obj.hasOwnProperty(i)) continue;
        if (typeof obj[i] == 'object') {
            objects = objects.concat(getValues(obj[i], key));
        } else if (i == key) {
            objects.push(obj[i]);
        }
    }
    return objects;
}(axureNodes, key);

// Prepare file contents
var myFileContents = function buildTextFile(my_values){
    var textFileContents = '';
        for (var i in my_values) {
        if(my_values[i] != '')
            textFileContents += 'http://' + window.location.hostname + '/' + my_values[i] + '\n';
    }
    return textFileContents;
}(normalisedAxureNodes);

// Open file in browser
var url = 'data:text;charset=utf8,' + encodeURIComponent(myFileContents);
window.open(url, '_blank');
window.focus();

{% endhighlight %}

## Step 4
In case the above doesn't work you may need to do the following first:

- If prompted, you may need to type “allow pasting” into the JavaScript console, before you will be allowed to paste code (then retry step 4).
- If prompted, you may need to also enable pop-ups from the page.

## Step 5
You should now be shown a list of all the wireframe URLs.

You will need to right-click, and “**Save Page As…**”


## Step 6
Save the file to your computer (in .txt format):
 
## Step 7
Within Firefox, press `Alt` to display the menu, and select `Tools` > `Grab them all`
 
Specify;

- the file you saved earlier, and
- the location to store downloaded wireframes

## Step 8
‘Grab them all’ will then download PNGs of all the wireframes for the work package.
 

## Bonus Material

Image comparisons made easy.

If you have **Beyond Compare** installed, you can use this tool to compare visual differences between new and old versions of saved wireframes.

As Beyond Compare also supports comparisons of directories, you may wish to download 2 sets of wireframes (into different directories),
and then – rename them so that they are easier to compare.

The fastest method for this is via Windows Powershell.

Because the filenames are subtly different, they are difficult to compare.

To fix:

- Access each directory via the Powershell command line.
- Execute the following command, replacing text to match your own filenames:

{% highlight powershell %}

Dir | Rename-Item -NewName { $_.name -replace "http_YourLinkID.axshare.com_","" }

{% endhighlight %}

### Result:

- Filenames now match
- Because the filenames match, you can rapidly compare both sets of files via Folder compare; (Double-clicking the wireframe
  brings up visual compare)

### Limitations:

- Due to the unpredictability of image capture/compression algorithms, Beyond Compare will detect a lot more “differences”
than actually exist between the wireframe images.
  - For example, Beyond compare will detect slight differences in random pixels within the images… as such, in many cases
    you will be required to eyeball the two wireframes, rather than automatically letting you know that the wireframes are
    approximately identical.
- In theory, it should be possible to systematically ignore differences in images that are still 99.9% similar.
- I haven’t been able to find a way to alter the tolerance that is applied to this mechanism (If someone finds a way, please
  let me know :smile: ).
- Regardless; I do find the folder compare useful, as you are able to open both the before and after images in a single operation,
  without having to search/open each file independently.


[firefox]: https://www.mozilla.org/firefox/products/ "Mozilla Firefox"
[grab-them-all]: https://addons.mozilla.org/en-US/firefox/addon/grab-them-all/ "Grab them all"
