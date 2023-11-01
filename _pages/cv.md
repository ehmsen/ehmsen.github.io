---
layout: single
title: CV
permalink: /cv/
classes: wide
---
<table>
  <thead>
    <tr>
      <th>Dato</th>
      <th>Navn</th>
      <th style="text-align: center">Type</th>
      <th style="text-align: center">Distance</th>
      <th style="text-align: center">Tid</th>
    </tr>
  </thead>
  <tbody>
{% for race in site.races reversed %}
    <tr>
        <td>{{ race.date | date: "%Y-%m-%d" }}</td>
        <td><a href="{{ race.url }}">{{ race.title }}</a></td>
        <td style="text-align: center">{{ race.type }}</td>
        <td style="text-align: center">{{ race.distance }}</td>
        <td style="text-align: center">{{ race.time }}</td>
    </tr>
{% endfor %}
  </tbody>
</table>