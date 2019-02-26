---
layout: pattern-group
title:  "Design Principles for Infrastructure"
date: 2019-02-26 09:32:50 +0000
category: Stack Concept
section: true
order: 1
published: false
status: review
---

- Make sure code produces consistent results. Don't have loads of conditionals and whatnot that mean the result is highly variable. If you do, then you need to test it for each configuration.
