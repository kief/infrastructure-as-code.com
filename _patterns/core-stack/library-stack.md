---
layout: pattern
title:  "Library Stack Pattern"
date:   2019-01-01 16:20:00
category: Core Stack Patterns
order: 3
published: false
---


It is often useful to define basic, re-usable stack code that can be customized to define different stacks with more specific attributes. For example, you may define a stack that defines a load balancer, but allow it to be customized to manage different types of network traffic. A basic load balancer stack might be used to create an HTTP load balancer. This stack could then be extended to create an HTTPS load balancer, adding configuration and code to provision SSL certificates.


## Alternative to:

- Stack Module (re-uses infrastructure code at a different level)

# Pattern: Extensible Stack

It is often useful to define basic, re-usable stack code that can be customized to define different stacks with more specific attributes. For example, you may define a stack that defines a load balancer, but allow it to be customized to manage different types of network traffic. A basic load balancer stack might be used to create an HTTP load balancer. This stack could then be extended to create an HTTPS load balancer, adding configuration and code to provision SSL certificates.

Extending an extensible stack definition creates a new stack definition, which can be used to create multiple instances. So the HTTPS load balancer stack definition is treated as its own stack definition, which happens to import the base load balancer code.

An extensible stack is different from a [stack module](stack-module.adoc), which is code that can be imported into a stack definition, but which is not a complete stack in itself. An extensible stack can be used to create an infrastructure instance on its own, although it may or may not be very useful without changes.

This may be more of a pedantic difference. In practice, the distinction is an implementation detail of the tooling. For example, you can put load balancer definition code into a Terraform module. This can't be provisioned on its own, without creating a Terraform project, so we'd consider this a stack module rather than a stack library. A Terraform stack library for a load balancer, on the other hand, would be a complete Terraform project, that can be provisioned. Extending it would be a matter of importing the load balancer terraform code, then adding some more terraform files to extend its behavior.

(There is some question as to whether this is really a common pattern, or more a theoretical one?)

Extensible stacks are related to [parameterized stacks](parameterized-stack.adoc). Instances of a parameterized stack can only be customized with simple variables, such as strings, numbers, and perhaps lists or hashes. An extensible stack, on the other hand, can be customized by adding further code. For example, an extensible stack definition for a postgres database cluster may include the code for a basic servers and storage, but need further code to define networking configuration to connect the database to application infrastructure for more specific use cases.

An analogy can be made to object oriented software code. An extensible stack definition is like a base class, which can be extended to add behaviors.

