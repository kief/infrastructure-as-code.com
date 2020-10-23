---
layout: post
title:  "Using stories to implement NFRs and CFRs"
date:   2099-01-01 16:20:20
categories: book
published: false
---

(Copied from a chat thread):

I'm planning a client workshop as part of an engagement focused on resilience. The way I want to frame it is not to consider risks as "done", but to look at risk scenarios. For each scenario (DDOS attack, server failure, botched deploy, etc.), understand things like what the impact is (downtime, lost data).

Then identify measures you can take in terms of outcomes. "When the database server fails, it can be manually restored in < 10 minutes, up to 5 minutes of transaction data may be lost."

This lets you create multiple outcomes for the same scenario, which can be prioritized. "When a single database server in the cluster fails, service is uninterrupted and no data is lost, and the server is automatically replaced and operational within 30 minutes"

These boil down to stories (multiple stories in most cases) that you can play to achieve concrete outcomes

And you can prioritize. When you have a stakeholder saying "we need 5 nines of availability", you can give them options, which you can estimate. "We can give you 5 nines, and it will take a dedicated team of 4 people 6-9 months to implement that. Or we can give you 4 nines with 2 months of work by a team of 2. Or ..."

I'm thinking we can have outcomes that describe things like monitoring, prevention, mitigation, and recovery. "When disc space on the logging server hits 80%, an alert is sent", or "... it is automatically expanded"

These should also be testable

Have tests in your pipeline which prove what happens when you destroy that database server, for example

Kind of like chaos engineering, although they don't need to be done in production.

Application focused ones can describe how the application behaves. "When the database becomes inaccessible, an error page is displayed, and user can still do X, Y, and X (which don't require the database)"

Then you can test those in the pipeline as well, giving you fast feedback if you break one of these expecations

Related to fitness functions, for operability concerns
