---
layout: pattern
title:  "Multi-Service Stack Pattern"
date: 2019-02-12 09:38:53 +0000
category: Stack Structural Patterns
order: 14
published: true
status: review
---

A Multi-Service Stack hosts multiple applications in a single instance of the [infrastructure stack](/patterns/stack-concept/).

For example, a search application might involve running several services - a front end UI, an indexing service, a search API service, and a data store. Defining the infrastructure for all of these services together may make it easier to manage the application as a whole. This works well when a single team owns the infrastructure and deployment of all of the pieces of the application, so the boundaries of the stack match the boundaries of the team.

A drawback with this pattern is that the stack can become unwieldy, tending towards a [monolith](monolithic-stack.html). It can be difficult to make a small change to a single service without risking disruption to other applications running on the stack.

Generally speaking, multi-service stacks are sometimes a useful part of an incremental strategy of splitting a monolithic stack into [smaller stacks](micro-stack.html), with an aim of ending up with [single service stacks](single-service-stack.html) or even [cross-stack services](cross-stack-service.html) where appropriate.

There are situations where a multi-service stack works well in the longer term. If the scope of applications and their infrastructure are clear, and does not often interfere with making changes and improvements, having a single unit can make it simpler to manage.
