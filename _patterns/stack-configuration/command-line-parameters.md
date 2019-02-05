---
layout: pattern
title:  "Commandline Stack Parameters Pattern"
date:   2019-01-01 16:20:00
category: Stack Configuration Patterns
order: 21
published: true
status: review
---

The simplest way to provide values for a [stack instance](/patterns/core-stack/) is to pass the values on the command line.

[Template stacks](/patterns/core-stack/template-stack.html) typically define parameters which can be set differently for different instances of the stack. For example, a stack that is used to create a web server cluster may have different values for the sizing of the cluster in different environments:


| Stack Instance | environment_id | cluster_minimum | cluster_maximum |
|-------|--------|---------|
| web_test | test | 1 | 1 |
| web_staging | staging | 1 | 2 |
| web_production | production | 2 | 5 |



With this pattern, these values are simply passed on the commandline when running the stack management tool. For example:


~~~ console
terraform apply \
    -var 'environment_id=test' \
    -var 'cluster_minimum=1' \
    -var 'cluster_maximum=1'
~~~


The challenge with this is that it requires the person running the command to remember which values to pass, and is prone to errors.

There are a number of alternative patterns for [configuring stacks](/patterns/stack-configuration/) that may be considered to improve on this.


