---
layout: pattern
title:  "Wrapper Stack Pattern"
date:   2019-01-01 16:20:00
category: Stack Structural Patterns
order: 4
published: false
---

A Wrapper Stack is an [infrastructure stack definition](/patterns/core-stack/) whose only purpose is to import a [stack module](/patterns/core-stack/stack-module.html) that contains most of the actual stack code.

This is usually a variation of the singleton stack, in that you have a definition for each stack instance, although that definition is just a wrapper.

