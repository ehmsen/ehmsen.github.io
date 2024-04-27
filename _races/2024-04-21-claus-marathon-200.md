---
title: >
    Claus<br/>
    Nummer 200
date:   2024-04-21
type: Marathon
distance: 42.2
time: "3:55:59"
excerpt: "Claus løb sit marathon nr. 200 en fantastisk flot morgen i Silkeborg"
header:
    teaser: "7.jpeg"
    overlay_image: "7.jpeg"
    # overlay_filter: 0.3 # same as adding an opacity of 0.5 to a black background
    # show_overlay_excerpt: false
tagline: >
    Claus<br/>
    Nummer 200
gallery:
    - 1.jpeg
    - 2.jpeg
    - 3.jpeg
    - 4.jpeg
    - 5.jpeg
    - 6.jpeg
    - 7.jpeg
    - 8.jpeg
    - 9.jpeg
    - 10.jpeg
    - 11.jpeg
    - 12.jpeg
    - 13.mov
    - 14.jpeg
    - 15.jpeg
    - 16.jpeg
    - 17.jpeg
published: true
---

{% include gallery.html %}

<div class="side-by-side-container">
  <div class="side-by-side-item">
    <iframe width="100%" height="100%" src="/assets/posts/{{ page.date | date: '%Y-%m-%d' }}/diplom.pdf"></iframe>
  </div>
  <div class="side-by-side-item">
    {% include strava.html id=11230576591 %}
  </div>
</div>