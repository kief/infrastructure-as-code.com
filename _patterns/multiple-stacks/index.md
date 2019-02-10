---
layout: pattern-group
title:  "Patterns For Multiple Stacks"
date: 2019-02-07 12:54:30 +0000
category: Multiple Stack Patterns
section: true
order: 30
published: true
status: review
---

As a system grows, it often makes sense to divide the infrastructure into multiple [stacks](/patterns/core-stack/), in order to avoid a [monolithic stack](/patterns/stack-structures/monolithic-stack.html).

Breaking a system into multiple, smaller, and loosely coupled infrastructure stacks can make it easier and safer to make changes to the system. The "blast radius" for each change can be minimized to the contents of the given stack.

Typically, some infrastructure will be [shared across stacks](shared-infrastructure-stack.html). For example, one stack (a provider stack) may define a networking structure, into which a second stack (a consumer stack) provisions its servers. In these cases, defining and maintaining clear [integration points between stacks](/patterns/stack-integration/) is essential to keeping a multi-stack system easy to manage.

Some designers prefer to use [shared nothing stacks](shared-nothing-stack.html) to avoid dependencies between stacks, at least at the infrastructure level. This tends to involve duplication of infrastructure elements, such as network structures, since each stack has its own instances of these. But it does radically reduce the risk of breaking other stacks when making a change to one stack.
