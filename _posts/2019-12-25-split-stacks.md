---
layout: post
title:  "Break up your Terraform project before it breaks you"
date:   2019-12-01  14:20:00
categories: practices
published: false
---

Your Terraform project is out of control. Oh, it started out fine. You and your crew needed a normal set of infrastructure for the application. Web server, application server, database cluster. A few security groups, network routes, gateway, some IAM roles, that sort of thing. Five or six files, none of them more than 60 lines of HCL.


## Playing dice with your universe

But look at it now. You started building containers for your application as it turned into a bunch of micro(ish)-services, and obviously you needed a Kubernetes cluster to run them. Now there's a bunch of code for the cluster, plus code to build the host nodes and manage how those get scaled up and down. You've reshuffled that code a few times so it's nicely organized into four .tf files, rather than the one massive .tf file you had for a while.

There are some fairly gnarly files for the application servers you run for some odds and ends, like your Prometheus server. You've got the server-building code in a module, although it's a bit gross, since it builds your Kubernetes nodes plus servers for three other tech stacks.

At least you finally moved off your hand-rolled ELK stack onto your cloud provider's log aggregation service, but that's still a couple of .tf files. And couple of people on your team are working on the new API gateway implementation, which will be handy now that you're running a couple dozen micro(ish)-services.

The thing is, this environment is a beast. Running `terraform apply` can take an hour, sometimes more. And gods help you if it fails and leaves the statefile wedged. You decided to set up a new "infra test" environment, so the team can work on changes to the infrastructure without breaking the development test and staging environments. Took a week to get that thing working.

You're up to four environments now, and whenever you make a change to one you have to copy it to the other three projects. Sometimes you don't have time to copy a change to all of them. This leaves the code for each project ... different. "Special."

Running `terraform apply` feels like rolling dice.


## Break it up

I bet you can guess what I'm going to tell you. Sure, the title of this article gives it away, but even without that, you and your team must have discussed splitting your infrastructure code across multiple projects, rather than having it all in one big one.

Let's make one thing clear. Modules won't help you with this. I'm not saying that you shouldn't use modules to share common code, that's fine. But it doesn't help with the problem of having a big hairy Terraform project. Even if all of your code is nicely organized into well-factored modules, when you run `terraform apply`, you're still rolling dice with a honking big pile of infrastructure and a single statefile.

So when we talk about breaking your project up, we're talking about breaking it up so that a given environment is composed of multiple statefiles. We're talking about making it so you can change the code for one project, and plan and apply it on its own.

If your team has chewed over the idea of breaking up your project this way, you've probably also listed the things that would make it hard to pull off. Here are a few:

* Your projects will have dependencies across them, so changing one project might break another. For example, if one project creates a server in a subnet from a different project, you might actually have to tear down the server when you change the subnet.
* While each Terraform project would be smaller, you'd have a lot more of them to cope with.
* How will you actually move the infrastructure out of the current monolithic Terraform project into smaller projects?

I have suggestions.


## Integrate loosely

