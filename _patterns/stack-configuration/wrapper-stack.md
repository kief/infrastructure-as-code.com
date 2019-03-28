---
layout: pattern
title:  "Wrapper Stack Pattern"
date: 2019-03-28 10:07
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

So it is important to ensure that the wrapper stack code for different instances don't drift apart, with custom logic creeping in. Each instance's code should be strictly limited to passing parameter values to the modules that are imported. Pressure to customize different instances suggests that the design of the infrastructure may need to be split along different dimensions in order to keep the implementation clean and easily testable.


## Implementation

The implementation of wrapper stacks tend to look like [singleton stacks](/patterns/stack-replication/singleton-stack.html), in that each stack instance has its own stack source code project. The difference is that the per-instance wrapper stack project has very little code in it.

The code that defines the infrastructure elements for the stack is maintained in a module, so there is a single copy of the code shared across all instances. The wrapper stack project for each instance contains only configuration parameters for that specific instance of the stack.

Here is a pseudo-code example project that has a wrapper stack for each environment:


~~~ console
my_stack/
   ├── test/
   │   └── stack.infra
   ├── staging/
   │   └── stack.infra
   └── production/
       └── stack.infra
~~~


The code for each environment stack simply imports a module and sets values for it:

~~~ yaml
module:
  name: webserver_cluster
  parameters:
    environment_id: staging
    cluster_minimum: 1
    cluster_maximum: 2
~~~

The module then has its own project structure:

~~~ console
   ├── webserver_cluster_module/
   │   ├── cluster.infra
   │   └── networking.infra
   └── test/


## Known Uses

[Terragrunt](https://github.com/gruntwork-io/terragrunt) is a stack orchestration tool that implements the wrapper stack pattern.


## Related Patterns

Other patterns for configuring stack instances include [command line parameters](command-line-parameters.html), [stack instance scripts](stack-instance-script.html), [stack instance configuration files](stack-instance-configuration-file.html), [pipeline-defined parameters](pipeline-defined-parameters.html), and [a stack parameter registry](stack-parameter-registry.html).
