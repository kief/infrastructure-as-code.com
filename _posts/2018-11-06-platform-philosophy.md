---
layout: post
title:  "Platform service models"
date:   2018-11-06 12:00:01
categories: platforms
published: true
---

Many of our clients at ThoughtWorks are building internal services for development teams to use in developing, delivering, and running applications. I'm often asked what the model for this should be in terms of developer experience. Should developers be able to write their own infrastructure code? Should they package up and release their own Docker images on infrastructure that's built for them?

I believe a layered approach is best. Teams should be able to reach for the level of tooling that suits their needs and capabilities. If there are solid services available within the organization, then they should be able to re-use those. If not, they should be able to use lower-level services provided for them, and follow examples and templates from other teams. If none of these exist, they should be able to build their own, following shared principles, policies, and governance.


## Developer experience models

A good model for developer experience is:

1. I prefer to just write my application code and push it to something that will run it. This is the serverless model, as well as the "build-pack" model used by Heroku and some PaaS platforms.
2. If that's not available or appropriate for my needs, then I prefer to package my code and runtime and push it. This is the container model, with a container orchestration service like Kubernetes or Nomad already available and running.
3. If that's not appropriate, I prefer to push my package with standardized Infrastructure as Code. That is, someone else has written infrastructure modules and/or code that I can grab and use to provision the infrastructure my application needs.
4. If that's not appropriate, then I prefer to write custom Infrastructure as Code in a standard tool (like Terraform, CloudFormation, etc.).
5. If that's not appropriate, I want to have an API (e.g. REST-based) so that I can write custom scripts.

A given application might rely on multiple platform services, some of which may be provided in different ways. For example, maybe I can write application code and push it to the platform to package and deploy it for me (#1), but I may need to write infrastructure code to provision and configure a database using a DBaaS model (#3), that my application connects to.

Clearly, #1 is the slickest thing to offer to your development teams. But it's not practical to think your organization can provide this level of experience for everything every team will need, unless your needs are very simple.

In practice, centralized teams are best off first providing services in the simplest way possible, which will tend to be APIs, hopefully ones supported by standard tools. Typically this happens by installing packaged software, and by opening up access to public cloud and SaaS accounts, and giving teams access to go ahead and configure and use these according to their needs.

Then, central teams can focus on incrementally building shared services which have the most commonality and value across teams.

This incremental approach is essential to avoid the all-too-common Big Platform Programme. These involve spending piles of money, and months and years of time, followed by the release of an underwhelming "MVP", typically heavily restricted and limited. The result of this kind of platform strategy is that teams working on high profile projects persuade their executive sponsors to approve them going directly to public cloud. Meanwhile teams on lower profile projects remain on legacy platforms.


## Service sharing models

Another dimension of platform services is the service model. Again, this is a hierarchy:

1. Shared managed service. As a product team, I can just interact with something that someone else keeps running. This is essentially SaaS, the true cloud model. Variations of this are a shared, multi-tenant service - all the customers are using a single instance of the service, vs. self-provisioned service. The latter is like a public cloud DBaaS database, where you can provision your own database instance. Either way, you will interact with it using one of the developer experience models described above.
2. Shared service package. As a product team, I can spin up and run an instance of the service for myself, using a package provided for me. I am responsible for keeping it running, upgrading it, etc. This is essentially the packaged software model, although within an organization the package is probably more customized. An example is a server OS build, that has been hardened, had standard agents for monitoring etc., pre-installed.
3. Shared code. As a product team, I can use code, templates, libraries, etc. that have been provided for me. For each shared code project, a central team provides a certain standard of support, manages versions, keeps it updated, etc.
4. Example code. As a product team, I can copy code, templates, etc. from other teams. Those teams don't commit to support me, won't worry about releasing updates that will be easy for me to apply to my things, and may not even keep the code maintained.
5. Principles, policies, and patterns. As a product team, I can write my own code to provide a service I need. I should follow shared principles (e.g. "Define infrastructure as code"), must follow policies and governance processes, and may follow patterns.

As with developer experience patterns, these can be built up incrementally from the bottom levels up. First, define common principles, policies, etc. that anyone who is building services should or must follow. Then, as teams begin building their own services, make it easy for them to share their code with each other. Identify services which are most commonly used, and build more maintained code libraries for those. Consider packaging them up so that teams can use them more easily. For some things which are very common, create managed services.

Rather than trying to define all of this up front, an evolutionary strategy allows services to emerge organically based on what is most important. Building shared services incrementally is more pragmatic, and creates value and feedback more quickly, than attempting to build a Big Platform Up Front.


## Platform team models

This is a fairly big and complex topic. But briefly, I usually encourage organizations to avoid having a single big platform team, preferring multiple teams organized around concerns that hang together. Companies like Netflix, Spotify, and Etsy, who are all pretty good at this stuff, tend to have teams such as compute, observability, traffic, etc. This encourages building a collection of loosely coupled services and capabilities, as opposed to monolithic "platforms" which quickly become legacy.

These teams should also focus on building (and in some cases running) things for other teams to use, rather than using them for the other teams. For example, the conversation should not be, "Hey monitoring team, can you add some monitoring checks for my application?" Instead it should be, "Hey monitoring team, how do I add monitoring checks for my application?" The monitoring team keeps the monitoring service running, and provide support and help to teams who need it.


## Acknowledgement

Thanks to current and former ThoughtWorks colleagues Peter Gillard-Moss, Karl Stoney, Moritz Heiber, and Bill Codding, for the email thread that spurred me to describe my thoughts on this. Particular thanks to Peter for encouraging me to blog it.
