---
layout: pattern
title:  "Stack Instance Script Pattern"
date: 2019-03-13 12:23:00 +0000
category: Stack Configuration Patterns
order: 22
published: true
status: review
---

A separate script, such as a shell script or batch file, can be written to provide the [stack management tool](/patterns/stack-concept/) with the appropriate values for the each stack instance.


## When to use it

This is a fairly simple implementation, which might be useful when there are a limited number of stack instances, and when the command needed to apply the stack is simple.


## Implementation

Typically, there is a separate script for each stack instance:


~~~ console
our-infra-stack/
  ├── bin/
  │   ├── test.sh
  │   ├── staging.sh
  │   └── production.sh
  ├── src/
  └── test/
~~~


Each script simply runs the command with the relevant parameter values hard-coded:

~~~ bash
#!/bin/sh
terraform apply \
    -var 'environment_id=test' \
    -var 'cluster_minimum=1' \
    -var 'cluster_maximum=1'
~~~



## Challenges

Unfortunately, it's very common for the commands used to run the script to become more complicated. This can make it difficult to keep all of the different stack instance scripts consistent. It also means the logic of these scripts becomes complicated, which creates opportunity for errors unless they are well tested.


## Related patterns and topics

In essence, this pattern is pretty much the same as the [wrapper stack](wrapper-stack.html), simply implemented as a script rather than a stack definition. If the script becomes more complicated, then it will rapidly evolve into a [stack orchestration tool](/patterns/stack-orchestration-tools/).

