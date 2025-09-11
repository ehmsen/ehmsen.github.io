---
layout: single
title: Marathon CV
permalink: /cv-marathon/
classes: wide
---
{% assign marathon_races = site.races | where: "type", "Marathon" %}
Mit marathon CV - med i alt {{ marathon_races | size }} marathons.
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
{% for race in marathon_races reversed %}
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