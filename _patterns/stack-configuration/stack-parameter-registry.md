---
layout: pattern
title:  "Stack Parameter Registry"
date: 2019-03-28 10:07
category: Stack Configuration Patterns
order: 26
published: true
status: review
---

Configuration values for [template stacks](/patterns/stack-replication/template-stack.html) can be stored in a parameter registry. The appropriate set of values can be retrieved from the registry by the stack management tool or [stack orchestration tool](/patterns/stack-orchestration/) when applying the code to a stack instance.


<figure>
  <img src="images/configuration-registry.png" alt="Stack instance configuration values can be stored in a parameter registry"/>
  <figcaption>Stack instance configuration values can be stored in a parameter registry.</figcaption>
</figure>


## Also Known As

- Infrastructure configuration registry


## Motivation/Applicability

Managing stack instance parameters in a registry provides a strong separation of configuration from implementation. Parameters in a registry can be set, used, and viewed by different tools, using different languages and technologies. This reduces coupling between different parts of the system - the tool that sets a given parameter value can be replaced without any impact to the code that uses the value to define the stack.

Because they are tool-agnostic, stack parameter registries can act as a source of truth for infrastructure and even system configuration, acting as a Configuration Management Database (CMDB). This can be useful in regulated contexts where the ability to easily discover configuration values is useful for auditing.


## Consequences

A configuration registry is usually more complex to implement than other configuration patterns. It may involve provisioning and maintaining an additional service, adopting a service hosted by a third party, or using a platform-specific parameter service.

In any of these cases, the registry service is a dependency, and a potential point of failure. If the registry becomes unavailable, it may be impossible to reprovision or update infrastructure stacks until it is restored. This can be painful in disaster recovery scenarios, which puts the registry service on the critical path for restoring or moving services in an emergency.

In more complex systems with multiple infrastructure stacks, the configuration registry can also be used for (/patterns/stack-integration/). It is then possible for different tools and services to make use of the registry to discover information needed to integrate and manage different parts of the system.


## Implementation

A configuration registry is essentially a key/value store. There are many products which can be used to provide this service, as well as hosted services. Most cloud platforms, and many related systems such as container orchestration platforms, offer out of the box key/value stores, such as AWS SSM Parameter Store.

It's also possible to implement a simple configuration registry by storing files on a reliable storage, such as a hosted block storage service or a version control system. This can potentially resemble [stack instance configuration files](stack-instance-configuration-file.html), with the difference that files are hosted separately from the stack project code.

As an example, a stack that is used to create a web server cluster may have different values for the sizing of the cluster in different environments:


| Stack Instance | environment_id | cluster_minimum | cluster_maximum |
|-------|--------|---------|
| webserver_test | test | 1 | 1 |
| webserver_staging | staging | 1 | 2 |
| webserver_production | production | 2 | 5 |


A configuration registry is usually a key-value store, ideally with a folder-like structure for storing variables and values. So the values for the example above might be stored in a structure like this:


~~~ console
└── environment_id
    ├── test
    │   ├── webserver
    │   │    ├── cluster_minimum = 1
    │   │    └── cluster_maximum = 1
    │   └── appserver
    │        ├── cluster_minimum = 1
    │        └── cluster_maximum = 1
    ├── staging
    │   ├── webserver
    │   │    ├── cluster_minimum = 1
    │   │    └── cluster_maximum = 2
    │   └── appserver
    │        ├── cluster_minimum = 2
    │        └── cluster_maximum = 3
    └── production
        ├── webserver
        │    ├── cluster_minimum = 2
        │    └── cluster_maximum = 3
        └── appserver
             ├── cluster_minimum = 2
             └── cluster_maximum = 5
~~~


When applying the infrastructure stack code to an instance, an ID such as *environment_id* is used to find the appropriate values for that instance. Here's an example of pseudo-code to retrieve a value in a stack definition


~~~ yaml
registry:
  id: my_registry
  type: some_keyvalue_database
  hostname: keyvalue.mysystem.mydomain

variables:
  cluster_minimum: ${registry.my_registry["/${environment_id}/webserver/cluster_minimum"]}
  cluster_maximum: ${registry.my_registry["/${environment_id}/webserver/cluster_maximum"]}

cluster:
  name: webserver-cluster-${environment_id}
  server_role: webserver
  minimum: ${cluster_minimum}
  maximum: ${cluster_maximum}
~~~


So the single variable `environment_id` can be used as an input to the stack code when running the stack tool:


~~~ console
stack up environment_id=staging
~~~


... and then used within the stack source code to retrieve all of the other values needed.


## Known uses

Most stack management tools have built-in support for certain registries and key/value stores, which makes it easy to directly refer to registry values in code. Terraform has a provider for [Consul](https://www.terraform.io/docs/providers/consul/index.html) and direct support for [AWS parameter store values](https://www.terraform.io/docs/providers/aws/d/ssm_parameter.html), CloudFormation can [reference SSM parameter store values](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/dynamic-references.html#dynamic-references-ssm), etc.


## Related Patterns

Other patterns for configuring stack instances include [command line parameters](command-line-parameters.html), [stack instance scripts](stack-instance-script.html), [stack instance configuration files](stack-instance-configuration-file.html), [wrapper stacks](wrapper-stack.html), and [pipeline-defined parameters](pipeline-defined-parameters.html).

