---
layout: pattern
title:  "Stack Instance Script Pattern"
date: 2019-03-28 10:07
category: Stack Configuration Patterns
order: 22
published: true
---

A separate script, such as a shell script or batch file, can be written to provide the [stack management tool](/patterns/stack-concept/) with the appropriate values for the each stack instance.


## Also Known As

- Environment scripts


## Motivation

This is a fairly simple implementation, which might be useful when there are a limited number of stack instances, and when the command needed to apply the stack is simple.


## Consequences

Unfortunately, it's very common for the commands used to run the script to become more complicated. This can make it difficult to keep all of the different stack instance scripts consistent. It also means the logic of these scripts becomes complicated, which creates opportunity for errors unless they are well tested.


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


Each script simply runs the command with the relevant parameter values hard-coded, as in this example using a fictional tool:

~~~ bash
#!/bin/sh
stack up \
    environment_id=test \
    cluster_minimum=1 \
    cluster_maximum=1
~~~


## Related Patterns

This pattern is essentially the same as the [wrapper stack](wrapper-stack.html), but implemented as a script per environment rather than as a stack project per environment. It is also very similar to the [stack instance configuration file](stack-instance-configuration-file.html) pattern, with the difference that the configuration files can't include logic, so are simpler.

Other patterns for configuring stack instances include [command line parameters](command-line-parameters.html), [pipeline-defined parameters](pipeline-defined-parameters.html), and [a stack parameter registry](stack-parameter-registry.html).
