---
layout: post
title:  "Break up your Terraform project before it breaks you"
date:   2019-12-01  14:20:00
categories: practices
published: false
---

Your Terraform project is out of control. Oh, it started fine. You and your crew needed a standard set of infrastructure for the application. Web server, application server, database cluster. A few security groups, network routes, and gateway, some IAM roles, that sort of thing. Five or six files, none of them more than sixty lines of HCL.


## Playing dice with your universe

But look at it now. You started building containers for your application as it turned into a bunch of micro(ish)-services, and obviously, you needed a Kubernetes cluster to run them. There's code for the cluster, and more to build the host nodes and manage how they get scaled up and down. You've reshuffled that code a few times, nicely organized into four `.tf` files rather than one massive `.tf` file.

At least you finally moved off your hand-rolled ELK stack onto your cloud provider's log aggregation service, but that's still a couple of `.tf` files. And few people on your team are working on the new API gateway implementation, which will be handy now that you're running a couple dozen micro(ish)-services.

This environment is a beast. Running `terraform apply` can take an hour, sometimes more. And just hope it doesn't fail and leave the state file wedged.

You're up to four environments now, and whenever you make a change to one, you have to copy it to the other three projects. Sometimes you don't have time to copy a change to all of them. Because of this, the code for each project is ... different. "Special."

Running `terraform apply` feels like rolling dice.


## Break it up

I bet you can guess what I'm going to tell you. Sure, the title of this article gives it away, but even without that, you and your team must have discussed splitting your infrastructure code across multiple projects, rather than having it all in one big one.

Let's make one thing clear. Modules won't help you with this. I'm not saying that you shouldn't use modules to share code, that's fine. But modules won't shrink your big hairy Terraform project; they'll only make it look organized. When you run `terraform apply`, you're still rolling dice with a big honking pile of infrastructure and a single state file.

So when we talk about breaking your project up, we're talking about breaking it up so that a given environment is composed of multiple state files. We're talking about making it so you can change the code for one project, and `plan` and `apply` it on its own.

If your team has chewed over the idea of breaking up your project this way, you've probably also considered some of the things that would make it hard to pull off:

* Your projects will have dependencies across them, so changing one project might break another. For example, if one project creates a server in a subnet from a different project, you might have to tear down the server when you change the subnet.
* While each Terraform project would be smaller on its own, you'd have a lot more of them to manage.
* How will you move the infrastructure out of the current monolithic Terraform project into smaller projects?

I have suggestions.


## Integrate loosely

