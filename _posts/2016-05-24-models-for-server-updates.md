---
layout: post
title:  "Different models for updating servers"
date:   2016-05-24 09:40:00
categories: book
---

Most teams begin using automation tools like Terraform, Puppet, Chef, and Ansible to provision new infrastructure, but don't use them regularly to make changes and apply updates once the systems are running. Building and configuring a new system from scratch is fairly easy. But writing definition files and scripts that will run reliably across a large number of existing systems is hard.

Chances are, things will have changed on some of those servers. For example, if you have a dozen web servers serving various websites, some sites will have needed an additional plugin or two, configuration tweaks, or even system packages. Problems will have cropped up and been fixed on a few of the servers, but not others.

The little differences and inconsistencies that accumulate between servers over time are [Configuration Drift](http://kief.com/configuration-drift.html). Configuration drift makes it unlikely that a Playbook, Cookbook, Manifest, etc. will run reliably over all of the servers, which leads to the [Automation Fear Spiral](http://infrastructure-as-code.com/book/2015/03/08/automation-fear-spiral.html). This prevents teams from using automated configuration as effectively as they could.


![Rusty car](/images/rusty-car.jpg){: align="right" hspace="5"}



### Models for updating servers

So a key part of any team's infrastructure management approach is how to make changes to existing servers. A good automated change process should be easy and reliable, so that making changes outside the process - logging in and installing a package, for example - just feels wrong.

I summarize four models for updating servers in chapter 4 of the [infrastructure book](http://shop.oreilly.com/product/0636920039297.do), and use them throughout. As with any model, this is just a convenience. Many teams will do things that don't quite fit any one of these models, which is fine if it works for them. The purpose of this is to give us ideas of what might work for us.

The models are:

- Ad-hoc change management
- Configuration synchronization
- Immutable infrastructure
- Containerized services

Each of this is explained in a bit more detail below.


### Ad Hoc Change Management

Ad hoc change management makes changes to servers only when a specific change is needed. This is the traditional, pre-automation approach - log into a server, edit files, install packages, and create user accounts. It still seems to be the most common approach even for people using automation tools like Ansible, Chef, and Puppet. People write or modify a configuration definition and then manually run the tool to apply it to a subset of servers. They don't run the configuration tool unless they have a specific change they want to make.

The problem with this is that it leads to configuration drift and the automation fear cycle, exactly as described above. Often, some servers can go a while without having the automation tool run on them. When someone finally does try to run it, the number of changes made are so large that it's almost guaranteed that something will break.


### Configuration Synchronization

[Configuration synchronization](http://martinfowler.com/bliki/ConfigurationSynchronization.html) repeatedly applies configuration definitions to servers, for example, by running a Puppet or Chef agent on an hourly schedule. This happens on all servers, regardless of whether any changes have been made to the definitions. 

Doing this ensures that any changes made outside of the automation are brought back into line with the definitions. This discourages ad-hoc changes. It also guarantees that every server is up to date, having had all of the current configuration definitions applied.

Regularly applying configuration to all servers also speeds up the feedback cycle for changes, and simplifies finding and fixing problems. When someone rolls out a new change, for example applying a security patch, they can be confident it is the only change being made to systems. This gives them a smaller area to look for the issue, and lower impact for fixing it or rolling it back.

Configuration synchronization is probably the most common approach for teams with a mature infrastructure as code approach. Most server configuration tools, including Chef and Puppet, are designed with this approach in mind. 

It's important to have good monitoring that detects issues quickly, so any problems with a definition can be flagged and fixed. A change management pipeline, similar to a Continuous Delivery pipeline, can be used to automatically deploy changes to a test environment and run tests before allowing it to be applied to production. 

The main limitation of configuration synchronization is that it's not feasible to have configuration definitions covering a significant percentage of a server. So this leaves large parts of a server unmanaged, leaving it open to configuration drift.


### Immutable Infrastructure

Teams using [Immutable infrastructure](http://martinfowler.com/bliki/ImmutableServer.html) make configuration changes by completely replacing servers. A change is made by building a new version of a server template (such as an AMI), and then rebuilding whatever servers are based on that particular template. This increases predictability, since there is little variance between servers as tested, and servers in production.

Immutable infrastructure requires mature processes and tooling for building and managing server templates. [Packer](https://www.packer.io/) is the go-to tool for building server images. As with configuration synchronization, a pipeline to automatically test and roll out server images is useful.


### Containerized Services

Containerized services works by packaging applications and services in lightweight containers (as popularized by [Docker](https://www.docker.com/)). This reduces coupling between server configuration and the things that run on the servers.

Container host servers still need to be managed using one of the other models. However, they tend to be very simple, because they don't need to do much other than running containers. 

Most of the team's effort and attention goes into packaging, testing, distributing, and orchestrating the services and applications, but this follows something similar to the immutable infrastructure model, which again is simpler than managing the configuration of full-blow virtual machines and servers.

