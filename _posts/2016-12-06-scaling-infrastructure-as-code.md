---
layout: post
title:  "Scaling Infrastructure as Code"
date:   2016-12-05 14:20:00
categories: book
published: false
---

Since the book came out I've been on the circuit of conferences, meetups, and visiting different organizations. It's been a great way to meet and learn from people at various stages of their infrastructure as code journey (there's a consultant phrase for you), and I seem to learn something every time.

It's interesting to see how teams are coping as their infrastructure codebase grows. As more people start working with it, and as more applications are added onto it, figuring out how to keep it all manageable becomes challenging. This is what I mean by "scaling" - not so much scaling the capacity of a particular application, but increasing complexity of the infrastructure, and number of people working on it.


### Rapid and Reliable

One of my key phrases these days is "Rapid and Reliable". As in, we want to be able to make changes quickly, but we also want to make them safely. As the infrastructure codebase grows, things get broken more often, people become scared to make changes, and discussions start revolving around adding process, meetings, documentation, and approvals.

Our instinct is to throttle the rate of change to avoid breaking things. This is not the way. I've seen many organisations with heavyweight change processes, but few of them actually achieve stability. Complex change processes only seem to make everything more fragile and error-prone. Often I wonder if the goal is less to avoid outages, and more to avoid blame.

[The State of DevOps Report](https://puppet.com/resources/white-paper/2016-state-of-devops-report) makes a convincing case that those organisations which achieve the highest levels of operational reliability and quality are those who make changes faster and more often:

> - High-performing IT organizations deploy 200 times more frequently than low performers, with 2,555 times faster lead times.
> - They have 24 times faster recovery times and three times lower change failure rates.
> - High-performing IT teams spend 50 percent less time remediating security issues. 
> - And they spend 22 percent less time on unplanned work and rework.
>
> --- *The State of DevOps Report*

I'm convinced that the key is keeping the change process simple, repeatable, and with fast feedback loops. There are two movements in the world of software development which are directly relevant to this: Continuous Delivery and Microservices.

Continuous Delivery offers a way to "build quality in" by using automated testing to continuously test code, and to provide a reliable, consistent process for moving changes into production. Microservices emphasizes organizing a codebase into small, loosely coupled units, which can be independently tested and deployed.

These approaches are complementary. It's easier to test and deploy smaller units of code. And deploying and testing multiple units of code is easier with an automated release process.

In my next post I'll describe a pattern for applying these approaches to infrastructure.

