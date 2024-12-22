---
layout: page
permalink: /people/
title: People
description:
nav: true
nav_order: 2
---

{% assign groups = site.people | sort: "group_rank" | map: "group" | uniq %}
{% for group in groups %}

## {{ group }}

    {% assign members = site.people | sort: "lastname" | where: "group", group %}
    {% for member in members %}
<p class="team">
{% if member.inline == false %}
    {% if member.profile.website %}
        <a href="{{ member.profile.website }}" target="_blank" style="text-decoration: none">
    {% else %}
        <a href="{{ member.url | relative_url }}" style="text-decoration: none">
    {% endif %}
{% endif %}
    <div class="team card {% if member.inline == false %}hoverable{% endif %}">
        <div class="row no-gutters">
            <div class="col-sm-4 col-md-3">
                {% assign profile_image_path = member.profile.image | prepend: 'assets/img/' %}
                {% include figure.liquid loading="eager" path=profile_image_path class="card-img img-fluid" %}
            </div>
            <div class="col-sm-8 col-md-9">
                <div class="card-body"> 
                    <h5 class="card-title">{{ member.profile.name }}</h5>
                    {% if member.profile.position %}<h6 class="card-subtitle mb-2 text-muted">{{ member.profile.position }}</h6>{% endif %}
                    <p class="card-text">
                        {{ member.teaser }}
                    </p>
                    <br/>
                    <p class="card-text">
                        <small class="test-muted"><i class="fas fa-thumbtack"></i> {{ member.profile.address | replace: '<br />', ', ' }}</small>
                    </p>
                </div>
            </div>
        </div>
    </div>
{% if member.inline == false %}</a>{% endif %}
</p>
<br/>
    {% endfor %}
{% endfor %}