You know about microservices. My colleague James Lewis wrote [an article on microservices](https://martinfowler.com/articles/microservices.html) on Martin' Fowler's website a few years ago, and our friend Sam Newman has written [a book on microservices](https://samnewman.io/books/) and is beavering away on another one. Plus everyone else in the industry has been talking or blogging about them. So I'm going to go ahead and assume you know what microservices is about.

The thing is, the ideas behind microservice architecture make a lot of sense for infrastructure, too. Small pieces, loosely joined and whatnot. Just like with user-facing software, you should organize your projects so that they're not very tightly coupled. The whole point is that you can make a change to one project, and not worry too much about the others. If every time you change one project you also have to change code in other projects, you're doing it wrong.

There's two key things here. One is where to draw the boundaries between your projects. You want to organize you infrastructure code so that each project hangs together on its own. Usually this means organizing it in a way that matches applications and services, and teams (obligatory shout-out to [Conway's Law](https://www.thoughtworks.com/insights/articles/demystifying-conways-law)!).

The other key thing is _how_ your projects integrate. Going back to one project making a subnet, and another creating a server in that subnet, how does your server project know the `subnet_id` to use?


### Avoid tight coupling between projects

This is a question of integration interfaces. What is the interface that one project - the one making the subnet - provides for another project to consume? With software that integrates over the network, you have an API, using a protocol like [REST](https://en.wikipedia.org/wiki/Representational_state_transfer). With Terraform, you have a few options.

The most popular way to integrate across Terraform projects is to point your server project at the subnet project's statefile. You write a `data "terraform_remote_state"` block, and then refer to the outputs from the other project, as in this [example from the Terraform docs](https://www.terraform.io/docs/providers/terraform/d/remote_state.html).

This is a bad idea. Please don't do it. If you're one of the many people writing tutorials and example code that does this, please stop. There are better ways to do it.

Why do I say that integrating with another project using its remote state is a bad idea? Because tightly couples the two projects.

_Coupling_ is a way to talk about how easy or hard it is to change one project - the provider - without affecting the other - the consumer.

When you write your server project to use an output of the subnet project, you are coupling to that output, and its name. That's usually OK. The team that owns the subnet project needs to understand that's the deal - their outputs are a contract. It's a constraint on them, they can't go changing that output name whenever they want without breaking other code. As long as everyone understands that, you're OK.

But integrating to the output in the statefile, at least the way Terraform currently implements it, couples more tightly than to to the output name. It couples to the data structure. When you apply your consumer project, Terraform reads the statefile for your provider project to find the subnet id.

This can be a problem if you used different versions of Terraform for the projects. If you upgrade to a new version of Terraform that changes the data structures in the statefiles, you need to upgrade all of your projects together.

The point is that you need to be aware of how your projects are coupled. Requiring all of your infrastructure projects to use the same version of the same tool is tight coupling.

So what are the alternatives?

You can integrate using `data "aws_subnet"`, discovering the subnet based on its name or tags. The integration contract is then the name or tag. The project that creates the subnet can't change these things without breaking consumers.

Another is to use a configuration registry, something like Hashicorp's Consul, or any key-value parameter store. Your provider stack puts the value of the subnet_id in the registry, your consumer stack reads it from there. This makes the integration point more explicit - the provider stack code needs to put the value under a certain name.

Another way you can do this is with dependency injection. My colleague [Vincenzo Fabrizi](https://twitter.com/zipponap) suggested this to me. Your consumer project code shouldn't know how to get the value it depends on. Instead, you pass the value in as a parameter. If you run Terraform with a script or makefile or something, then that script fetches it and passes it in. This keeps your code completely decoupled, which will come in handy for testing.


## Testing your Terraform projects

You should write automated tests for your projects, and use CI or even CD to run those tests every time someone commits a change. Testing Terraform code is a big, messy topic. I'll foist you off to my former colleague Rosemary Wang, who wrote about [TDD for infrastructure](https://medium.com/@joatmon08/test-driven-development-techniques-for-infrastructure-a73bd1ab273b), and current colleagues Effy Elden and Shohre Mansouri who created a site with [examples of infrastructure testing tools and code](https://dobetterascode.com/)

Having brushed the specific technical stuff aside, the main thing I have to add is recommending that you be sure you can create and test an instance of each of your Terraform projects on its own. Avoid needing to create instances of other projects in order to test one project. Doing this enforces loose coupling. If you can't do this, then your projects are probably too tightly coupled. Put in the effort to redesign and restructure your projects until you can.

If you can create a standalone instance of your project, and have automated tests you can run against it, then you can use a pipeline to deliver changes to different environments.


## Automate your automation

One of the problems you have in your team is environments getting hosed when different people apply changes to them. One person works on a change and applies it to a test environment. Then someone else runs apply and wipes out the changes the first person had made to their code.

You need to make sure that the code for any given instance of the project is only applied from one place. If you're applying code from your laptop, nobody else should be doing anything on that environment. Nobody should apply code from their laptop to shared use environments, like dev, staging, and production, except in an emergency. Instead, the code should be applied from a server of some sort.

You might use a hosted service like [Terraform Cloud](https://www.terraform.io/docs/cloud/getting-started/runs.html) to apply your code. Or you may use a CD pipeline, and run Terraform there. Either way, you can use the central service to control what version of code is applied where. A central runner also ensures Terraform runs from a consistent environment, with the same version of Terraform.

In addition to managing applies to your environments more cleanly, using a central runner helps to enforce the decoupled design of your infrastructure code. Every time someone commits a change, the project has to run cleanly on its own.


## Refactoring for fun and profit

* How to refactor?
** Editing and moving statefiles - if you were rolling dice with your infrastructure before, now you're playing Russian Roulette!
** Expand and contract.

