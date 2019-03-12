---
layout: pattern-group
title:  "Patterns for Replicating Infrastructure"
date: 2019-03-12 09:32:50 +0000
category: Stack Replication Patterns
section: true
order: 1
published: true
status: review
---

Most organisations need to run multiple copies of infrastructure, whether it's multiple environments for testing a system, or separate instances of an application for different customers. This pattern catalogue describes the concept of an [infrastructure stack](/patterns/stack-concept/) as a collection of infrastructure defined and provisioned as a unit - a Terraform project, CloudFormation stack, etc. There are different ways to replicate infrastructure in relation to these stacks. Some of these ways are useful, which are described here as patterns. Other ways are best avoided, which are described as antipatterns.


## [Template stack pattern](template-stack.html)

With the [template stack pattern](/patterns/stack-replication/template-stack.html), a stack source code project is implemented so that it can be used to create multiple instances of the stack in a consistent way.


<figure>
  <img src="images/template-stack.png" alt="A Template Stack is an infrastructure stack project that is designed to be replicated consistently"/>
  <figcaption>Figure 1. A Template Stack is an infrastructure stack project that is designed to be replicated consistently.</figcaption>
</figure>


## [Singleton stack antipattern](singleton-stack.html)

The [singleton stack antipattern](singleton-stack.html) is a naive implementation, where each stack instance is defined and managed by its own separate copy of the stack source code. This is useful for very simple use cases, particularly when learning something, but it isn't a suitable approach for important infrastructure.


<figure>
  <img src="images/singleton-stack.png" alt="A singleton stack has a separate copy of the source code project for each instance"/>
  <figcaption>Figure 2. A singleton stack has a separate copy of the source code project for each instance.</figcaption>
</figure>


Note that the [wrapper stack pattern](/patterns/stack-configuration/wrapper-stack.html) is essentially implemented like a singleton stack. However, this isn't considered to be an antipattern because each instance project contains only configuration parameters, not infrastructure definition code.


## [Many-headed stack antipattern](many-headed-stack.html)

A Many-Headed Stack defines multiple copies of infrastructure in a single stack project. For example, if there are three environments for testing and running an application, a single Terraform project (and single statefile) includes the code for all three of the environments.


<figure>
  <img src="images/many-headed-stack.png" alt="A many-headed stack manages the infrastructure for multiple environments in a single stack project"/>
  <figcaption>Figure 3. A many-headed stack manages the infrastructure for multiple environments in a single stack project.</figcaption>
</figure>


