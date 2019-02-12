---
layout: pattern-group
title:  "Patterns for Replicating Stacks"
date: 2019-02-12 09:30:20 +0000
category: Stack Replication Patterns
section: true
order: 1
published: true
status: review
---

Most organisations need to run multiple [infrastructure stacks](/patterns/stack-concept/), whether it's multiple environments for testing a system, multiple instances of a service for different purposes, and/or multiple deployable applications and services.


### Multiple stack instances

A single stack code project may be used to provision and manage multiple stack instances. There are two main patterns for this, which address different use cases.

The first pattern for reusing a stack project's code is a [template stack](template-stack.html), which aims to ensure consistency across instances. The common uses for this are: to provide consistent environments for testing software and other system elements; to test changes to the infrastructure code itself; or to replicate system elements for scaling, geographic available, or resilience. There is very little variation between instances of the stack, since the intention is for them to be replicas of the same system elements.


<figure>
  <img src="/patterns/stack-concept/images/stack-instances.png" alt="Multiple stack instances can be provisioned from a single stack code project"/>
  <figcaption>Figure 4. Multiple stack instances can be provisioned from a single stack code project.</figcaption>
</figure>


The second pattern for reusing a stack project's code is a [library stack](library-stack.html), where stack code is reused to create multiple instances which have similar infrastructure elements, but which are used for different purposes. For example, code that defines a database cluster may be used to create one stack instance for a product service database, a second instance for a customer service database, and a third instance for a transaction service database. Unlike template stacks, two instances of a given library stack may be very different, since they may serve different purposes.

The typical way to create multiple stack instances from a single stack code project, whether it's a template or library stack, is to provide options to the stack management tool to give each stack instance a unique identity.


~~~ console
terraform apply -var 'instance_id=A'
terraform apply -var 'instance_id=B'
~~~


With CloudFormation, this is done by setting a different stack name for each instance. If you pass it a stack name that doesn't exist, the tool creates a new instance. If the stack name does exist, then the tool re-applies the code to the existing stack elements.

Terraform uses a separate state file for each stack instance. The state file contains information used to map specific infrastructure elements provisioned in the platform to the code in the stack project. You pass arguments to the terraform command to tell it which statefile to use, so that it knows which stack instance to create or update.


## Patterns for replicating infrastructure stacks

* With the [singleton stack antipattern](singleton-stack.html), stack source code is only used to create one instance of the stack. If multiple stack instances are needed, the source code is copied and modified.
* A [many-headed stack antipattern](many-headed-stack.html) has multiple copies of stack code in a single stack project, typically to provision multiple environments.
* The [template stack pattern](template-stack.html) uses a single copy of stack source code to create multiple, highly consistent instances of a stack. Each instance is intended to represent the same stack, but in different conditions - different environments for testing, different locations for replication, etc.
* A [library stack](library-stack.html) also uses a single copy of stack source code to create multiple stacks. However, each instance is can be customized so that it serves a different purpose. One way to distinguish these two patterns is that once a version of a template stack code has been tested, it can be relied on to create stack instances that behave essentially the same. Library stacks, on the other hand, are customizable to the extent that testing either requires many different cases, or else separate testing cases are  needed for separate configurations. A library stack project can be used to provision stack instances, without needing to be included in a separate stack project.
* A [stack code module](stack-code-module.html) is a package of code that is packaged so that it can be used by a stack code project. A module can't be used on its own to provision a stack instance. Module code is usually intended to be shared and re-used across multiple stack projects.

