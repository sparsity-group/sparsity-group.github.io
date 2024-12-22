---
layout: page
permalink: /papers/
title: Papers
description: A list of papers is also available on <a href='https://scholar.google.com/citations?user=5A_1NL0AAAAJ'><b>Google Scholar</b></a>.
nav: true
nav_order: 3
---

<!-- _pages/papers.md -->

<!-- Bibsearch Feature -->

{% include bib_search.liquid %}

<div class="publications">

{% bibliography -f submitted --group_by type %}

{% bibliography -f published %}

</div>
