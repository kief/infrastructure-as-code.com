---
layout: page
title:  "Overview of Infrastructure Patterns"
date:   2019-01-01 16:20:00
published: true
status: review
permalink: /patterns.html
---

(See the full [list of patterns](/patterns/list.html) that have been written so far.)


## What is this for?

This catalogue describes useful approaches for designing infrastructure which is defined as code, and managed like software. Each pattern in the catalogue describes a recurring and useful solution, giving the context in which it may be useful, and some advice on implementation.

These solutions are written as [design patterns](https://www.martinfowler.com/articles/writingPatterns.html), each of which should be relevant to any cloud or virtualization platform, and to any toolchain which defines infrastructure as code. The examples tend to use Terraform code and AWS infrastructure, because these are widely understood. But the concepts and techniques should be usable with others.

The goal of naming and documenting these patterns is to have a vocabulary that we can use in teams, and in the industry, to talk about how to do things. Different people may have different opinions about the best way to solve a certain problem in a particular situation, but at least we should have a common frame of reference for a conversation.

This catalogue is a work in progress. There are many topics I'd like to cover here, which will need additional patterns and sections. And I am continuously getting feedback and new ideas which drive me to revisit things I've already written.


## The main pieces

- Infrastructure platform
- Infrastructure stacks
- Server configuration

