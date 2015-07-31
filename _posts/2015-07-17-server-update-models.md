---
layout: post
title:  "Immutable servers and other models for managing server updates"
date:   2015-07-17 16:20:00
categories: book
published: false
---

****
This post is an excerpt from the current draft of my upcoming book, Infrastructure as Code. I welcome feedback on the ideas here, and the book draft if you've [bought and read it](http://oreil.ly/1JKIBVe), at the _feedback_ email address on this site's domain.
****

Dynamic infrastructure makes it easy to create new servers, but keeping them up to date once they've been created is harder. This combination often leads to trouble, in the shape of a sprawling estate of inconsistent servers. Inconsistent servers are difficult to automate, so configuration drift leads to an unmanageable spaghetti infrastructure.

So a processes for managing changes to servers is essential to a well-managed infrastructure. An effective change management process ensures that any new change is rolled out to all relevant existing servers, as well as being applied to newly created servers. All servers should be up to date with the latest approved packages, patches, and configuration.

Goals for the server change process:

- Changes are rolled out to all of the relevant existing servers
- Servers which are meant to be similar are not allowed to drift into inconsistency
- The automated process is the easiest, most natural way for team members to make changes


Our process for updating servers should be effortless, so that it can scale as the number of servers grows. Making changes to a server should be a completely unattended process. A person may initiate a change, for example by committing a change to a configuration definition. Someone may also manually approve a change before it is applied to certain parts of the infrastructure. But the change should roll out to servers without someone turning a handle.

Once a well-oiled server change process is in place, changes become fire and forget. Commit a change, and rely on tests and monitoring to alert the team if a change fails or causes an issue. Problems can be caught and stopped before they're applied to important systems, and even those that slip through can be rapidly rolled back or corrected.

Characteristics of an effective server change process:

- Changes are effortless, regardless of the number of servers affected
- Unattended application of changes
- Errors with a change are made visible quickly


==== Ad-hoc change management

The traditional approach has been to leave servers alone unless a specific change is required. Even with newer configuration management tools like Chef, Puppet, Ansible, etc., many teams still only run them when they have a particular change to make.

As discussed throughout this book, this tends to leave servers inconsistently configured, which in turn makes it difficult to use automation comprehensively. That is, in order to run an automated process across many servers, the state of those servers needs to be generally consistent to start with.


==== Configuration synchronization

With continuous synchronization, configuration definitions are regularly applied and re-applied to servers on an unattended schedule. This ensures that any changes made to parts of the system covered by those definitions are brought back into line, keeping consistency. This, in turn, ensures that the automation can be reliably run.

Configuration synchronization is a good way to keep the discipline of a well-automated infrastructure. The shorter the time between configuration runs, the more quickly issues with the configuration definitions are found. The more quickly issues are found, the more quickly the team can fix them.

Most server configuration tools are designed with this approach in mind.

However, writing and maintaining configuration definitions has overhead, and there is a limit to how much of a server's surface area can be reasonably managed by definitions. This leaves other areas of a server's configuration vulnerable to changes outside the tooling, and therefore configuration drift.


==== Immutable infrastructure

Immutable infrastructure is the practice of making configuration changes by building new infrastructure elements, rather than making a change to the element that is already in usefootnote:[The term immutable servers was coined by my former colleague Ben Butler-Cole when he, Peter Gillard-Moss, and others implemented this for http://www.thoughtworks.com/insights/blog/rethinking-building-cloud-part-4-immutable-servers[ThoughtWorks Mingle SaaS].]. This ensures that any change is tested before being put into production, whereas changes made to running infrastructure could have unexpected effects.

The configuration of a server is baked into the server template. So the contents of a server are predictable - whatever is on the base image, and whatever configuration definitions and/or scripts that make changes when building the template. The only areas of a server which aren't predictable, and tested, are those with runtime states and data.

Immutable servers are still vulnerable to configuration drift, since their configuration could be modified after they've been provisioned. However, the practice is normally combined with keeping the lifespan of servers short - the Phoenix Server pattern. So servers are rebuilt as frequently as every day, leaving little opportunity for unmanaged changes. Another approach to this issue is to make those parts of a server's file systems which should not change at runtime read-only.


.Immutable servers aren't really immutable
***************************************************************
Using the term "immutable" to describe this pattern can be misleading. "Immutable" means that a thing can't be changed, so a truly immutable server would be useless. As soon as a server boots, its runtime state changes - processes run, entries are written to logfiles, and application data is added, updated, and removed.

It's more useful to think of the term immutable as applying to the server's configuration, rather than to the server as a whole. This creates a clear line between configuration and data. It forces teams to explicitly define which elements of a server they will manage deterministically, as configuration, and which elements will be treated as data.
***************************************************************


==== Containerized services

The increasing popularity of standardized methods for packaging, distributing, and orchestrating lightweight containers creates opportunities to simplify server configuration management. With this model, each application or service that runs on a server is packaged into a container along with all of its dependencies. Changes to an application is made by building and deploying a new version of the container. This is the immutable infrastructure concept, applied at the application level.

The servers that host containers can be greatly simplified. They can be stripped down to a minimal system, with only the software and configuration needed to run containers. These hosts could be managed using configuration synchronization or the immutable server model, but in either case, because they are kept simple, their management should be simpler than for more frequently changing servers.

As of this writing, very few organizations have converted their infrastructure as radically as this. Most are using containers for a minority of their applications and services, typically ones that change often, such as software developed in-house. And infrastructure teams are finding that at least some core services work better running directly on the host rather than inside containers. But assuming containerization continues to mature, and becomes a standard way to package applications for distribution, then this could become a dominant model for infrastructure management.
