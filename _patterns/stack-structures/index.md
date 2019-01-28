---
layout: pattern-group
title:  "Patterns For Structuring Stacks"
date:   2019-01-01 16:20:00
category: Stack Structural Patterns
order: 0
published: true
---

A key challenge with infrastructure design is deciding how to size and structure [stacks](/patterns/core-stack/). The infrastructure for a given system may be defined as a single stack, or spread across multiple stacks. Shared code may also be used across stacks.

It's very common to start by defining infrastructure in a single stack. However, this tends to grow over time, and can become an unmanageable [monolithic stack](monolithic-stack.html). The other end of the spectrum is the [micro stack](micro-stack.html) pattern, which divides the infrastructure into small, loosely coupled stacks that can be easily changed independently.

Deciding on appropriate sizing and boundaries for splitting stack is a particular challenge. One common strategy is the [single service stack pattern](single-service-stack.html), where each stack includes the infrastructure specific to a particular application or service. [Shared nothing stacks](shared-nothing-stack.html) take this to the extreme of ensuring that stacks do not have dependencies on other stacks.

More commonly, stacks do have dependencies, for example a service stack's infrastructure may use networking structures managed by another stack. [Stack integration patterns] is an important topic in infrastructure design.

So it is common to simplify infrastructure design by sharing infrastructure in this way, where infrastructure managed by one stack is used by other stacks. Another technique is to share common infrastructure code as a [stack module](stack-module.html), imported into multiple stack definitions.
