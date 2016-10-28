---
layout: post
title:  "Download Wireframe Images from AxShare"
date:   2016-10-28 17:00:00 +1100
categories: jekyll update
---
Here is a guide for downloading an entire site of AxureShare wireframes.

The wireframes will be downloaded, and saved as (.png) and/or (.jpg) format.

### You will need:

- [Mozilla Firefox](https://www.mozilla.org/firefox/products/)
- The **Grab them all** Firefox extension.
  - To download, visit this link using Firefox: [Grab them all](https://addons.mozilla.org/en-US/firefox/addon/grab-them-all/)
- A link to an AxureShare site for which you intend to download wireframe images from (and the password, if applicable).

### Optional extras:

- An image compare tool (i.e. BeyondCompare; DeltaWalker; Kaleaidoscope; Araxis Merge)
- Microsoft Powershell (for the purpose of scripting an image comparison)

## Step 1

- Navigate to the Axure Wireframes page you want to download.
- Login with your password (if applicable).
- For example: http://mfdk5s.axshare.com/#p=a14_-_model_portfolios

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
var myfilecontents = function buildTextFile(my_values){
    var textfilecontents = '';
        for (var i in my_values) {
        if(my_values[i] != '')
            textfilecontents += 'http://' + window.location.hostname + '/' + my_values[i] + '\n';
    }
    return textfilecontents;
}(normalisedAxureNodes);

// Open file in browser
var url = 'data:text;charset=utf8,' + encodeURIComponent(myfilecontents);
window.open(url, '_blank');
window.focus();

{% endhighlight %}

## Step 4
In case the above doesn’t work you may need to do the following first:

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

As Beyond Compare also supports comparisons of directories, you may wish to download 2 sets of wireframes (into different directories), and then – rename them so that they are easier to compare.

The fastest method for this is via Windows Powershell.

Because the filenames are subtly different, they are difficult to compare.

To fix:

- Access each directory via the Powershell command line.
- Execute the following command, replacing text to match your own filenames:

{% highlight powershell %}

Dir | Rename-Item -NewName { $_.name -replace "http_mfdk5s.axshare.com_","" }

{% endhighlight %}

### Result:

- Filenames now match
- Because the filenames match, you can rapidly compare both sets of files via Folder compare; (Double-clicking the wireframe brings up visual compare)

### Limitations:

- Due to the unpredictability of image capture/compression algorithms, Beyond Compare will detect a lot more “differences” than actually exist between the wireframe images.
  - For example, Beyond compare will detect slight differences in random pixels within the images… as such, in many cases you will be required to eyeball the two wireframes, rather than automatically letting you know that the wireframes are approximately identical.
- In theory, it should be possible to systematically ignore differences in images that are still 99.9% similar.
- I haven’t been able to find a way to alter the tolerance that is applied to this mechanism (If someone finds a way, please let me know :smile: ).
- Regardless; I do find the folder compare useful, as you are able to open both the before and after images in a single operation, without having to search/open each file independently.