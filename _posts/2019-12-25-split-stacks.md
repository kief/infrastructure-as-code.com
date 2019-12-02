---
layout: post
title:  "Break up your Terraform project before it breaks you"
date:   2019-12-25  14:20:00
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

This is a question of integration interfaces. What is the interface that one project - the one making the subnet - provides for another project to consume? With software that integrates over the network, you have an API, using a protocol like [REST](https://en.wikipedia.org/wiki/Representational_state_transfer). With Terraform, you have a few options.

The most popular way to integrate across Terraform projects is to point your server project at the subnet project's statefile. You write a `data "terraform_remote_state"` block, and then refer to the outputs from the other project, as in this [example from the Terraform docs](https://www.terraform.io/docs/providers/terraform/d/remote_state.html).

This is a bad idea. Please don't do it. If you're one of the many people writing tutorials and example code that does this, please stop. There are better ways to do it.

Why do I say that integrating with another project using its remote state is a bad idea? Because tightly couples the two projects.

_Coupling_ is a way to talk about how easy or hard it is to change one project - the provider - without affecting the other - the consumer.

When you write your server project to use an output of the subnet project, you are coupling to that output, and its name. That's usually OK. The team that owns the subnet project needs to understand that's the deal - their outputs are a contract. It's a constraint on them, they can't go changing that output name whenever they want without breaking other code. As long as everyone understands that, you're OK.

But integrating to the output in the statefile, at least the way Terraform currently implements it, couples more tightly than to to the output name. It couples to the data structure. The thing is, 




 you're deeply coupling your project to the other project. 

It's one thing to couple projects based on code - you knowing the details of how the other project's code is written.


- Integration points, contracts
- Integrating in statefiles == bad idea.
- Integrating using data sources is slightly less bad, but still pretty bad
- Think about these as contracts, and be clear on what people should and shouldn't depend on
- Consider dependency injection. Benefits. Drawbacks - you need some logic to orchestrate the values. This can lead to horrible messes of scripts. That's a topic for another day.

- Keep each piece right-sized
- Think about boundaries. Conway's Law.

- Make sure you can create an instance of each project on its own.
- Having automated tests for each piece, and using a pipeline, 


## Automate your automation

Like with microservices, managing micro infrastructure stacks requires sophisticated stuff. "You must be this tall."

* Reuse the code for those pieces, don't copy/paste
* Make sure you can test each piece at all!
* Use a pipeline to apply changes, so they get made the same way every time


## Refactoring for fun and profit

* How to refactor?
** Editing and moving statefiles - if you were rolling dice with your infrastructure before, now you're playing Russian Roulette!
** Expand and contract.

