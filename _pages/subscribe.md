---
layout: page
title: Subscribe
permalink: /subscribe/
desc: Subscribe to email newsletter
permalink: /subscribe
adverts: disable
---

Provide your email address to be notified of new articles.

## Subscribe via email
 <form class="emailSubscribeForm"
    action="https://tinyletter.com/jackbarker"
    method="post"
    target="popupwindow"
    onsubmit="window.open('https://tinyletter.com/jackbarker', 'popupwindow', 'scrollbars=yes,width=800,height=600');return true"
    aria-label="Email subscription form">
    <p>
        <label for="tlemail">Enter your email address</label>
    </p>
    <p>
        <input type="email" style="width:140px" name="email" id="tlemail" required aria-describedby="subscribe-help" />
    </p>
    <p id="subscribe-help" class="help-text">You'll receive notifications when new articles are published.</p>
    <input type="hidden" value="1" name="embed"/>
    <input type="submit" value="Subscribe" aria-describedby="powered-by"/>
    <p id="powered-by" class="poweredByTL">
        <a href="https://tinyletter.com" target="_blank">powered by TinyLetter</a>
    </p>
 </form>


## Subscribe via RSS
<ul>
    <li><a href="{{ "/feed.xml" | prepend: site.baseurl }}">RSS Feed ("Excerpt only" format)</a></li>
    <li><a href="{{ "/longform-feed.xml" | prepend: site.baseurl }}">RSS Feed ("Full article" format)</a></li>
</ul>