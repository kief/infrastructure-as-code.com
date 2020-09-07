---
layout: post
title:  "Pulumi, CDK, Terraform - We're missing the point on infrastructure coding languages"
date:   2020-09-01 16:20:00
published: false
---

// Declarative languages reduce the scope for variability. This can be useful - reduces the need to test, keeps things more consistent. But it's useful where there's not much need for variability, also known as flexibility.

When I first heard about Pulumi and AWS CDK, I missed the point. People focused on the fact that these new tools allow you to define infrastructure using a general purpose language like JavaScript or Python. So I imagined these tools were the same thing as Terraform and CloudFormation, just using "real" programming languages rather than declarative, configuration-like languages.

What I've come to realize is that these tools bring the opportunity to design and build infrastructure as code in very different ways than we've been doing with Terraform and CloudFormation (and Ansible and whatever else). And the current debate about these tools completely misses the point.

People are still focused on which type of language is best for coding infrastructure - a declarative language like HCL, YAMl, and (shudder) JSON, or a procedural or OO language like JavaScript and Python.

The real problem isn't that one type of language is more appropriate than the other, it's that infrastructure codebases are an abysmal tangle of mixed concerns.

Infrastructure coding is in a similar place that web coding was in back in the early 2000's. What type of language is best for designing a web-based user interface, a markup language like HTML, or a programming language like JavaScript or Java? The result then was code that mixed both - PHP, JSP, and ASP. Code that mixed HTML, Java, and SQL in the same file, has many similarities with horrific examples of Terraform and Ansible code today.

So the real solution is to clarify and separate the concerns of an infrastructure codebase, and then work out which language and design strategies are most appropriate for each. It's also important to consider that different organizations and teams will have different use case, so may need different languages and strategies.


## Separate environment definitions from reusable components

At a broad level, one infrastructure code concern is defining an environment, and another is defining reusable infrastructure components to use in defining environments.

For example, my team needs an environment to deploy our Java application on a cluster of VMs, backed by a PostgreSQL database. Our infrastructure needs some networking rules, security policies, and storage. A declarative DSL like HCL can work well for this, especially if my team understands the details of the cloud platform we're using, and wants fine-grained control of our infrastructure. HCL exposes the details of the cloud API, and lets us define each piece as it should be.

The trouble with Terraform (and CloudFormation, and Ansible, and, and and, ...) comes when we decide to introduce reusable components. HCL modules work well to re-use code, but are not very good for reusable components.

HCL is declarative, so you can declare some code, and then import it in multiple places in your project, or in multiple projects. But when you write a module that can be used for different variations of the use case, declarative languages stretch and break.

Let's say we want a component that can define a VM cluster. We want to use the module to create clusters for different applications. Some applications are public-facing, some are internal. Some run on different network ports. Some have different security and compliance concerns, requiring different access control policies.

These requirements need "real" programming. We need conditionals, to decide which infrastructure elements to apply. We probably want loops, to assign a security policy to multiple resources. We'll set values for pieces of infrastructure based on complex logic.

This type of code is where you see a declarative language like yaml extended to add conditionals and loops. It doesn't take long working with this kind of code to realize you'd be better off programming in a language designed for programming.


## Separate environment definitions from configuration

There are a few different situations for defining infrastructure environments. In the simplest case, if you're defining an environment with one instance, there's no need for logic. There's no variation. Give me one VM, with 4 GB of RAM and a 100 GB disk volume, and open port 443 to the internal network. Programming this is overkill.

In practice, most non-toy environments should have multiple instances, if only so you can test changes to your infrastructure before breaking something someone cares about. So you define an environment shape and then use the code to create multiple instances of the environment. This is the promise of infrastructure as code - you build and maintain consistent Dev, QA, Staging, and Production environments.

You might be tempted to put conditional logic in the code that defines the environment. For example, use conditionals and loops to build different numbers of servers depending on which environment you're applying the code to. The code might wire your servers into different part of the networking depending on whether it's a production or non-production instance.

This is another situation that drives people to mix logical code in with their declarative environment definitions.

Using a "real" programming language to implement that configuration logic as well as define a reusable environment shape might be more satisfying than using extended yaml. But it's still poor design.

Much better to extract per-instance configuration from the reusable environment definition, and manage them as separate code. This arrangement is cleaner and easier to understand. It lets you choose the appropriate tool and language for each task, rather than choosing a single language that will do a poor job of one or the other.

Another benefit of extracting configuration from code is that it's easier to test.


