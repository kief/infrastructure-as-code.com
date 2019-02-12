---
layout: pattern
title:  "Single Service Stack Pattern"
date: 2019-02-12 09:30:20 +0000
category: Stack Structural Patterns
order: 13
published: true
status: review
---

A Single Service Stack defines the infrastructure specific to a single application in its own
[infrastructure stack](/patterns/stack-concept/).

Aligning the stack directly to the infrastructure for the one application or service means updates and other changes can be applied to it without directly affecting the infrastructure for other services. This is in contrast with a [multi-service stack](multi-service-stack.html), where the scope for a change may include infrastructure for other applications.

Limiting the scope for a change to one application reduces the scope of release coordination needed across applications and/or teams, which enables simplifying change management processes. These boundaries also help to keep code ownership clear, define the scope of testing, and make it easier to manage dependencies, keeping code decoupled.

Often, a system involves multiple services. When each service has its own infrastructure stack, different [multi-stack patterns](/patterns/multiple-stacks/) may be considered. For example, some stacks may exist to define [shared infrastructure](/patterns/multiple-stacks/shared-infrastructure-stack.html) for other stacks. Alternately, each single service stack may be designed as a [shared nothing stack](/patterns/multiple-stacks/shared-nothing-stack.html), to keep it independent of other stacks.

