---
layout: pattern-group
title:  "Patterns For Configuring Stacks"
date: 2019-03-28 10:07
category: Stack Configuration Patterns
section: true
order: 20
published: true
---

Defining an [infrastructure stack](/patterns/stack-concept/) as code enables the creation of multiple instances of the stack. Some aspects of the stack may need to vary for different instances of the stack - at the least, different names, identifiers, and/or tags are needed to distinguish the different instances. There are different techniques for setting configuration for instances of a stack.


<figure>
  <img src="images/stack-parameters.png" alt="Some aspects of a stack may need to vary for different instances of the stack"/>
  <figcaption>Figure 1. Some aspects of a stack may need to vary for different instances of the stack.</figcaption>
</figure>


## Purpose of stack configuration

The [template stack pattern](/patterns/stack-replication/template-stack.html) enables a single stack definition source code project to be used to create multiple stack instances that are highly consistent. A common use case is to create the infrastructure for multiple environments for testing and running software. The same stack source code is used to create instances for development, test, and production, so that the software is tested in an environment that is consistent with production.


<figure>
  <img src="/patterns/stack-replication/images/template-stack.png" alt="Template stack, all of the instances are intended to be highly consistent"/>
  <figcaption>Figure 2. Template stack, all of the instances are intended to be highly consistent.</figcaption>
</figure>


Because instances of a template stack tend to have little variation - in fact, it's desirable to keep variation to a minimum - configuration tends to be limited to a handful of simple parameters - strings, numbers, lists, key-value maps. So the configuration mechanism for these can be fairly simple, essentially a way to pass a set of variable names and values to the tool when provisioning or updating the stack instance.

In order to create instances of a parameterized stack, values need to be provided to the stack management tool (e.g. Terraform, CloudFormation, etc.).


## Example stack parameters

As an example, consider a stack which defines a web server cluster and its networking:


~~~ console
   ├── src/
   │   ├── cluster.infra
   │   └── networking.infra
   └── test/
~~~


The stack takes parameters that set an environment id string used to name and tag things, and minimum and maximum sizes for the cluster. Given three environments, *test*, *staging*, and *production*, these variables may need to be set to different values:


| Stack Instance | environment_id | cluster_minimum | cluster_maximum |
|-------|--------|---------|
| webserver_test | test | 1 | 1 |
| webserver_staging | staging | 1 | 2 |
| webserver_production | production | 2 | 5 |


## Stack configuration patterns

A mechanism is needed to set values for these variables when creating and updating a stack. There are a few different patterns to consider. The simplest is to [pass the values on the command line](command-line-parameters.html). This is easy to do, but it's also easy to make mistakes with it.

~~~ console
stack up \
    environment_id=test
    cluster_minimum=1
    cluster_maximum=1
~~~


An alternative is to define parameter values in [Instance Configuration Files](stack-instance-configuration-file.html) checked into source control, with one file for each environment. This ensures that the values are captured and are applied consistently.

~~~ console
   ├── src/
   │   ├── variables.infra
   │   ├── cluster.infra
   │   └── networking.infra
   ├── environments
   │   ├── test.properties
   │   ├── staging.properties
   │   └── production.properties
   └── test/
~~~


A variation of parameter files is a [wrapper stack](wrapper-stack.html). With this approach, the code that defines an environment stack is kept in a [stack code module](/patterns/stack-concept/stack-code-module.html). A stack project is then created for each stack instance, whose purpose is to pass values to the module code for the specific instance.

When infrastructure code is applied to environments using a Continuous Delivery Pipeline, [values can be defined in pipeline job configuration](pipeline-defined-parameters.html). Each stage which applies the stack code to a given environment includes configuration values for that environment, which is then passed to the command which applies to the code.

Stack instance configuration values can also be set in a [Parameter Registry](stack-parameter-registry.html). The stack management tool, or the stack source code, can then retrieve the relevant values for the instance.


## Pitfalls

When different instances of a template stack are becoming customized more than simple parameters can support, this is a design smell. Often, a template stack is not the appropriate pattern for the situation if significant customization is needed. It may be better to break the template down to the true common core, and then implement new template stacks for each variation. Changes to each of the new template stacks can then be tested before being applied to production instances, creating more confidence in the change process.

In other cases, a stack is highly customized because there are different subsets of elements which are needed in different situations. For example, maybe a database is deployed in some scenarios, but not in others. In these cases, it's probably a good idea to split the stack into multiple stacks. This way, each stack template represents a clear set of infrastructure which doesn't tend to vary, and each stack can be provisioned only in those situations where it is required, rather than adding complexity to a single stack.

