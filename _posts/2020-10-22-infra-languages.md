---
layout: post
title:  "Are declarative infrastructure code languages harmful?"
date:   2020-10-22 09:00
categories: book
published: false
---

Too many infrastructure projects are an atrocity of messy, tangled code. Some people, especially developers, blame the use of custom, declarative languages for infrastructure coding. [Ansible](https://docs.ansible.com/) extends YAML, [CloudFormation](https://aws.amazon.com/cloudformation/) offers both JSON and YAML, and [Terraform](https://www.terraform.io/) uses [HCL](https://github.com/hashicorp/hcl), a [DSL](http://martinfowler.com/books/dsl.html).

The idea is that infrastructure code should be written using a "real", [Turing-complete](https://wiki.c2.com/?TuringComplete) language, so we can write real programming code rather than editing jumped-up configuration files. [Pulumi](https://www.pulumi.com/) and the [AWS CDK](https://aws.amazon.com/cdk/) represent a new generation of infrastructure tools that support writing infrastructure code using languages like JavaScript, Typescript, and Python.

This new generation of tools is exciting, creating opportunities for much better infrastructure projects. But the languages aren't the root cause of horrific infrastructure code. The true problem is that infrastructure projects are poorly designed.

So, my hypothesis is that the path to better infrastructure code isn't to replace all declarative code with imperative code, but instead to apply good design principles, like [SOLID](https://en.wikipedia.org/wiki/SOLID). Choosing the appropriate language for each job is part of the solution, but that isn't possible until you've got the design right.


## Bad infrastructure code

Typical infrastructure code today mixes declarative code with [imperative code](https://en.wikipedia.org/wiki/Imperative_programming). For example, this YAML-based pseudocode sets the size of a server instance depending on which environment it's applied to and which application will run on it:


```yaml
server_instance:
  name: appserver-${application}-${environment}
  if: ${environment} == "prod" || ${environment} == "staging"
    if: ${application} == "pricing" || ${application} == "search"
      instance_type: t2.large
    else:
      instance_type: t2.medium
  else:
    if: ${application} == "pricing" || ${application} == "search"
      instance_type: t2.medium
    else:
      instance_type: t2.tiny
```


The rest of the code would define other attributes of the server and related infrastructure like networking. Most likely, the environment and application would be used to decide other options, such as whether to make the server available to the public Internet or how much storage to allocate to a database.

This example is hard to read and write. Even as I was making it up, I had to stop and think about when each instance_type will be applied. But real-world code often gets far messier.

Some people will look at this code and decide to just split the code into separate projects for each combination of environment and application. Each copy of the code becomes very clear and simple. But it fails the [DRY principle](https://wiki.c2.com/?DontRepeatYourself), by repeating code that represents the same thing in multiple places. Making changes to the code is painful.

Other people see the use of YAML to write logic as the main problem. And it is part of the problem, but the root problem is the code [mixes concerns](https://en.wikipedia.org/wiki/Separation_of_concerns). One concern is creating a server instance. The other concern is deciding how to configure the server instance depending on how it will be used.

A solution to this problem is to extract the configuration out of the server code, which now looks like this:


```yaml
server_instance:
  name: appserver-${application}-${environment}
  instance_type: ${instance_type}
```


This code is much easier to understand. The code in the first example knows far too much about the applications that will run on it and what environments it will be used to create. The revised code doesn't know or care about these things, it only knows how to create a server. The code to work out the configuration values to pass into this code might be more complex, but it will be focused on a more specific problem.

In practice, pulling the configuration out of the code might simplify how you implement it. You could create a separate property file for each environment. Each file includes a set of key-value pairs that specify the values to pass in to the server code.

Doing this shifts the logic out to the decision of which files to use for a given instance of the infrastructure. Often, this turns into a hierarchy of files, which are resolved in a certain order. If the hierarchy becomes complex, the code to implement it becomes complex.

This leads to another area of infrastructure projects that often becomes a mangled mess of mixed concerns - tool orchestration. Most teams end up with scripts that orchestrate the execution of their infrastructure tools, implemented as Makefiles, shell scripts, or Python or Ruby code.

Again, the problems with these scripts come when they mix too many concerns. They might assemble configuration from files and other resources, manage the order that different parts of the infrastructure are applied, run the infrastructure tools, and test instances afterwards. I've seen projects where these scripts involved more code than the infrastructure declarations.






Testing infrastructure code is a particular challenge with declarative code. Although ThoughtWorks teams are steeped in the [TDD](https://martinfowler.com/bliki/TestDrivenDevelopment.html) school of software development, they still struggle with practicing it [with infrastructure code](https://medium.com/@joatmon08/test-driven-development-techniques-for-infrastructure-a73bd1ab273b). That rich ecosystem for languages used by Pulumi and CDK include extensive testing support, which Pulumi in particular supplements with libraries and tools for [testing infrastructure](https://www.pulumi.com/docs/guides/testing/).


## Why it's bad

* Because people use these languages to do things that they aren't suited to do
* Comes down to static definitions of infrastructure vs. dynamically generating infrastructure variations

Types of code:
* Defining the shape of a reusable chunk of infrastructure (let's call it a stack)
* Creating variations of infrastructure depending on things - inputs, context
* Deciding how to configure an instance of infrastructure - what inputs to give it

* Testing declarative code is questionable, because it's static. The test is simply restating the code. The "Given/When/Then" is missing the "When" - you're given some infrastructure, you have expectations. You don't change things to see if the expectations are unmet in some cases.

So, my thinking is that the issue is not that one type of language is harmful and another always best. The real problem is using the wrong type of language for the job.


Scripts that run infrastructure tools also tend to do too much. Assemble configuration values for environments (often with logic), wire different infrastructure components together, run tool commands. These scripts often hard-code knowledge of the infrastructure components.


## When declarative code is suitable

* When you want to define structures - infrastructure elements and their relationships, for example
* When the code doesn't involve logic that varies the results of running or applying it

Imperative code is suitable when the inverse of these is true. And I'll go a step further and say that imperative code is harmful when these conditions are true. If all you need is to define structures and relationships, then imperative code adds complexity and more potential for errors. Imperative code also makes declarations less clear than a well-designed declarative DSL.



## Separate configuration from infra declarations

Don't embed configuration decisions into declarations of infra

- Example of infra declaration that includes configuration logic

Instead, pass parameters to the code when creating an instance



## First start



The emergence of [Pulumi](https://www.pulumi.com/) and the [AWS CDK](https://aws.amazon.com/cdk/) is exciting for people, especially those from a development background, who are frustrated by how horrific code written in declarative languages often becomes. 





## Use an imperative language to write libraries

A module, static code that you reuse across different stack projects to build pretty much the same thing every time.

A library, something that you can use in different stack projects to build different variations of some bit of infrastructure. 

As an example, a library that builds a server instance. Calls out to server configuration code with a role that's passed in. Provisions and attaches storage. Opens ports, creates routes, and associates network addresses according to parameters. Should also set up roles and other security concerns.

- Declarative code that can do these things will get nasty.

- So use an imperative language instead.


## Good software design for your infrastructure

Requires good design for low coupling and high cohesion. Single Responsibility Principle, Law of Demeter, etc.

- The server example again. You might need servers for application servers, container hosts, database nodes, build servers, and other things. Ideally, your library wouldn't know about all of these things.

Shouldn't be super-heavy, do everything. That would be bad design. This is where an OO language and associated patterns would come in handy.

You could make subclasses of a base server class for each different type of server.

You might use [Composition rather than inheritance](https://en.wikipedia.org/wiki/Composition_over_inheritance). For example, you might write separate classes to handle configuring the server configuration tool, build and wire up its networking, and set up roles and permissions.

Testing if you're writing libraries that do different things. What happens if you pass in a server configuration role that doesn't exist?


## Consistent levels of abstraction

Most of these languages, whether declarative or imperative,s are a wrapper around the cloud API. They present the resources that the cloud provides as constructs of their language or library. These are primitives, and you write code that wires them together into a useful collection of infrastructure.

When you start writing libraries, or even modules, you create your own abstraction. The server example is a domain entity that isn't simply a virtual machine instance, but a fully configured server with storage and connectivity. When you write code that uses this library, you are building a container host, a database cluster node, or whatever - it's a higher level abstraction.

You may want to keep code at different levels of abstraction separate. So probably don't want something that looks like a mix of classic Terraform code, directly referring to infra primitives, mixed together with code that refers to abstractions.




## Real programming languages for infrastructure



There's a lot to like about this new generation of tools. But simply rewriting all of your declarative infrastructure code in TypeScript won't make your infrastructure project easy to understand and maintain. The true opportunity with bringing imperative languages into a project is that you can reshape it into a far better design. Infrastructure projects need both imperative and declarative code. The key is to use each type of language for the appropriate job.

To understand how we can write better infrastructure code, let's explore the question:



## Acknowledgements

* David Johnston (was writing about BPM configuration code)
* Effy Elden (bad code suggestions)

