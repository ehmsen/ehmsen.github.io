---
layout: single
permalink: /
classes: wide
tagline: Løb for livet!
header:
    overlay_image: "/assets/photos/header.avif"
    overlay_filter: 0.1 # same as adding an opacity of 0.5 to a black background
    show_overlay_excerpt: true
---
{% for post in site.posts limit:4 %}
  {% include archive-single.html type="grid" %}
{% endfor %}

<section class="page__content cf" markdown="1">
Løb er utroligt mange ting. Det er motion, det er naturoplevelser, det er at mærke grænserne og skubbe til dem, det er den indre dialog og bearbejde dagen, det er at jagte mål, det er socialt og 1000 andre ting.

Her på min blog deler jeg mine oplevelser og tanker om løb. Ikke så meget fordi mine tanker er nye og banebrydende eller fordi jeg tror andre vil finde det utroligt interessant, men mest fordi det er en måde for mig at forstå løb. 

Mine mål er klare, men de er langt fra den eneste årsage til at jeg løber hver dag:
- Blive medlem af <a href="https://klub100marathon.dk">Klub 100 Marathon</a>: At løbe 100 officielle marathons, og pt har jeg nået {{ site.races | where: "type", "Marathon" | size }}.
- Knække 3-timers-muren: At fuldføre et marathon under 3 timer er en drøm, jeg jagter. Min PR er lige nu {% assign race = site.races | where: "type", "Marathon" | sort: "time" | first %} {{ race.time }}.
- At bibeholde glæden ved løb og holde mig fysisk aktiv og i form, så jeg kan løbe 10 km når jeg runder 70 år.

Gennem denne blog håber jeg at dele min glæde ved løb. Selvom min historie måske ikke er unik, og informationerne kan findes andre steder, vil jeg inviterer dig til at følge med i mine løbeeventyr, udfordringer og triumfer på vejen.

**God læselyst og god løbetur!**
</section>