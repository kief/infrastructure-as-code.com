---
layout: post
title:  "How to join stacks (Part 3 of Splitting and joining stacks)"
date:   2018-07-18 16:20:00
categories: book
published: false
---

How to integrate different stacks

A provider stack creates stuff that consumer stacks need

Example:
- Networking (VPC, subnets, etc.)
- Multiple application stacks (LB, Server instances, DB)

Example:
- Monitoring service stack
- Multiple application stacks


# Integration patterns:

## State-level integration

The consumer stack looks into the statefile of the provider stack.

This is highly coupled to the tooling. It may also be coupled to the data structures of the tooling. For example, when the tool changes the format of the statefile, the provider and all of its consumers must be upgraded to the same version of the tooling at once. This kind of upgrade is highly disruptive, generally meaning all teams must pause other work and coordinate. As a result, the upgrade is typically postponed, leaving people using older versions of software for a while, which can create security hazards.

This can be mitigated by the tool vendor, if they implement backwards compatibility in their tooling. But this adds complexity to the tool code, overloading the purpose of the statefile.


## API-level integration

The consumer stack searches for infrastructure elements created by the provider, using names, tags, etc.

Dependent on carefully managing the things that are used for integration. Someone might make a change to provider infrastructure code, such as the name of something - without knowing how it is used by consumers.

So the things used for integration, whether it's naming, tags, or a combination - must be treated as an API. Tests can help to manage this; tests can be used to document the naming and tagging standards that other code depends on. Running these tests in the consumer pipeline will flag changes that break dependencies.


## Variable orchestration

A wrapping process (build tool) reads output variables when provisioning the provider stack, and feeds them into the consumer stack.

This requires the same wrapper process be used to provision providers and consumers, so that it has access to the relevant variables. So not likely to scale. Also, arguably, puts too much knowledge of the infrastructure being managed into the wrapper tool.


## Configuration registry

The provider stack publishes integration points to a central location, the consumer stack reads them from there.

The configuration registry becomes an API, so as before, testing can be used to ensure contracts are clearly defined and followed.

The registry is also a single point of failure. Distributed systems can help. More simple, robust systems can also be useful - a VCS, static file hosting, etc.
