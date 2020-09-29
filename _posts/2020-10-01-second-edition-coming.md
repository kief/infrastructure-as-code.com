---
layout: post
title:  "Second Edition of Infrastructure as Code"
date:   2020-09-29 02:21:00
categories: book
published: true
---

I've delivered the second edition of the book to O'Reilly's production department, and the wheels are turning to have it available by the end of the year. See the [Book page](/book/) for details on pre-ordering.


## Why I wrote the first edition

The benefits of infrastructure as code don't come from the tools themselves. They come from how you use them. The trick is to leverage the technology to embed quality, reliability, and compliance into the process of making changes.

I wrote the first edition of this book because I didn't see a cohesive collection of guidance on how to manage infrastructure as code. There was plenty of advice scattered across blog posts, conference talks, and documentation for products and projects. But you needed to sift through everything and piece a strategy together for yourself, and most people didn't have the time.

The experience of writing the first edition was amazing. It gave me the opportunity to travel and talk with people around the world about their own experiences. These conversations gave me new insights and exposed me to new challenges. I learned that the value of writing a book, speaking at conferences, and consulting with clients is that it fosters conversations. As an industry, we are still gathering, sharing, and evolving our ideas for managing infrastructure as code.


## Why a second edition

Things have moved along since the first edition came out in June 2016. That edition was subtitled "managing servers in the cloud," which reflects that most infrastructure automation until that point focused on configuring servers. Since then, containers and clusters have become a much bigger deal, and the infrastructure action has moved to managing collections of infrastructure resources provisioned from cloud platforms, what I (and many but not all other people) call _stacks_.

So the new edition talks a lot more about building stacks, the remit of tools like CloudFormation, Terraform, and Pulumi.

I've changed quite a bit based on what I've learned about the evolving challenges and needs of teams building infrastructure. As I've already touched on, I see making it safe and easy to change infrastructure as the key benefit of infrastructure as code. I believe people underestimate the importance of this, thinking that infrastructure is something you build and forget.

But too many teams I meet struggle to meet the needs of their organizations, not able to expand and scale quickly enough, support the pace of software delivery, or provide the reliability and security expected. And when we dig into the details of their challenges, it's that they are overwhelmed by the need to update, fix, and improve their systems. So I've doubled down on this as the core theme of the second edition.

The new edition introduces three core practices for using Infrastructure as Code to make changes safely and easily. _Define everything as code_ is obvious from the name, and creates repeatability and consistency. _Continuously integrating, testing, and delivering_ each change enhances safety. It also makes it possible to move faster and with confidence. _Small, independent pieces_ are easier and safer to change than larger pieces.

These three practices are mutually reinforcing. Code is easy to track, version, deliver across stages of a change management process. It's easier to continuously test smaller pieces. Continuously testing each piece on its own forces you to keep a loosely coupled design.

These practices and the details of how to do them are familiar from the world of software development. I drew on agile software engineering and delivery practices for the first edition of the book. For the new edition I've also drawn on rules and practices for effective design.

In the past few years I've seen teams struggle with larger and more complicated infrastructure systems, and seen the benefits of applying lessons learned in software design patterns and principles. So I've included several chapters on how to do this.

I've also seen that organizing and working with infrastructure code is difficult for many teams, so I've addressed various pain points I've seen. How to keep codebases well organized, provide development and test instances for infrastructure, and manage collaboration of multiple people, including those responsible for governance.


## What's next

I don't believe we've matured as an industry in how we manage infrastructure. I'm planning to write a bit more on this blog and elsewhere on what I see as ways we can do better. I'm also hoping to assemble examples of infrastructure code that illustrate how to do this.

