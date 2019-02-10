---
layout: pattern
title:  "Cross-Stack Service Pattern"
date: 2019-01-31 14:48:13 +0000
category: Stack Structural Patterns
order: 15
published: true
status: review
---

Defining the infrastructure to host an application across multiple [infrastructure stacks](/patterns/core-stack/) is the Cross Stack Service pattern. This is a variation of the [micro stack pattern](micro-stack.html).

For example, the infrastructure for an application might be divided into one stack for an application server pool, a second stack for a database cluster, and a third stack for networking structures. Defining separate infrastructure stacks for each of these means that each piece can be independently changed and improved, which may speed up the time needed to apply a change. Different parts of the application may also have different scaling characteristics, in which case it is useful to be able to provision multiple instances of some services without needing to replicate the entire application's infrastructure.

This pattern may in some cases be similar to the [single service stack](single-service-stack.html), where a single application runs on its own infrastructure stack. It is in contrast with the [multi-service stack](multi-service-stack.html), where a single stack instance contains multiple applications.


## Splitting stacks by lifecycle

A particularly good reason to use this pattern is where there is clearly value in having a different lifecycle for different parts of the application. Factors that suggest different lifecycles may be useful include persistent data, provisioning time, and cost.

When an application uses data that needs to be persistent, it can be easier to manage this by defining the infrastructure that holds the data separately. A database cluster is an obvious example, although this can also be done at the level of a mountable disk volume, such as an AWS EBS volume. When this is defined in its own stack, it is simple to destroy, rebuild, and replace other parts of the application as needed, without fearing the loss of data. Destroying infrastructure that holds data may involve time consuming restores of backup data, possibly involving a loss of data depending on the frequency that backups are taken.

Other parts of an application's infrastructure may be time consuming to rebuild. This is often true of networking structures, particularly externally facing ones such as public IP addresses, DNS names, and load balancers. Defining these separately again allow more lightweight elements of an infrastructure to be treated as more ephemeral, for example container instances or even server instances.

Costs of running multiple environments can escalate quickly, especially when used for development and testing. A common strategy is to shut down or destroy non-production infrastructure outside working hours. In some cases, such as shared testing and review environments, doing this may be undesirable, as it may involve the loss of testing data which is difficult to rebuild. Splitting these parts of the environment into separate stack can make it easy to shut down expensive and non-essential parts of an environment, while keeping the more important pieces available to be re-attached when the full environment is needed again.


## Drawbacks of this pattern

Running multiple stacks to support a single application can increase complexity. Integration and coordination across stacks may require more moving parts, and a more complex change process. Some use cases don't yield enough benefit to make this worthwhile.

If removing one stack from the application causes instability in other part, such that they need to be rebuilt, then the blast radius for the first stack is wider than the stack itself, so doesn't justify the split.

Quite often, systems are divided in such a way that changes frequently involve changing multiple stacks. In this case, enabling the stacks to be changed independently does not have real value, and again comes with increased cost, risk, and complexity.
