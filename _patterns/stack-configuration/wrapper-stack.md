---
layout: pattern
title:  "Wrapper Stack Pattern"
date: 2019-03-27 08:00:00 +0000
category: Stack Configuration Patterns
order: 24
published: true
---

A Wrapper Stack is an [infrastructure stack project](/patterns/stack-concept/) which is a thin wrapper to create a specific stack instance, using infrastructure code shared in a [stack code module](/patterns/stack-concept/stack-code-module.html). The purpose of the wrapper is to define the [stack parameter values](/patterns/stack-configuration/) for stack instances managed using [template stacks](/patterns/stack-replication/template-stack.html).


<figure>
  <img src="images/wrapper-stack.png" alt="A Wrapper Stack is an infrastructure stack project which is used to import stack code from a module, and pass configuration values for a specific stack instance"/>
  <figcaption>A Wrapper Stack is an infrastructure stack project which is used to import stack code from a module, and pass configuration values for a specific stack instance.</figcaption>
</figure>


## Motivation

Wrapper stacks are used to manage parameter values for instances of a [template stack](/patterns/stack-replication/template-stack.html).

The appeal of the wrapper stack is that it exploits the infrastructure tool's module functionality to share code across projects. Support for features such as versioning, dependency management, and repositories, help to create a robust change management regime for infrastructure code.


## Applicability

It would arguably be better to implement full change and release management at the level of the full stack project, rather than as a module. Modules add a level of complexity which is intended for reusing smaller units of code between projects, rather than for defining an entire stack project.

But as of this writing, most stack management tools (Terraform, CloudFormation, etc.) don't directly support treating project code as a releasable artefact, but they usually do support it for modules. So the wrapper stack can be seen as a hack to leverage module versioning functionality to make up for lack of this functionality at the project level.


## Consequences

Because the wrapper stack is a complete stack configuration project, it is possible to add different infrastructure elements to different instances of the stack. This runs against the idea of the [template stack](/patterns/stack-replication/template-stack.html), which is to ensure highly consistent instances across environments. This in turn increases the work needed for effective testing regimes, because more different instances can vary enough that testing one instance doesn't accurately reflect the conditions of other instances.


## Implementation

The implementation of wrapper stacks tend to look like [singleton stacks](/patterns/stack-replication/singleton-stack.html), in that each stack instance has its own stack source code project. The difference is that the per-instance wrapper stack project has very little code in it.

The code that defines the infrastructure elements for the stack is maintained in a module, so there is a single copy of the code shared across all instances, as with a [template stack](/patterns/stack-replication/template-stack.html). The wrapper stack project for each instance contains only configuration parameters for that specific instance of the stack. So this pattern can be seen as an alternative way to implement a template stack.

In some cases, wrapper stacks may be used to customize a core stack project to a wider extent than passing configuration parameters, essentially turning into the [library stack pattern](/patterns/stack-replication/library-stack.html). This may be appropriate, as long as the intention is for each of the different stack instances to be used for different purposes.

When the instances are intended to be duplicates of the same infrastructure, as with environments used for testing and delivering applications, this kind of variation between instances tends to create inconsistency across environments, diluting their value for accurate replication. In these cases, each wrapper stack should be kept minimal, used strictly as a configuration mechanism rather than a way to extend or alter the core stack structure.


## Known Uses

[Terragrunt](https://github.com/gruntwork-io/terragrunt) is a [stack orchestration tool](/patterns/stack-orchestration-tools/) that implements the wrapper stack pattern.


## Alternatives

An alternative is to implement versioning functionality for the stack project. For example, many teams package artefacts from Terraform, CloudFormation, and other projects as zip files or tarballs, adding version numbers and uploading them to shared file storage. Other teams use more general packaging and versioning systems to provide this, for example RPMs or even Docker images.

Parameter values can then be managed by using other patterns. [Stack instance configuration files](stack-instance-configuration-file.html) are very similar to wrapper stacks, without adding the ability to customize stack instances beyond passing parameter values.

