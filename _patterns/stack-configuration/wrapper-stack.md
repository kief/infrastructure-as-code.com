---
layout: pattern
title:  "Wrapper Stack Pattern"
date: 2019-02-05 16:52:43 +0000
category: Stack Configuration Patterns
order: 23
published: true
status: review
---

A Wrapper Stack is an [infrastructure stack project](/patterns/stack-replication/) which is used to import stack code from a module, and pass configuration values for a specific stack instance. This is essentially a mechanism to [configure stacks](/patterns/stack-configuration/).


<figure>
  <img src="images/wrapper-stack.png" alt="A Wrapper Stack is an infrastructure stack project which is used to import stack code from a module, and pass configuration values for a specific stack instance"/>
  <figcaption>A Wrapper Stack is an infrastructure stack project which is used to import stack code from a module, and pass configuration values for a specific stack instance.</figcaption>
</figure>


## Implementation

The implementation of wrapper stacks tend to look like [singleton stacks](/patterns/stack-replication/singleton-stack.html), in that each stack instance has its own stack source code project. The difference is that the per-instance wrapper stack project has very little code in it.

The code that defines the infrastructure elements for the stack is maintained in a module, so there is a single copy of the code shared across all instances, as with a [template stack](/patterns/stack-replication/template-stack.html). The wrapper stack project for each instance contains only configuration parameters for that specific instance of the stack. So this pattern can be seen as an alternative way to implement a template stack.

In some cases, wrapper stacks may be used to customize a core stack project to a wider extent than passing configuration parameters, essentially turning into the [library stack pattern](/patterns/stack-replication/library-stack.html). This may be appropriate, as long as the intention is for each of the different stack instances to be used for different purposes.

When the instances are intended to be duplicates of the same infrastructure, as with environments used for testing and delivering applications, this kind of variation between instances tends to create inconsistency across environments, diluting their value for accurate replication. In these cases, each wrapper stack should be kept minimal, used strictly as a configuration mechanism rather than a way to extend or alter the core stack structure.


## Tools

The wrapper stack pattern is supported by tools such as [Terragrunt](https://github.com/gruntwork-io/terragrunt), which also acts as a [stack orchestration tool].
