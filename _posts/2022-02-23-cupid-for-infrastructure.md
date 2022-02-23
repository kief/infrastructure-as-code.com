---
layout: post
title:  "Unpacking Dan North's CUPID properties for joyful coding"
date:   2022-02-23 22:20:20
image:  /images/Bertel_Thorvaldsen_Cupid.jpg
image_alt:  The sculpture Cupid by Bertel Thorvaldsen
categories: book
published: true
---

Dan North has recently published his long-awaited list of [CUPID properties](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/) for making software a joy to work with. Dan teased CUPID almost a year earlier in a post that declared that [every single element of SOLID is wrong](https://dannorth.net/2021/03/16/cupid-the-back-story/). CUPID is what Dan is proposing as the next level of thinking about the design of code.

![The sculpture Cupid by Bertel Thorvaldsen](/images/Bertel_Thorvaldsen_Cupid.jpg)

CUPID is a novel approach to thinking about software design, forcing Dan to cover a fair bit of meta content before getting into CUPID itself. I found it a lot to take in because of having to stop and chew over these foundational concepts and asides. I'm writing this to help me to do this, so I can then consider how to use his ideas to develop my own thoughts on infrastructure code design. I'll write a follow-up post to this one to go into those thoughts.


## Let's make code joyful to work with

The first novel thing Dan does with CUPID is give it the goal of [making code joyful](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/#joyful-software). He quotes Martin Fowler, "Good programmers write code that humans can understand," and takes it to the next level - write code that humans enjoy reading and working with. Dan selected the CUPID properties, which we'll eventually get to, for their value in looking at how joyful a codebase is to work with.


## Using properties of a design rather than design principles

The next novel thing in Dan's approach to CUPID is to discard the idea of defining principles for design, and instead consider properties of a codebase's design. So we need to grok [properties over principles](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/#properties-over-principles). As Dan sees it, properties are:

> qualities or characteristics of code rather than rules to follow. Properties define a goal or centre to move towards. Your code is only closer to or further from the centre, and there is always a clear direction of travel. You can use properties as a lens or filter to assess your code and you can decide which ones to address next.


## What makes a property useful

If we're going to list properties that make software joyful, we need to decide what makes a good property. So Dan next looks at the [properties of properties](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/#properties-of-properties). The properties Dan aims for with the CUPID properties are:

* Practical: easy to articulate, easy to assess, easy to adopt.
* Human: read from the perspective of people (developers), not code
* Layered: offer guidance for beginners and nuance for more experienced folks

Dan discusses these in a bit more detail, so go ahead and read them. And now we can get into CUPID itself.


## The CUPID properties

Dan defines five properties, which, in one of the few ways he emulates SOLID, he's given names to make up the acronym to name the set. He expands a bit on each one (he's promised to write full posts on each one later on), which I'll summarize here.

* [Composable](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/#composable): _Plays well with others_. Small surface area. Intention revealing. Minimal dependencies. (This plays heavily in my thinking about infrastructure code design.)
* [Unix philosophy](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/#unix-philosophy): _Does one thing well_. A simple, consistent model. Single-purpose vs. single responsibility.
* [Predictable](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/#predictable): _Does what you expect_. Behaves as expected. Deterministic. Observable. (Ooh, how can we design observability into our infrastructure code? Also, I should make it a habit to consider writing characterization tests for my infra code.)
* [Idiomatic](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/#idiomatic): _Feels natural_. (Avoid extraneous cognitive load). Language idioms. Local idioms. (I'm thinking it's hard to write design properties without falling into prescriptive phrasing like "Follow language idioms".)
* [Domain-based](https://dannorth.net/2022/02/10/cupid-for-joyful-coding/#domain-based): _The solution domain models the problem domain in language and structure_. Domain based language. Domain based structure. Domain based boundaries. (Current norms for infrastructure code are quite far from this, another thing I want to think more deeply about.)

