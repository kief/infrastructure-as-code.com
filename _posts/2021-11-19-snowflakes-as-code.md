---
layout: post
title:  "The Snowflakes as Code antipattern"
date:   2021-11-18 16:20:20
categories: book
published: false
---

One of the earliest benefits that drew people like me to infrastructure as code was the promise of eliminating [snowflake servers](https://martinfowler.com/bliki/SnowflakeServer.html). Back then, we built servers by logging into them and running commands.

We might build, update, fix, optimize, or otherwise change servers in different environments in different ways at different times. This led to (configuration drift)[http://kief.com/configuration-drift.html], inconsistencies across environments. Thanks to snowflakes and configuration drift, it was super common to spend huge amounts of effort to get an application build that worked fine in the development environment to deploy and run in production.

Flash forward 10+ years, infrastructure as code has become commonplace, helping us to manage (all kinds of stuff)[https://infrastructure-as-code.com/book/2018/03/28/defining-stacks.html] in addition to, and often instead of, servers. You'd think snowflake infrastructure would be a thing of the past.

But it's actually quite common to see people following practices that lead to differences between environments - _snowflakes as code_.


## Antipattern: Snowflakes as code

Snowflakes as code is an antipattern where multiple environments which are intended to run the same or similar workloads are each defined using a different set of infrastructure code.

![Multiple environments, each with its own set of code](/images/snowflakes-as-code.png)

Each environment's code may be very similar, and changes may be made by copying (or merging) code from one environment to the next. But copying is done manually, and often involves making changes to adapt or configure it for the specific environment.


## Motivation




## Applicability

## Consequences

## Implementation

## Known uses

## Related Patterns

