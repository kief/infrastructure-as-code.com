---
layout: post
title:  "Why Infrastructure as Code"
date:   2016-05-19 13:20:00
categories: book
published: true
---

![question mark](/images/question-mark.jpg){: height="50%" width="50%" align="right" hspace="5"}
The thumbnail definition that I trot out for Infrastructure as Code is using development practices and tools to manage infrastructure. This sounds like a natural thing to do, if you're defining your infrastructure in definitions files used by tools like Chef, Puppet, and Ansible. These files look like source code, and can be checked into Git or other VCS systems like source code.

But what are the actual benefits of treating your infrastructure this way? Configuring infrastructure by editing files in a VCS is a dramatically different way of working than the old-school alternatives - clicking in a GUI-driven configuration, or logging into servers and editing configuration files. To make this shift, and to really get the benefits from it, you need to be pretty clear on what you're trying to get out of it.

The headline benefits of Infrastructure as Code are to be able to easily and responsibly manage changes to infrastructure. We'd like to be able to make changes rapidly, with low risk. And we'd like to keep doing this even as the size and complexity of the infrastructure grows, and as more teams are using our infrastructure.

The enemy of this goal is manually-driven processes. Manual steps to provision, configure, modify, update, and fix things are the most obvious things to eliminate. But manually-driven process and governance can be at least as big an obstacle to frequent, low-risk changes. This becomes especially difficult to handle as an organization grows.

So what kind of benefits should you see from a well-implemented Infrastructure as Code approach?

- Your IT infrastructure supports and enables change, rather than being an obstacle or a constraint for its users.
- Changes to the system are routine, without drama or stress for users or IT staff.
- IT staff spends their time on valuable things which engage their abilities, not on routine, repetitive tasks.
- Users are able to responsibly define, provision, and manage the resources they need, without needing IT staff to do it for them.
- Teams are able to easily and quickly recover from failures, rather than assuming failure can be completely prevented.
- Improvements are made continuously, rather than done through expensive and risky "big bang" projects.
- You find solutions to problems by implementing, testing, and measuring them, rather than by discussing them in meetings and documents.

_(Photo by [Sebastien Wiertz](https://www.flickr.com/photos/wiertz))_