I suspect you're aware of microservices, given the buzz (not to say hype) in the industry. You can read what my colleague [James Lewis wrote](https://martinfowler.com/articles/microservices.html) on Martin' Fowler's website a few years ago, or read our friend Sam Newman's [books on the subject](https://samnewman.io/books/).

The "small pieces, loosely joined" idea behind microservice architecture make a lot of sense for infrastructure, too. Just like with user-facing software, you should organize your projects so that they're not very tightly coupled. The point is that you can make a change to one project, and not worry too much about the others. If every time you change one project, you also have to change code in other projects, you're doing it wrong.

There are two key concerns. One is where to draw the boundaries between your projects. You want to organize your infrastructure code so that each project works on its own. Usually, this means organizing it in a way that matches applications and services, and teams (see [Conway's Law](https://www.thoughtworks.com/insights/articles/demystifying-conways-law)).

The other key concern is _how_ your projects integrate. Returning to the example of one project that makes a subnet, and another that creates a server in that subnet, how does your server project know the `subnet_id` to use?


### Avoid tight coupling between projects

How does the project that creates the subnet make it available to projects that use the subnet? With software that integrates over the network, you have an API, using a protocol like [REST](https://en.wikipedia.org/wiki/Representational_state_transfer). With Terraform, you have a few options.

The most popular way to integrate across Terraform projects is to point your server project at the subnet project's state file. You write a `data "terraform_remote_state"` block, and then refer to the outputs from the other project, as in this [example from the Terraform docs](https://www.terraform.io/docs/providers/terraform/d/remote_state.html).

This is a bad idea. Integrating using state files creates a tight coupling between projects.

As you may know, _coupling_ is a term that describes how easy or hard it is to change one project without affecting the other.

When you write your server project to depend on an output of the subnet project, you are coupling to that output and its name. That's usually OK. The team that owns the subnet project needs to understand that its outputs are a contract. They have the constraint that they can't change that output name whenever they want without breaking other code. As long as everyone understands that, you're OK.

But integration with the output in a state file, at least the way Terraform currently implements it, couples more tightly than just integrating with the output name. It couples to the data structure. When you apply your consumer project, Terraform reads the state file for your provider project to find the subnet id.

Doing this can be a problem if you used different versions of Terraform for the projects. If you upgrade to a new version of Terraform that changes the data structures in the state files, you need to upgrade all of your projects together.

The point is that you need to be aware of how your projects are coupled. Requiring all of your infrastructure projects to use the same version of the same tool is tight coupling.

So what are the alternatives?

You can integrate using `data "aws_subnet"`, discovering the subnet based on its name or tags. The integration contract is then the name or tag. The project that creates the subnet can't change these things without breaking consumers.

Another is to use a configuration registry, something like Hashicorp's Consul, or any key-value parameter store. Your provider stack puts the value of the `subnet_id` in the registry, your consumer stack reads it from there. Doing this makes the integration point more explicit - the provider stack code needs to put the value under a specific name.

Another way you can do this is with [dependency injection](https://martinfowler.com/articles/injection.html). My colleague [Vincenzo Fabrizi](https://twitter.com/zipponap) suggested this to me.

Your consumer project code shouldn't be responsible for getting the value. Instead, you pass the value as a parameter. If you run Terraform with a script or Makefile, then that script fetches it and passes it in. This keeps your code decoupled, which comes in handy for testing.


## Testing your Terraform projects

You should write automated tests for your Terraform projects, and use CI or even CD to run those tests every time someone commits a change. Testing Terraform code is a big, messy topic. I'll foist you off to my former colleague Rosemary Wang, who wrote about [TDD for infrastructure](https://medium.com/@joatmon08/test-driven-development-techniques-for-infrastructure-a73bd1ab273b), and current colleagues Effy Elden and Shohre Mansouri who created a site with [examples of infrastructure testing tools and code](https://dobetterascode.com/)

Using these tools and techniques, you should create and test each of your Terraform projects on its own. Avoid needing to create instances of other projects to test one project. Doing this enforces loose coupling. If you can't do this, then your projects are probably too tightly coupled. Put in the effort to redesign and restructure your projects until you can.

If you can create a standalone instance of your project, and have automated tests you can run against it, then you can use a pipeline to deliver changes to different environments.


## Automate your automation

One of the problems you have in your team is environments getting hosed when different people apply changes. One person works on a change and applies it to a test environment. Then someone else applies a different version of the code from their own machine, wiping out the first person's work. Things get confusing and messy.

You should make sure that the code for any given instance of the project is only applied from one place. If you're applying code from your laptop, nobody else should be doing anything to that environment. Nobody should apply code from their laptop to shared use environments, like "dev", "staging", and "production", except in an emergency. Instead, you should always apply the code from a central location.

You might use a hosted service like [Terraform Cloud](https://www.terraform.io/docs/cloud/getting-started/runs.html) to apply your code. Or you could run Terraform from a CI job or CD stage. Either way, you can use the central service to control what version of code is applied where. A central runner also ensures Terraform runs from a consistent environment, with the same version of Terraform.

In addition to applying code to your environments more cleanly, using a central runner helps to enforce the decoupled design of your infrastructure code. Every time someone commits a change, the project has to run cleanly on its own.


## Refactoring for fun and profit

[Refactoring](https://martinfowler.com/articles/workflowsOfRefactoring/) is changing code without changing its behavior. When you refactor a single Terraform project into separate projects, the resulting infrastructure should look the same.

Refactoring application code is straightforward. Change the code, rebuild it, run tests that show that it behaves the same, then deploy it. Refactoring Terraform code is similar, except for the "deploy" part. You're not only changing the code, but you're also changing the state files.

The Terraform CLI includes the [state](https://www.terraform.io/docs/commands/state/mv.html) command, which you can use to move state from one state file to another. You create your new Terraform project, and you transfer the state for resources from the original project's state file to the new project state file. You can run `terraform plan` as you go to check that each piece is moved. You know everything is complete when `terraform plan` reports that it won't change anything on the new project.

This is a very tricky operation. One wrong command, and you're in a crisis, scrambling to undo the damage. If you back up your state files beforehand and don't run `terraform apply` until `terraform plan` tells you you're clear, you shouldn't damage your live system. But it's a painstaking process, and overly manual.

I'm not currently aware of any tools to automate this process, but I'm sure we'll see them soon. However, I have a technique that can de-risk the process that you can use today.

My friend [Pat Downey](https://twitter.com/pat_downey) explained how his team uses the "expand-contract" pattern used for refactoring database schemas, also called "[Parallel Change](https://martinfowler.com/bliki/ParallelChange.html)", for Terraform projects.

In a nutshell, this is a three-step process:

1. Expand: Create the infrastructure in the new project, without touching the old project. For example, create your new project that creates a new subnet.
2. Migrate: Make and apply code changes needed to start using the new infrastructure. This involves implementing whatever integration technique you've chosen. In our example, you edit the original project so that the server uses the new subnet id. At this point, the old subnet still exists. If multiple things are using the subnet, you might break this step of the process down to migrate them one by one.
3. Contract: Once the original resource is no longer used, delete it from the code and remove it from the infrastructure.

You can handle the projects in different ways. For example, rather than creating the subnet in a new project and leaving the server in the old one, you might do it the other way around. Or you might make two new projects, one for the subnet and one for the server, completely retiring the original project once everything is moved out.

The advantage of expanding and contracting infrastructure, rather than editing state files, is that you can implement it entirely with CD pipelines, avoiding the need to run any special one-off commands. Create a pipeline for each project involved and then push the code changes through them. The expand, migrate, and contract steps are each a commit to the codebase, pushed through the pipeline. The pipeline tests each change in an upstream environment before being applying it to production.


## Splitting stacks for fun and profit

If you want to learn more, I recommend watching Nicki Watt's presentation on [Evolving Your Infrastructure with Terraform](https://www.hashicorp.com/resources/evolving-infrastructure-terraform-opencredo).

I expect we'll be breaking monolithic stacks apart more often in the next few years. We're already seeing the first generation of Terraform projects grow and mature, and many people are in this situation. And even once we all get a better handle on how to design and manage modern infrastructure, our systems will continuously evolve, so we'll always need to refactor and improve them. 
