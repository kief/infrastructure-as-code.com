---
layout: pattern
title:  "Micro Stack Pattern"
date:   2019-01-01 16:20:00
category: Stack Structural Patterns
published: false
---

Keeping stacks small.

Infrastructure for systems comprised of multiple services, and worked on by multiple people or teams, can become too unwieldy to manage as a single [stack](definition-of-a-stack.adoc). Designing (or evolving) infrastructure into multiple, smaller Micro Stacks is a useful way to keep system design loosely coupled and easier to change. This architectural style is heavily influenced by [microservices](https://martinfowler.com/articles/microservices.html), and many of the same forces, principles, and practices apply.


== Componentization of infrastructure

A key driver of microservice as micro stacks is to organize a system into clearly defined components. There are different ways to do this with infrastructure, of which micro stacks are only one.

Modules, such as [Terraform modules](https://www.terraform.io/docs/modules/index.html) and [CloudFormation nested stacks](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-nested-stacks.html), are code that is included into a stack definition. A module offers a way to re-use code across stacks. However, a module is not changed separately, it is changed as part of a single stack.

Infrastructure elements can be defined using a different mechanism from stack definitions, such as a server configuration tool like Ansible, Chef, or Puppet, or a server image definition tool like Packer. A stack definition will often include servers as elements of the stack. In these cases, the configuration of the server itself is delegated to a separate tool with its own definition files. There are different ways to orchestrate the use of these tools within a stack (to be defined in "Server Management" patterns).

Applications are also often defined and provisioned using a separate mechanism to the stack management, although these again need to be orchestrated with the stack. (See application deployment patterns)


== More specific patterns for micro stacks

Single service stack, Multi-stack service