## Can't test your infrastructure? I wonder why

Most people writing infrastructure code find it difficult to write tests for it. They also tend to intermix environment definitions, reusable components, and complex configuration logic in the same code. These two statements may be related.


## Other infrastructure code concerns

As I said earlier, we need to clarify and separate the concerns of infrastructure codebases, and design our solutions accordingly. I haven't yet seen (or built) a codebase that does this very well. I've listed three concerns - building reusable components, declaring an environment shape, and configuring instances of an environment shape - that are often intermingled in code.

Some other concerns are often intermingled in infrastructure build scripts. Teams write these scripts using shell scripts, scripting language like python and ruby, or software build tools like make, rake, and gradle. I've even seen people write them using an infrastructure tool like Ansible, essentially writing complex shell scripts using yaml.

These infrastructure orchestration scripts do multiple things. They assemble code, promote code between environments, resolve configuration values, and assemble multiple projects for a given environment. They execute infrastructure tools, and may run tests or other provisioning activities.

These scripts are usually a tire fire. In some cases, they involve more code, and take more time to debug and fix, than the Terraform or CloudFormation projects that they support.

Again, the solution is to identify and split the concerns these scripts own.


## One team, two teams



To go on a bit, I think HCL does a good job if you want to define environments, with very direct exposure to the details of the underlying cloud platform. e.g. when you want to code the details of network routes, IAM policies, etc. So the person defining the network has deep infra knowledge, so there is little abstraction. Terraform modules are ok-ish for re-using code, but terrible for building reusable components.

An example of a reusable component, rather than reusable code, is when you want different app teams to be able to build infra for their applications, based on a few high level things they may want to configure. But the component makes sure to plumb in the details accordingly, setting up routes, security rules, etc.







### Direct environment definition strategy (model, pattern, ...)

With the "direct environment definition" strategy, people with strong infrastructure domain knowledge directly define environments. Declarative DSLs like Terraform and CloudFormation are the most appropriate solution for this. These languages expose the gritty details of the infrastructure platform, with constructs that map directly to concepts in the API.

Infrastructure experts can build networking structures, routes, detailed security policies, and fine-tune storage devices. And while they have access to the full richness of the infrastructure resources, they aren't distracted by development language scaffolding. They probably come from a systems or network administration background. These folks don't want to declare variables and instantiate objects. They don't need to know whether parameters to a function they define are passed by reference or by value.



### Toolkit environment definition strategy

With the other strategy, "toolkit environment definition," one group of people create toolkits for other people to define environments.

These toolkits may include libraries, frameworks, or a complete abstraction layer. The people who build the toolkits combine infrastructure domain knowledge and strong software development skills, either as individuals, or as a team. They will find it easier to build these toolkits using established, full programming languages, as supported by Pulumi and the AWS CDK.

A full language and its ecosystem of tooling supports organizing code into class hierarchies and reusable libraries. The components aren't simple bundles of declarative infrastructure elements, but can be dynamic, generating infrastructure comprised of multiple pieces, wiring them together based on their use.



The people who define environments in this strategy will usually have less detailed





one based on creating a toolkit that people can use to create simplified for defining environments, and one based on detailed environment definitions.




 several different concerns in an infrastructure system, and there are different strategies to address those concerns in code. 


People have been using Terraform, CloudFormation, and similar tools to implement a strategy based on shared, reusable code. The design of these tools is not suited for doing this.






## Infra projects have different use cases, and users

* Are you defining specific environments, or giving people ways to define  environments to meet their needs? In other words, are you building infrastructure components - a library, framework, abstraction layer, or even a platform?

* Where is your infrastructure domain knowledge?


### Defining specific environments, with domain knowledge

Terraform and CloudFormation work well for this.
Pulumi and CDK will tend to make this messy.

Developers tend to make this messy, because they want to code it rather than configure it. They can't help themselves.


### Creating and using infrastructure code libraries

Two main sets of participants, users and library makers.


#### Building reusable components with a thin-layer tool (CF/TF)

Pain. These are shitty at making reusable components that can create different things for different use cases. Results in shitty code. Plus, environment definers have access to fine-grained infra, so they will use it.


#### Building a simple configuration interface

Logic in the components, abstraction layer. Give your environment definers a simple, limited set of things to use.

(You can allow them to write components, but they need to implement them in the component model, not hack it with the definition language)



#### Users / environment definers with little domain knowledge

PaaS model. Let me write some simple configuration, the libraries build what I need.


#### Users with domain knowledge

The have access





