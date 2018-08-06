---
layout: post
title:  "Splitting and joining stacks, part one - Why?"
date:   2018-07-16 16:20:00
categories: book
published: false
---

Keeping an infrastructure codebase manageable becomes increasingly difficult as the codebase grows in size and complexity, and as more and more people become involved in working on it. One strategy for managing infrastructure as code effectively is to split the system into smaller pieces, and integrate them together.

## The joys of a good codebase

The goal of an effective infrastructure codebase is for people to be able to make changes to the codebase easily, while maintaining standards. A clean codebase is easy to understand, so that it doesn't take much effort to understand how to implement a given change, and so that the impact on the rest of the codebase is clear. The blast radius of making a change should be small, so that the risk of getting a change wrong is lower, which means the stakes are lower, which means the amount of time and energy needed to manage each change is lower.

And it should be easy to maintain delivery and testing code along with the infrastructure code. This means automated test code that validates that the infrastructure code works as expected, and pipeline code that progresses each code change through integration and validation steps, giving visibility and confidence in changes before they are applied to production.

## Environments and stacks

Previously, I've echoed other peoples' recommendations to avoid explicitly defining multiple, separate environments in a single infrastructure "stack". That is, rather than having a single CloudFormation stack or Terraform statefile, that includes "dev", "staging", "production", etc., instead each environment should be a separate infrastructure stack instance. This way, changes to one stack instance won't impact another.

But I advocate a different twist on this than what many others suggest. Rather than maintaining a separate stack definition (code project) for each stack instance, I recommend creating a single stack definition as a template that is used to manage multiple stack instances. The stack management tool (Terraform, CloudFormation, etc.) is run on the codebase with a different set of parameters for each stack instance.

The benefit of this is consistency and reproducibility. You can apply a version of your stack definition to a test environment, carry out testing, and be assured that your production environment will behave the same way when you apply the same code version to it.

Infrastructure code can be applied to a series of environments through to production using a pipeline, following the practices of Continuous Delivery.


## The problem of scale

Working with your infrastructure as a stack template becomes challenging as the size of the stack grows. A large codebase is challenging in any case, but it can make the pipeline unworkable pretty quickly unless managed.

The problems is that applying a large stack definition can take a while, and can easily break. A pipeline's value is being run frequently. People actively working on an infrastructure might make changes to it multiple times a day. The more people working on the infrastructure, and the more teams involved, the more frequently changes are pushed into the pipeline. If it takes too long to spin up a test environment, and if breakages happen to frequently, then people become frustrated with the whole thing.


## Fanning in pipelines

As with any software, infrastructure becomes more tractable when it is broken down into smaller, more loosely coupled pieces. The goal is that each piece can be instantiated and tested on its own before being integrated and tested together with the other pieces. Each piece has its own pipeline that runs every time a change is committed. If the change successfully passes through the pipeline for that piece, it is then "fanned in", triggering a pipeline that includes other parts of the overall system, deploying and testing them together.

By breaking the infrastructure into smaller pieces and testing each piece independently, people get faster feedback on each change. Testing the smaller piece should be quicker, and should expose the most common problems. Then the more integrated pipeline is testing a set of pieces that have already been validated to work on their own, so that the scope of testing is limited to integration problems - what might go wrong across the pieces, as opposed to looking for narrower issues.

Another benefit of breaking infrastructure into smaller pieces is that it becomes easier to understand, easier to test, and easier to change. Breaking infrastructure apart forces us to think through where each piece is divided, what belongs in each piece, and how they interact with one another. The result should be a set of pieces which are easy to understand on their own, and easier to understand together.


## Decoupled pipelines

With even larger systems, fanning in for integration testing may not be feasible. At the enterprise level with thousands of engineers working on software and infrastructure, it simply isn't possible to bring each change into a fully integrated environment and test it one by one. Some organisations cope with this by having very large release and integration testing processes.

These tend to be both slow and ineffective. Environments are plagued by inconsistencies, with differing versions of infrastructure software, configuration, and data in different environments. It's typical for regimes like this to have failures and rollbacks, change freezes, and other wasteful activities to work around fragile systems with poor visibility.

More successful large scale technical organisations decouple changes to their systems. They provide mechanisms to integrate and test changes to any part of their system, but don't require the owners of every part of the system to coordinate every change. The model is an API ecosystem across organisations. A cloud vendor doesn't require an end-to-end test across all of their customers before rolling out an update to part of their system. Instead, they insure contracts are clearly defined, and use automation to ensure the integrity of their contracts when making a change.


## Levels of components

An infrastructure - or really, the system as a whole - is comprised of different types of pieces. Different types of pieces are handled in different ways when it comes to testing and delivering them independently.

In this series I am large focusing on infrastructure stacks. That is, a collection of infrastructure resources that are provisioned on a platform - typically a cloud - as a unit, using a tool like Terraform, CloudFormation, etc. So a stack will tend to have some combination of compute resources (server instances, container instances, serverless code, etc.), networking, and storage.

Other elements of the system include application code to be deployed, server OS configuration elements (e.g. Chef cookbooks, Puppet manifests, Ansible playbooks, etc.), data structures (e.g. database schemas), and data itself.

Each of these elements can be tested and delivered independently before being integrated with more infrastructure. For example, it's common for application code to be unit tested, and even tested by running it within a test agent (e.g. a CI service node that runs a Java webapp on its own for testing), before deploying it to a production-like environment (e.g. one with a web server, network routing, database instance, etc.)

Other infrastructure elements may be tested in isolation as well. For example, a tool like test-kitchen can be used to test a Chef cookbook in isolation, perhaps within a container, without needing an entire server instance to be provisioned. This means the code can be tested in a cleanly-built environment, with nothing installed other than what is needed to validate the cookbook is correct. This kind of testing can be designed to run very quickly, and then publish the cookbook for use in pipelines that bring it together with other cookbooks, applications, and even full infrastructure.


## Splitting and joining stacks

At the stack level, it's possible to divide a large stack into smaller stacks. The goal is not only to make the codebase more cleanly organized, but also to enable each stack to be instantiated and tested in isolation. Smaller stacks should spin up more quickly, and their associated test suites have a smaller surface area to validate. So people can get faster feedback when they make a change, and find it easier to find and fix issues that crop up.

There are two sides to breaking infrastructure into stacks. One is deciding where to divide the infrastructure - what are the natural "seams" for your infrastructure and the code which defines it? The other is implementing the integration - how does infrastructure provisioned in one stack connect up with pieces of infrastructure provisioned in another stack?

These will be addressed in two following posts: splitting stacks, and joining stacks.


