---
layout: post
title:  "What is Infrastructure as Code?"
date:   2015-03-02 11:00:00
categories: book
---

Systems administrators have probably been writing scripts and tools to make their jobs easier since day one. When I joined my first systems team, the mantra "let the machines do the boring work" was drilled into my head. The popularization of cloud (IaaS) and virtualized infrastructure over the past decade has given us the opportunity to automate the boring work in some very different, and cool ways.

We have moved from the Iron Age of infrastructure and into the Cloud Era. The resources of an IT infrastructure - compute, storage, and networking - have been transmogrified from inflexible physical hardware into dynamic software and data. In the Iron Age, the interface for creating a new server was a purchasing request form. In the Cloud Era, it's a programmable API.

So. If our infrastructure is now software and data, manageable through an API, then this means we can bring tools and ways of working from software engineering and use them to manage our infrastructure. This is the essence of Infrastructure as Code.

In software engineering we write code, keep it in a Version Control System (VCS) and automatically test it with [Continuous Integration](http://martinfowler.com/articles/continuousIntegration.html) (CI). We and deploy it to a series of environments using a [Deployment Pipeline](http://martinfowler.com/bliki/DeploymentPipeline.html) so it can be validated before putting it into production use. Now we can easily do the same with infrastructure.

Infrastructure as Code doesn't only apply to cloud and virtualized infrastructures, it can also be used with "bare metal" infrastructure. I've worked with teams who've implemented dynamic hardware system management. We used [Cobbler](http://www.cobblerd.org) to automatically install servers using PXE-boot installation over a network. When we implemented this we had to start the installation at the physical server (boot the server and hold down F12, in our case). But many hardware vendors have [Lights Out Management](http://en.wikipedia.org/wiki/Out-of-band_management) functionality that makes it possible to do this remotely, and even automatically.

