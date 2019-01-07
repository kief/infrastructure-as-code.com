---
layout: pattern
title:  "Singleton Stack Antipattern"
date:   2019-01-01 16:20:00
categories: patterns
group_name: Core stack patterns
group_folder: core-stack
published: false
---

Copying code from one definition to the next to achieve the goals of the template stack. This makes it hard to keep each instance consistent. Tempting to make changes to a particular instance. This tends to snowball - because two instances are different, you make a change that works in one and not the other, and so need to make further tweaks that cause them to diverge. Configuration drift.

Even worse when you're doing this for multiple customers or services, because each change for one customer increases divergence. Often, we don't bother rolling out changes to customers who don't need it, because it's extra work and risk.
