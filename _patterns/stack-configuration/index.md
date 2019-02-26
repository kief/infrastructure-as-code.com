---
layout: pattern-group
title:  "Patterns For Configuring Stacks"
date: 2019-02-26 09:32:50 +0000
category: Stack Configuration Patterns
section: true
order: 20
published: true
status: review
---

Defining an [infrastructure stack](/patterns/stack-concept/) as code enables the creation of multiple instances of the stack. Some aspects of the stack may need to vary for different instances of the stack - at the least, different names, identifiers, and/or tags are needed to distinguish the different instances. There are different techniques for setting configuration for instances of a stack.


<figure>
  <img src="images/stack-parameters.png" alt="Some aspects of a stack may need to vary for different instances of the stack"/>
  <figcaption>Some aspects of a stack may need to vary for different instances of the stack.</figcaption>
</figure>


## Typical uses for configuring stack instances differently

As described in the [stack replication patterns](/patterns/stack-replication), there are two main patterns used to create multiple stack instances from a single stack project. One is a [template stack](/patterns/stack-replication/template-stack.html), where all of the instances created from a stack project are intended to be highly consistent. There should be very little variation between them. The common case of this is when creating stack instances to test software - the same stack source code is used to create instances for development, test, and production, so that the software is tested in an environment that is consistent with production.


<figure>
  <img src="/patterns/stack-replication/images/template-stack.png" alt="Template stack, all of the instances are intended to be highly consistent"/>
  <figcaption>Template stack, all of the instances are intended to be highly consistent.</figcaption>
</figure>


The other pattern is the [library stack](/patterns/stack-replication/library-stack.html), where the stack project provides the core configuration for the stack's infrastructure, but each instance is customized or extended to serve a different purpose. An example of this is a stack that creates a database cluster, but separate instances are each customized to be used as a product database, a user database, and a search database.


<figure>
  <img src="/patterns/stack-replication/images/library-stack.png" alt="Library stack, each instance is customized or extended to serve a different purpose"/>
  <figcaption>Library stack, each instance is customized or extended to serve a different purpose.</figcaption>
</figure>


Because instances of a template stack tend to have little variation - in fact, it's desirable to keep variation to a minimum - configuration tends to be limited to a handful of simple parameters - strings, numbers, lists, key-value maps. So the configuration mechanism for these can be fairly simple, essentially a way to pass a set of variable names and values to the tool when provisioning or updating the stack instance.

Library stacks, on the other hand, often need deeper customization. This might involve providing more complex data structures, large blobs of data (e.g. passing scripts to be executed), or even adding additional infrastructure code (e.g. adding a terraform file to the project before applying it).



## Stack configuration mechanisms

In order to create instances of a parameterized stack, values need to be provided to the stack management tool (e.g. Terraform, CloudFormation, etc.).


### Example stack parameters

As an example, consider a stack which defines a web server cluster and its networking:


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

Given three environments, *test*, *staging*, and *production*, these variables may need to be set to different values:


| Stack Instance | environment_id | cluster_minimum | cluster_maximum |
|-------|--------|---------|
| web_test | test | 1 | 1 |
| web_staging | staging | 1 | 2 |
| web_production | production | 2 | 5 |


### Stack configuration patterns


A mechanism is needed to set values for these variables when creating and updating a stack. There are a few different patterns to consider. The simplest is to [pass the values on the command line](command-line-parameters.html). This is easy to do, but it's also easy to make mistakes with it.

~~~ console
terraform apply \
    -var 'environment_id=test' \
    -var 'cluster_minimum=1' \
    -var 'cluster_maximum=1'
~~~


An alternative is to define parameter values in [Parameter Files](stack-parameter-files.html) checked into source control, with one file for each environment. This ensures that the values are captured and are applied consistently.

~~~ console
   ├── src/
   │   ├── variables.tf
   │   ├── cluster.tf
   │   └── networking.tf
   ├── environments
   │   ├── test.tfvars
   │   ├── staging.tfvars
   │   └── production.tfvars
   └── test/
~~~


A variation of parameter files is a [wrapper stack](wrapper-stack.html). With this approach, the code that defines an environment stack is kept in a [stack code module](/patterns/stack-replication/stack-code-module.html). A stack project is then created for each stack instance, whose purpose is to pass values to the module code for the specific instance.

When infrastructure code is applied to environments using a Continuous Delivery Pipeline, [values can be defined in pipeline job configuration](pipeline-defined-parameters.html). Each stage which applies the stack code to a given environment includes configuration values for that environment, which is then passed to the command which applies to the code.

Stack instance configuration values can also be set in a [Parameter Registry](stack-parameter-registry.html). The stack management tool, or the stack source code, can then retrieve the relevant values for the instance.


## Related topics

### Stack integration patterns

When a system's infrastructure is divided across multiple stacks, configuration usually needs to be passed from one stack to another. The mechanisms for doing this are closely related to those for per-instance configuration, although there are additional things to consider. This is discussed under [stack integration](/patterns/stack-integration/).


### Stack orchestration tools

Infrastructure projects often become complex in the number of different stack types, stack instances, and configuration options that are managed. Most stack management tools (such as Terraform, etc.) are designed around the use case of running for one stack instance of a project. Running the tool for multiple projects requires more orchestration, so teams inevitably write [scripts of various shapes and sizes to orchestrate this](/patterns/stack-orchestration-tools/).




