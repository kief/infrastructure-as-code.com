---
layout: post
title:  "The Automation Fear Spiral"
date:   2015-03-08 09:00:00
categories: book
---

At an open spaces session on configuration automation at a [DevOpsDays](http://www.devopsdays.org) a year or two ago, I asked the group how many of them were using an automation tools like Puppet or Chef. The majority of hands went up. I asked how many were running these tools unattended, on an automatic schedule. Quite a few of the hands went down.

Many people have the same problem I had in my early days of using automation tools. I used automation selectively, for example to help build new servers, or to make a specific configuration change. I tweaked the configuration each time I ran it, to suit the particular task I was doing.

I was afraid to turn my back on my automation tools, because I lacked confidence in what they would do.

I lacked confidence in my automation because my servers were not consistent.

My servers were not consistent because I wasn't running automation frequently and consistently.

![Automation fear spiral](/images/automation-fear-spiral.png)

This is the automation fear spiral. Infrastructure teams need to break this spiral to use automation successfully. 

The most effective way to break the spiral is to face your fears. Pick a subset of your servers, choose one or two things on them to put under configuration management, and then schedule these to be applied unattended, at least once an hour.

Starting small and simple helps to limit the risk. The important thing is that you take the leap - let the automation go on its own, without you holding its hand. Then you can increase the scope - add a few more parts of the server to the automation, and extend it to more servers.

You should also build out other things that will give you more confidence, piece by piece. Add monitoring to detect when the thing you've automated goes wrong. Set up [Continuous Integration](http://www.martinfowler.com/articles/continuousIntegration.html) to automatically test the configuration change every time you commit. Again, getting these pieces in place with a small, simple set of configuration, creates the platform. You can then extend the coverage with confidence.

