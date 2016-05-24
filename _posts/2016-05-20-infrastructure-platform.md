---
layout: post
title:  "Dynamic Infrastructure Platforms"
date:   2016-05-20 10:20:00
categories: book
published: true
---

A _dynamic infrastructure platform_ is a fundamental requirement for Infrastructure as Code. I define this as _"a system that provides computing resources, particularly servers, storage, and networking, in a way that they can be programmatically allocated and managed."_

In practice, this most often means a public IaaS (Infrastructure as a Service) cloud like Amazon's AWS, Google's GCE, or Microsoft's Azure. But it can also be a private cloud platform using something like OpenStack or VMware vCloud. A dynamic infrastructure platform can also be implemented with an API-driven virtualization system like VMware. These systems normally force your infrastructure management tools to explicitly decide where to allocation resources - which hypervisor instance to start a VM on, which storage pool to allocate a network share from, etc. But this is still compatible with Infrastructure as Code, because it's all programmable.

Many organizations, including DevOps paragons like [Etsy](https://codeascraft.com/2016/02/22/putting-the-dev-in-devops-bringing-software-engineering-to-operations-infrastructure-tooling/) and [Spotify](https://labs.spotify.com/2016/03/25/managing-machines-at-spotify/), implement Infrastructure as Code on bare-metal, with no virtualization or cloud at all. Tools such as Cobbler or Foreman to automatically provision physical servers, leveraging ILO (Integrated Lights Out) features of the server hardware.

The key characteristics needed from an infrastructure platform for Infrastructure as Code are:

- Programmable
- On-demand
- Self-service


### Programmable

A dynamic infrastructure platform must be programmable. An API makes it possible for scripts, software, and tools to interact with the platform. Even if you're using an off-the-shelf tool like Terraform or Ansible to provision infrastructure, you'll almost certainly need to write some custom scripting or tools here and there. So you should make sure the platform's API has good support for scripting languages that your team is comfortable with. Keep in mind the difference between "good" support for the language, and just having a tickbox.


### On-Demand

The dynamic infrastructure platform needs to allow resources to be created and destroyed immediately. You would think this is obvious, but it's not always the case. Some managed hosting providers, and internal IT departments, offer services they call "cloud", but which require raising tickets to get someone else to make it happen. The hosting platform needs to be able to fulfill provisioning requests within minutes, if not seconds.

Billing and budgeting also need to be structured to support on-demand, incremental charging. If you need to sign a contract, or issue a purchase order, in order to create a new server, then it's not going to work. If adding a new server requires a commitment of more than an hour, it's not going to work.

Also, if your "cloud" hosting provider charges you for the hardware you'll be using, and then charges you for each VM you run, then you're being taken advantage of. That's not how cloud works.

![Lego SHIELD helicarrier](/images/lego-shield-carrier.jpg){: align="right" hspace="5"}

### Self-Service

Self-service takes the on-demand requirement, and adds a bit more. It's not enough to be able to get resources like servers quickly, you need to be able to customize and tailor them yourself. You shouldn't need to get someone else to approve how much RAM and how many CPU's your server will have. You should be able to tweak and adjust these things on existing servers.

Specifying your environment's details, and changing it, will actually be done in definition files (like a Terraform file), using the platform's programmable API. So any arrangement where a central group does this for you isn't going to work.

I like the analogy fo Lego bricks. A central IT group that manages your cloud for you is like buying a box of Lego bricks, but having the shop staff decide how to assemble them for you. It stops you from taking ownership of the infrastructure you use. You won't be able to learn how to to shape your infrastructure to your own needs and improve it over time.

Worse is when a central IT team offers you a catalog of pre-defined infrastructure. This is like only being able to buy a Lego set that has already been built for you and glued together. You've got no ability to adjust and improve it. You often can't even request a change, such as a newer version of a JVM. Instead, you have to wait for the central group to build and test a new standard offering.


### What you want

Ultimately, your infrastructure platform needs to give you the ability to define your infrastructure in files, and have your tools provision and update that infrastructure. This reduces your reliance on an overworked central team, and ensures you can continuously improve and adapt your infrastructure to support the application you run on it as effectively as possible.

