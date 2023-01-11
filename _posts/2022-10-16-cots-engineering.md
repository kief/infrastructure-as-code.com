---
layout: post
title:  "The problem with most COTS systems"
date:   2022-10-30 16:20:20
image:  
image_alt:  
categories: book
published: false
---

Why do we (twers) not like COTS solutions, like big CMSs, SAP, etc.?

So. On the one hand, yeah, we ought to be able to help our clients with broader parts of their IT systems. But. I'd say the reason we don't do this much is because these systems are not designed to support the kinds of workflows that we find most effective.

A bit of a rant; and this is based on a certain type of COTS system - the big CMS's as application development platforms, SAP, and many others - not necessarily all:

The engineering model for most COTS systems makes it difficult to follow an agile/XP/CD workflow.

You work on a problem by editing configuration directly in an instance of the system, as opposed to in code. You can only test it within a full-blown instance of the system. You can't easily automate tests for the piece you're working on, so no unit testing, no TDD.

You can't automatically trigger tests when you make changes to that piece of the system. So no CI.

You can't extract the change you're working on and deliver it to another environment (instance of the COTS system), instead you make the change manually in each environment. So no CD.

And each instance of the COTS system tends to be very heavyweight, and difficult to configure. You can't quickly spin up a test instance to test your own thing. So instead you use a shared snowflake instance to develop and test.

So when you do replicate your change to another environment, there's a risk it won't work the same, because the test system has changes that other people are working on. In many cases, it has changes that people have started and abandoned, because there's not an easy way to clean up an instance's configuration.

This all makes delivering customizations fiddly and error prone.

It's notable that many people in our industry accept this as normal, including for bespoke software delivery. It's the mentality that we try to shift when we try to help clients move to a more effectively software delivery process. So we have a natural dislike of tools that are built from the ground up in a way that makes effective delivery difficult