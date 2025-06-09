---
layout: page
permalink: /papers/
title: Papers
description: A list of papers is also available on <a href='https://scholar.google.com/citations?user=5A_1NL0AAAAJ'><b>Google Scholar</b></a>.<br/><br/>We are fortunate to work with a diverse set of collaborators across various disciplines. Each of these disciplines follows different conventions for deciding on authorship order. However, these are just that—conventions. The true value of each contribution, however you define it, is often difficult to quantify. In that spirit, think of every project below as a result of a "team" effort, where every "player" brings their strengths to the field. Functionally, what this means is that some papers have authors listed in contributional order, while others list them in alphabetical order.
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
