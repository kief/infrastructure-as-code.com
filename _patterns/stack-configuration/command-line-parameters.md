---
layout: pattern
title:  "Command-line Stack Parameters Pattern"
date: 2019-03-13 12:23:00 +0000
category: Stack Configuration Patterns
order: 21
published: true
status: review
---

The simplest way to provide values for a [stack instance](/patterns/stack-concept/) is to pass the values on the command line.


## When to use it

Running the commandline and passing parameters is useful for exploring the use of a tool, or for testing infrastructure code in a sandbox environment (an environment instance that is only used by the person working on their copy of the infrastructure project code). You can easily experiment with different values and see the effect.


## Challenges

Manually typing parameter values on the command line is less useful for managing infrastructure instance that anyone relies on, since it is easy to make a mistake that damages the environment. It also makes it difficult to ensure consistency, as different values may be accidentally passed when the command is run for updates.


## How to implement it

[Template stacks](/patterns/stack-replication/template-stack.html) typically define parameters which can be set differently for different instances of the stack. For example, a stack that is used to create a web server cluster may have different values for the sizing of the cluster in different environments:


| Stack Instance | environment_id | cluster_minimum | cluster_maximum |
|-------|--------|---------|
| web_test | test | 1 | 1 |
| web_staging | staging | 1 | 2 |
| web_production | production | 2 | 5 |



With this pattern, the values are simply passed on the commandline when running the stack management tool. For example:


~~~ console
terraform apply \
    -var 'environment_id=test' \
    -var 'cluster_minimum=1' \
    -var 'cluster_maximum=1'
~~~


The challenge with this is that it requires the person running the command to remember which values to pass, and is prone to errors.


## Alternatives

There are a number of alternative patterns for [configuring stacks](/patterns/stack-configuration/) that may be considered to improve on this.


