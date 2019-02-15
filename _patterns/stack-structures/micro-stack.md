---
layout: pattern
title:  "Micro Stack Pattern"
date: 2019-02-12 09:38:53 +0000
category: Stack Structural Patterns
order: 12
published: true
status: review
---

The Micro Stack pattern involves dividing a system into multiple, loosely coupled [infrastructure stacks](/patterns/stack-concept/), so that it is easy manage them independently.

Designing (or evolving) infrastructure into multiple, smaller Micro Stacks is a useful way to keep system design loosely coupled and easier to change. Smaller stacks are quicker to provision and test.

Micro stacks can also be useful where there is a need to manage multiple instances of stacks within an overall deployed system, for instance for scaling and availability. In addition to the advantages of being able to quickly provision and destroy smaller stacks, each stack can be scaled and distributed independently. In some high volume scenarios it is useful to be able to scale up the number of some parts of the system, without having to scale everything in the same ratio. For example, a system may be able to handle peak volumes by deploying more instances of front end services across locations, without needing to deploy the same number of additional instances of back end services.

This architectural style is heavily influenced by [microservices](https://martinfowler.com/articles/microservices.html), and many of the same forces, principles, and practices apply.


## Related patterns

The appropriate sizing of stacks is very dependent on the situation. Micro stacks are the opposite end of the spectrum from a [monolithic stack](monolithic-stack.html), where all of the infrastructure for a system is defined in a single stack.

A [multi-service stack](multi-service-stack.html) is a step away from a monolith, where each stack contains the infrastructure for multiple, related applications. [Single service stacks](single-service-stack.html) define the infrastructure specific to one particular application or service in each stack.

Breaking things down to the next level, a [cross-stack service](cross-stack-service.html) splits the infrastructure for a single application across multiple stacks, for example splitting web servers, application servers, database servers, etc. each into their own stack.


