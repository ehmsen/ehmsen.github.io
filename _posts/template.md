---
title:  "Lang tur søndag morgen efter stormen"
date:   2023-10-22
tags:
    - træning
header:
    teaser: "/assets/photos/IMG_8493.jpeg"

    # image: "/assets/photos/IMG_8493.jpeg"
    # caption: "Photo credit: [**Unsplash**](https://unsplash.com)"

    overlay_image: "/assets/photos/IMG_8493.jpeg"
    overlay_filter: 0.4 # same as adding an opacity of 0.5 to a black background
    show_overlay_excerpt: false
excerpt: "Some excerpt"
tagline: "Some tagline"
published: false

gallery:
  - url: /assets/photos/IMG_8492.jpeg
    image_path: /assets/photos/IMG_8492.jpeg
    alt: "placeholder image 1"
    title: "Image 1 title caption"
  - url: /assets/photos/IMG_8493.jpeg
    image_path: /assets/photos/IMG_8493.jpeg
    alt: "placeholder image 2"
    title: "Image 2 title caption"

feature_row:
  - image_path: /assets/photos/IMG_8492.jpeg
    alt: "placeholder image 1"
    title: "Placeholder 1"
    excerpt: "This is some sample content that goes here with **Markdown** formatting."
  - image_path: /assets/photos/IMG_8493.jpeg
    alt: "placeholder image 2"
    title: "Placeholder 2"
    excerpt: "This is some sample content that goes here with **Markdown** formatting."
    url: "#test-link"
    btn_label: "Read More"
    btn_class: "btn--inverse"
---

Hej med dig

{% include strava.html id=10082509344 %}

{% include gallery caption="This is a sample gallery with **Markdown support**." %}

Hep hey

![Hep hey](/assets/photos/IMG_8492.jpeg)

{% include feature_row %}

![Hep hey](/assets/photos/IMG_8493.jpeg)

<div class="side-by-side-container">
  <div class="side-by-side-item">
    <iframe width="100%" height="100%" src="/assets/diplomer/2023-03-04.pdf"></iframe>
  </div>
  <div class="side-by-side-item">
    {% include strava.html id=8657343541 %}
  </div>
</div>