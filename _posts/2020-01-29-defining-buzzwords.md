---
layout: post
title:  "DevOps, SRE, GitOps, Observability: My take on some current-ish buzzwords"
date:   2020-01-29 08:50:00
published: true
---

Blog posts about "What is DevOps" are a dime a dozen. I find myself repeating my 0.8 cent version of this, and other buzzwords that people knock around these days. So I figured I'd throw my thoughts onto the pile.

*DevOps* is about integrating the flow of work across development and operations. Tooling, technology, and practices can help you do this - cloud, Infrastructure as Code, and Continuous Delivery come to mind. Culture is essential to make sure that people align themselves and work in ways that do make the flow smooth. Organizations that adopt the tools without the culture fail to get the benefits of DevOps. I recommend [Effective Devops](https://www.amazon.com/Effective-DevOps-Building-Collaboration-Affinity/dp/1491926309?tag=kiefcom07-20) by Jennifer Davis and Ryn Daniels. The [DORA research](https://cloud.google.com/devops) is essential reading.

*You build it, you run it* is the idea that the people who build a thing own it in production. This structure is one way to address the cultural alignment aspect of DevOps, although it's not the only way. I suggest looking into [Team Topologies](https://teamtopologies.com/) by Matthew Skelton and Manuel Pais for more.

*Infrastructure as Code* is an approach to defining and building systems that draws from software development practices. It gives you ways to safely empower application teams to define the infrastructure for their applications and to create consistent implementation and governance across environments. For more on this, I recommend, well, [the book I'm rewriting on the topic](/book/).

*GitOps* is (in my simplistic view) using branches in source control as artifacts for a Continuous Delivery pipeline for Infrastructure as Code. In many implementations, it's also about pull-based changes - something watches the branches and applies changes to the corresponding environment when they change. WeaveWorks has [pioneered the concept](https://www.weave.works/blog/what-is-gitops-really). Although they tend to focus on using it for Kubernetes clusters, I see people using the idea - or at least, the term - in other contexts.

*Observability* is about giving developers a better view of what their code is doing in production. It has, I guess inevitably, been co-opted by vendors as a hip new label for their monitoring and log aggregation products. [Honeycomb.io](https://docs.honeycomb.io/learning-about-observability/intro-to-observability/) is the leading champion for observability. You should read anything and everything [Charity Majors says about observability](https://charity.wtf/tag/observability/).
