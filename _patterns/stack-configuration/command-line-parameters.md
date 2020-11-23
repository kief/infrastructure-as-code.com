---
layout: pattern
title:  "Command-line Stack Parameters Pattern"
date: 2019-03-28 10:07
category: Stack Configuration Patterns
order: 21
published: false
---

The simplest way to provide values for a [stack instance](/patterns/stack-concept/) is to pass the values on the command line.


## Motivation/Applicability

Running the command-line and passing parameters is useful for exploring the use of a tool, or for testing infrastructure code in a sandbox environment (an environment instance that is only used by the person working on their copy of the infrastructure project code). You can easily experiment with different values and see the effect.

This may also be a valid approach for a stack whose configuration is exceedingly simple, for example where there is only a single parameter.


## Consequences

Manually typing parameter values on the command line is less useful for managing infrastructure instances that anyone other than you relies on, since it is easy to make a mistake that damages the environment. It also makes it difficult to ensure consistency, as different values may be accidentally passed when the command is run for updates.


## Implementation

[Template stacks](/patterns/stack-replication/template-stack.html) typically define parameters which can be set differently for different instances of the stack. For example, a stack that is used to create a web server cluster may have different values for the sizing of the cluster in different environments:


| Stack Instance | environment_id | cluster_minimum | cluster_maximum |
|-------|--------|---------|
| webserver_test | test | 1 | 1 |
| webserver_staging | staging | 1 | 2 |
| webserver_production | production | 2 | 5 |


With the command-line parameter pattern, the values are simply passed on the command-line when running the stack management tool. For example, with a fictional tool called "stack":


~~~ console
stack up \
    environment_id=test \
    cluster_minimum=1 \
    cluster_maximum=1
~~~


The challenge with this is that it requires the person running the command to remember which values to pass, so is prone to errors.


## Related Patterns

There are a number of alternative patterns for [configuring stacks](/patterns/stack-configuration/) that may be considered to improve on this.

Other patterns for configuring stack instances include [stack instance scripts](stack-instance-script.html), [stack instance configuration files](stack-instance-configuration-file.html), [wrapper stacks](wrapper-stack.html), [pipeline-defined parameters](pipeline-defined-parameters.html), and [a stack parameter registry](stack-parameter-registry.html).

