---
layout: pattern
title:  "Template Stack Pattern"
date: 2019-03-27 08:00:00 +0000
category: Stack Replication Patterns
order: 2
published: true
---

A Template Stack is an [infrastructure stack](/patterns/stack-concept/) source code project that is used to create multiple instances of the same thing. This is in contrast to [singleton stacks](singleton-stack.html), where a separate copy of the source code is maintained for each stack instance, and the [many headed stack](many-headed-stack.html), where multiple environments are all included in a single stack.


<figure>
  <img src="images/template-stack.png" alt="A Template Stack is an infrastructure stack project that is designed to be replicated consistently"/>
  <figcaption>A Template Stack is an infrastructure stack project that is designed to be replicated consistently.</figcaption>
</figure>


## Also known as

- Cookie Cutter Stack
- Reusable Stack


## Motivation

You want to have multiple instances of infrastructure which are effectively identical. When you make changes to the stack code, you want to apply and test it in one instance, and then use the code to update and create multiple other stack instances without needing to test the others. You want to provision new instances of the stack with minimal ceremony, maybe even automatically.

The ability to provision and update multiple stacks from the same template enhances scalability - more instances can be managed with less effort; reliability - changes can be made with lower risk of failure; and throughput - improvements can be rolled out to more systems more quickly.


## Applicability

Template stacks are most often used to define infrastructure for multiple environments in a "path to production" - development, testing, staging, etc. This ensures that infrastructure is the same in each environment, which increases the reliability of software testing and release process.

Infrastructure may also be duplicated for multiple services, products, customers, or locations by maintaining a single template stack project. For example, a stack template can define the infrastructure for an e-commerce storefront application. A separate stack instance can be provisioned for each business customer. Changes made to the stack code are extensively tested in a separate test instance, after which they can be safely rolled out to the instances for all of the customers.

Template stacks can also be used to replicate infrastructure across geographical locations, to provide failover and/or scalability.


## Consequences

Template stacks should be designed to keep variations between instances to a minimum. The more different instances can be different from one another, the less confidence there is that instances can be provisioned or updated without significant testing.

As a rule, the parameters used to define differences between stack instances should be very simple - strings, numbers, or in some cases lists. Additionally, different infrastructure elements should not be provisioned in different instances from the same stack template.

When the differences between template stack instances do become more complicated, this is usually a [design smell](https://en.wikipedia.org/wiki/Design_smell). Consider ways to restructure the infrastructure, possibly into multiple stacks, to keep each stack template simple and consistent.


## Implementation

A template stack is created by creating an infrastructure stack project, and then running the infrastructure management tool separately to provision or update each instance. The stack tool will have a way to tell it which instance you want to create or update. For example, with Terraform you would specify a different statefile or workspace for each instance. With CloudFormation, you pass a unique stack ID (`--stack-name`) for each instance.

This may be a commandline parameter, as with this example using a fictional tool called "stack":


~~~ console
> stack up instance_id=staging
~~~


Some names or identifiers in the infrastructure code may create clashes between instances running in the same platform context (e.g. in the same AWS Account). If an identifier is required to be unique in that context, trying to create two instances from the stack code will probably fail. Here is a pseudo-code example of stack code that defines a server:


~~~ yaml
server:
  name: appserver
  subnet_id: appserver-subnet
~~~


In this example, running the stack tool to create the second stack instance will fail, because the server already exists:


~~~ console
> stack up instance_id=development
SUCCESS: stack 'development' created
> stack up instance_id=staging
FAILURE: server 'appserver' already exists in another stack
~~~


One way to avoid this is to only create one instance in a given context. This is usually impractical, due to the overheads of having multiple platform contexts of this kind.

A more useful approach to avoid clashes is parameterizing names and identifiers. Infrastructure stack languages have variable features that can be used for this.

The earlier pseudo-code definition for a server is updated below to use a variable to avoid clashes between instances:


~~~ yaml
server:
  name: appserver-${instance_id}
  subnet_id: appserver-subnet-${instance_id}"
~~~


In many cases, it's necessary to define other elements of a stack differently by instance. For example, some elements may have different sizes in different environments, such as server sizes, or minimum and maximum cluster sizes. More pseudo-code:


~~~ yaml
cluster:
  name: appserver-cluster-${instance_id}
  server_role: appserver
  minimum: ${cluster_minimum}
  maximum: ${cluster_maximum}
~~~


This allows the cluster size range to be set smaller for development and test environments, and larger for production.

Different patterns for setting variables for stack instances are described in the [stack configuration patterns](/patterns/stack-configuration/) section of this pattern catalogue. 


## Related patterns

Some teams use the [singleton stack anti-pattern](singleton-stack.html) to manage multiple instances of a stack. This involves creating a new copy of the stack code for each new environment or other instance. While this is a straightforward approach to implement, it makes it difficult to keep each instance consistent.

[Stack code modules](/patterns/stack-concept/stack-code-module.html) allow code to be defined once, and then shared across multiple stacks. But unlike a template stack project, a stack module is not used directly to create infrastructure. Instead, it is imported into a stack project, which is then used to provision infrastructure.

Like a template stack, [wrapper stacks](/patterns/stack-configuration/wrapper-stack.html) are used to create multiple stack instances from a single codebase. However, the infrastructure code for a wrapper stack is defined in a [module](/patterns/stack-concept/stack-code-module.html), and a separate stack project is created for each instance, to define the instance-specific parameters.

Stack instances will need to be configured using the appropriate [stack configuration pattern](/patterns/stack-configuration/index.html).

The various [stack structure patterns](/patterns/stack-structures/index.html) may be useful to consider how to keep each template stack simple and consistent.

