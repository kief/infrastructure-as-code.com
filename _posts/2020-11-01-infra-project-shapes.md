---
layout: post
title:  "New infrastructure languages can enable new models for building systems"
date:   2099-01-01 16:20:20
categories: book
published: false
---

People are celebrating the emergence of a new generation of infrastructure tools which use general purpose programming languages rather than declarative DSLs. But the exciting potential of these tools isn't that you can swap the language that you code your infrastructure projects with, it's that you can completely reshape your projects.

With [Pulumi](https://www.pulumi.com/) and the [AWS CDK](https://aws.amazon.com/cdk/) you can write infrastructure code using procedural or object oriented languages like JavaScript, TypeScript, or Python. For many developers, this is a welcome change from defining infrastructure in a declarative language. [Ansible](https://docs.ansible.com/) extends YAML, [CloudFormation](https://aws.amazon.com/cloudformation/) offers both JSON and YAML, and [Terraform](https://www.terraform.io/) uses [HCL](https://github.com/hashicorp/hcl), a [DSL](http://martinfowler.com/books/dsl.html).

Many infrastructure projects written with these tools are horrors of twisted logic, loops and conditionals hacked into YAML and JSON. For some, this is proof that declarative code is evil. Pulumi and CDK are torches that will burn away the monstrous code and replace it with shining pure Turing-completeness so we can all live happily ever after.

I'm skeptical of this simple story. Simple declarative code has its place, infrastructure codebases become horrific when we don't follow good design practices. We mix different concerns with abandon. Code that declares the shape of an environment embeds logic to dynamically determine configuration options depending on environment. Code for one infrastructure project hard-codes dependencies on resources defined in another. A single script marshals configuration values and orchestrates multiple infrastructure projects.

Changing the language you code in won't fix a spaghetti architecture.

However, a real programming language, with an ecosystem of libraries, build tools, testing frameworks, and other trappings, can help you to design and implement a cleaner architecture.

I see three different models for infrastructure project architectures. I expect all three of these to coexist, often in the same organization, for some time to come. But it's useful to consider what they are so you can deliberately select the approach you need and use the tools that support it.

The three models are: low-level static infrastructure projects, cloud-native stacks, and extensible layered infrastructure.


## Low-level static infrastructure projects

Terraform, CloudFormation, and similar tools are well suited for projects that define a fairly static set of low-level infrastructure resources. Let me unpack that statement.

Firstly, by "low-level" I mean that these tools directly expose the resources provided by an infrastructure platform in their language. Your code uses elements that map to a virtual server instance, a network route, a load balancer rule, and other resources as defined by the platform. Their language is basically a wrapper around the cloud API.

Secondly, by a "fairly static" set of resources, I mean that these tools work well for explicitly describing part of an environment that won't vary very much. You might reuse your project code. In fact I advocate reusing infrastructure project code to make your environments more consistent, and to support testing changes.

But these tools work best if you don't try to write code that dynamically generates infrastructure that varies very much. Sure, use a simple parameter to set the amount of RAM for a virtual machine. Pass a minimum and maximum size for an auto-scaling group. But don't create different network topologies or IAM roles depending on flags. The more variable the results of a project may be, the more complex the code is.

The fact remains that declarative code is great for declaring things, but terrible for implementing logic.

The problem many teams run into with declarative infrastructure tools is when they go beyond defining an essentially static set of infrastructure, and try to build libraries and flexible abstraction layers. Fortunately, the new generation of tools based on full-fledged programming languages are very well suited for that task.


## Extensible layered infrastructure

Tools like Pulumi and CDK offer the potential for a model where you build your own abstraction layer. You can model your infrastructure using your own domain concepts. You might define _application hosting infrastructure_ that includes the compute, networking, and storage for a typical application. You can automatically wire up networking routes and firewall rules based on data and traffic classification zones.

You write code that assembles lower-level infrastructure elements into the domain concepts. The code creates an abstraction layer between environments described in terms that are relevant to the applications and the infrastructure platform.

The cloud native model is an abstraction layer. Using these tools to write your own abstraction layer can be useful for systems that don't map neatly to containers and Kubernetes. You could use them to dynamically build infrastructure that involves virtual machines and even physical servers managed by bare-metal cloud tooling.

Remains to be seen how many organizations opt to build their own abstraction layers in this way, rather than adopt cloud-native tooling. It's a bit of "build versus buy". The problem with the "buy" option is that right now, it's not clear what to buy. The market is not mature, lots of churn, many of the products and would-be standards will become quickly obsolete.

And it's not inconceivable that the world of custom infrastructure components won't evolve into a market of standardized components and frameworks.




* High-level infra definition is written at a higher level domain of infra. The server examples above, for instance. Might even be an application descriptor, which declares the infrastructure your application needs, and your libraries use it to either provision resources, or wire your stuff into existing resources. The language you use to write this is probably declarative. You should probably have a pretty static view of what infrastructure you want - a pool of application servers, a database cluster, wired into a pool of webservers. You might want some variation - how big are the app server pool and db clusters? But ideally these aren't configured using logic, just environment configuration values.
** Tests for these are also simplistic. Smoketest. Deploying and testing your application is probably the real test.
** Probably written by application teams, who are defining the actual environments they need.

* Libraries, abstraction layers. Written with dynamic code.
** Test the crap out of these, unit tests on up.
** Probably written by teams that include both development skills and infrastructure domain knowledge.


## Cloud native infrastructure stacks

There is a "cloud native" model, that's normally based on Kubernetes and containers. The tools create a layer between lower-level infrastructure and applications. But there are some pretty big gaps, because the infrastructure platforms have differences that kubernetes doesn't completely hide. Differences in kubernetes implementations, and there's a lot of work to do to manage each one. And other areas of infrastructure aren't abstracted, or require choosing between non-standard options, and a lot of work anyway. Traffic management, storage, identity and authorization, secrets, logging, monitoring, etc. The landscape is pretty messy.


# Other thoughts

## Bespoke infra

One benefit of abstraction layers is they can embed good practices and design for security, stability, etc. 
The flip side of this is that they can be too limiting. A team may have requirements that vary from other teams - I've seen this with teams doing heavy ML, for example. So there is a need for application teams to be able to define some parts of their infrastructure themselves. Over time they probably write their own libraries to add into the abstraction layer.


## Pitfalls - PHP for infrastructure
