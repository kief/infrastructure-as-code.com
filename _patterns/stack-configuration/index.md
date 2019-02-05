---
layout: pattern-group
title:  "Patterns For Configuring Stacks"
date:   2019-01-01 16:20:00
category: Stack Configuration Patterns
section: true
order: 20
published: true
status: todo
---

Defining an [infrastructure stack](/patterns/core-stack/) as code enables the creation of multiple instances of the stack. There is usually a need to define some aspects of the stack differently for different instances - at the least, different names, identifiers, and/or tags are needed to distinguish the different instances. There are different techniques for setting configuration for instances of a stack.


![There is usually a need to define some aspects of a stack differently for different instances](images/stack-parameters.png)


## Typical uses for configuring stack instances differently

As described in the [core patterns](/patterns/core-stack), there are two main patterns used to create multiple stack instances from a single stack definition. One is a [template stack](/patterns/core-stack/template-stack.html), where all of the instances created from a stack definition are intended to be highly consistent. There should be very little variation between them. The common case of this is when creating stack instances to test software - the same stack definition is used to create instances for development, test, and production, so that the software is tested in an environment that is consistent with production.


<figure>
  <img src="/patterns/core-stack/images/template-stack.png" alt="Template stack, all of the instances are intended to be highly consistent"/>
  <figcaption>Template stack, all of the instances are intended to be highly consistent.</figcaption>
</figure>


The other pattern is the [library stack](/patterns/core-stack/library-stack.html), where the stack definition provides the core configuration for the stack's infrastructure, but each instance is customized or extended to serve a different purpose. An example of this is defining a stack that creates a database cluster, but provisioning instances with different configurations for a product database, user database, and search database.


<figure>
  <img src="/patterns/core-stack/images/library-stack.png" alt="Library stack, each instance is customized or extended to serve a different purpose"/>
  <figcaption>Library stack, each instance is customized or extended to serve a different purpose.</figcaption>
</figure>


Because instances of a template stack tend to have little variation - in fact, it's desirable to keep variation to a minimum - configuration tends to be limited to a handful of simple parameters - strings, numbers, lists, key-value maps. So the configuration mechanism for these can be fairly simple, essentially a way to pass a set of variable names and values to the tool when provisioning or updating the stack instance.

Library stacks, on the other hand, often need deeper customization. This might involve providing more complex data structures, large blobs of data (e.g. passing scripts to be executed), or even adding additional infrastructure code (e.g. adding a terraform file to the project before applying it).


## Stack configuration mechanisms

In order to create instances of a parameterized stack, values need to be provided to the stack management tool (e.g. Terraform, CloudFormation, etc.). For example, consider a stack which defines a server cluster and its networking:


~~~ console
   ├── src/
   │   ├── variables.tf
   │   ├── cluster.tf
   │   └── networking.tf
   └── test/
~~~


The stack takes parameters that set an environment id string used to name and tag things, and minimum and maximum sizes for the cluster:


~~~ hcl
variable "environment_id" {}
variable "cluster_minimum" { default = "1" }
variable "cluster_maximum" { default = "1" }
~~~




a mechanism is needed to provide parameter values. Some options include [Stack Parameter Files](stack-parameter-files.html), [Pipeline-defined parameters](pipeline-defined-parameters.html), and [Parameter Registry](stack-parameter-registry.html).

Another approach is to define the stack as a module, and then use a [Wrapper Stack](wrapper-stack.html) to define parameter values for each instance.


## Related topics

When a system's infrastructure is divided across multiple stacks, configuration usually needs to be passed from one stack to another. The mechanisms for doing this are closely related to those for per-instance configuration, although there are additional things to consider. This is discussed under [stack integration](/patterns/stack-integration/).

