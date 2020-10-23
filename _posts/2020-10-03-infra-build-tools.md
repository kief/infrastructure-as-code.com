---
layout: post
title:  "Infrastructure project orchestration scripts and tools"
date:   2020-10-23 09:00:00
categories: book
published: true
---

Most infrastructure projects I've been involved with have a script, or usually a set of scripts that act like a build tool for software projects. These are often implemented using Makefiles, shell scripts, batch scripts, Rakefiles, or languages like Python and Ruby.

These project orchestration scripts do many jobs, depending on the project. Some of the jobs include:

* Assemble and package project code for use. This might include pulling libraries and other dependencies. It could even involve downloading the infrastructure tools and packaging everything as a container image, creating an executable project.

* Run static tests and possibly other offline tests (for example, using tools like [Localstack](https://localstack.cloud)) on the code outside the context of an instance of the infrastructure.

* Assemble configuration values for a given instance of the infrastructure. These values might come from configuration files, parameter registries, existing infrastructure, or a combination of these.

* Execute the infrastructure tool for an instance. This includes running the plan command for tools that support it and creating, changing, and destroying infrastructure.

* Orchestrate commands across multiple infrastructure components and projects. For example, if different parts of an environment are built from different Terraform projects, the script might run commands for each project in the correct order, based on the dependencies between them.

* Run tests against an instance of the infrastructure.


Many infrastructure project orchestration scripts handle a combination of these jobs. This tends to create messy, complicated code. Any code, including orchestration scripts, should follow good software design principles, including [SOLID](https://en.wikipedia.org/wiki/SOLID), [DRY](https://wiki.c2.com/?DontRepeatYourself), and [Separation of Concerns](https://en.wikipedia.org/wiki/Separation_of_concerns). Orchestration scripts should separate the different jobs and concerns into different parts, rather than having a master script that knows all. The [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) applies here.

Another issue with many infrastructure project scripts is that they are snowflakes, custom-built for each project. The script code often embeds knowledge of the projects it orchestrates, such as dependencies between projects and the names of configuration parameters each project needs. And team members spend considerable time and energy designing, implementing, and fixing their unique system of scripts.

I don’t believe there is value in building and maintaining unique scripts for an infrastructure project. Most of the differences in infrastructure build projects I’ve seen don’t come from meeting the project's specific needs, but rather from the specific knowledge and preferences of the people who built the project.

So I’m interested in standardized tools to orchestrate infrastructure projects. I’d like to see opinionated tools that prescribe how to structure directories, manage configuration values, and integrate multiple projects. The challenge is finding a tool with the right opinions, "right" meaning I agree with them!

I'll save elucidating the opinions I would agree with for another post. For now, here's a list of tools that I'm aware of. At this point, I haven't looked at these close enough to compare them with my own opinions about infrastructure project design.


### Orchestration tools for Terraform

- [Astro](https://github.com/uber/astro), a tool for managing multiple Terraform executions as a single command. Seems to focus on wiring Terraform modules together.
- [Rake Terraform](https://github.com/infrablocks/rake_terraform), libraries for running Terraform from Rake tasks. A part of the [Infrablocks](https://github.com/infrablocks) project
- [Tau](https://github.com/avinor/tau), Terraform Avinor Utility, another tool that orchestrates Terraform modules and configuration.
- [Terragrunt](https://terragrunt.gruntwork.io/), a thin wrapper that provides extra tools for keeping your configurations DRY, working with multiple Terraform modules, and managing remote state.
- [Terraspace](https://terraspace.cloud/) is an opinionated, convention over configuration tool that provides a project layout and handles configuration and integration of multiple projects.
- [Terraform Scaffold](https://github.com/tfutils/tfscaffold) orchestrates Terraform modules and configuration across multiple environments and components on AWS.
- [Terranova](http://blog.johandry.com/post/terranova-terraform-from-go/) - library to help you write golang code that implements terraform commands without the binary. So you can combine project orchestration and your infrastructure definitions, which sounds like an invitation to write code that spectacularly fails to separate concerns. But the possibilities are intriguing.


### Orchestration tools for CloudFormation

There must be more of these than I know of. I've listed a couple that aren't current but could be interesting.

- [Rain](https://github.com/aws-cloudformation/rain), a development workflow tool for working with AWS CloudFormation. Currently in preview, not production-ready.
- [Autostacker24](https://github.com/AutoScout24/autostacker24), a Ruby utility to manage AWS CloudFormation stacks. I may or may not have been present for this tool's conception, including suggesting the name. I'm not sure how active development is.
- [cfnassist](https://github.com/cartwrightian/cfnassist), a cloud formation helper tool. Not very active development.

