---
layout: pattern
title:  "Instance Configuration File Pattern"
date: 2019-02-06 14:27:15 +0000
category: Stack Configuration Patterns
order: 22
published: true
status: review
---

Values can be provided to instances of [template stacks](/patterns/core-stack/template-stack.html) by putting them into files, checked into version control.

[Template stacks](/patterns/core-stack/template-stack.html) typically define parameters which can be set differently for different instances of the stack. For example, a stack that is used to create a web server cluster may have different values for the sizing of the cluster in different environments:


| Stack Instance | environment_id | cluster_minimum | cluster_maximum |
|-------|--------|---------|
| web_test | test | 1 | 1 |
| web_staging | staging | 1 | 2 |
| web_production | production | 2 | 5 |


These can be defined in stack parameter files, typically one file for each stack instance:


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


The parameter file for an environment then defines the values to use for the relevant stack instance:


~~~ properties
environment_id  = test
cluster_minimum = 1
cluster_maximum = 1
~~~


The parameter file for the environment is passed to the stack management tool when running it to provision or update the relevant stack instance:

~~~ console
terraform apply -var-file=../environments/test.tfvars
~~~


## Benefits and drawbacks of parameter files

Creating environment parameter files for a stack is straightforward and easy to understand. Because the file is committed to the source code repository, it is easy to see what values are used for any given environment ("what is the maximum cluster size for production?"), to trace the history for debugging ("when did the maximum cluster size change?"), and for auditing ("who changed the maximum cluster size?").

There are some limitations with parameter files. It increases the work needed to create a new environment, particularly for dynamically created and one-off environments. Although many people are used to having a static set of environments, an advantage of using dynamic cloud-type platforms is that it is easy to spin up new environments on demand, for example for development and testing.

When environments are split into multiple infrastructure stacks, managing the configuration for all of the stacks in all of the environment can become messy. There are two common ways of arranging parameter files. One is to have all of the environment files for a given stack together with the stack code:


~~~ console
   ├── web
   │   ├── infra
   │   │   ├── cluster.tf
   │   │   └── networking.tf
   │   └──environments
   │       ├── test.tfvars
   │       ├── staging.tfvars
   │       └── production.tfvars
   └── app1
       ├── infra
       │   ├── server.tf
       │   └── networking.tf
       └──environments
           ├── test.tfvars
           ├── staging.tfvars
           └── production.tfvars
~~~


The other is to centralize the configuration for all of the stacks:


~~~ console
   ├── web
   │   ├── cluster.tf
   │   └── networking.tf
   ├── app1
   │   ├── server.tf
   │   └── networking.tf
   └── environments
       ├── test
       │   ├── web.tfvars
       │   └── app.tfvars
       ├── staging
       │   ├── web.tfvars
       │   └── app.tfvars
       └── production
           ├── web.tfvars
           └── app.tfvars
~~~


Both approaches can become messy and confusing, from different directions. When you need to make a change to all of the things in an environment, making changes to configuration files across dozens of stack projects is painful. When you need to change the configuration for a single stack across the various environments it's in, trawling through a tree full of configuration for dozens of other stacks is also not fun.

Another drawback of stack parameter files comes when a stack is managed through a Continuous Delivery pipeline. In this case, making a change to the configuration for production involves committing a change to the parameter file in the stack's source code, and then waiting for the update to flow through the full pipeline to production. This can be painful, particularly for changes which are needed quickly.

