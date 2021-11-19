---
layout: post
title:  "The Snowflakes as Code antipattern"
date:   2021-11-19 13:30:00
categories: book
published: true
---

One of the earliest benefits that drew people like me to infrastructure as code was the promise of eliminating [snowflake servers](https://martinfowler.com/bliki/SnowflakeServer.html).

In the old times, we built servers by logging into them and running commands. We might build, update, fix, optimize, or otherwise change servers in different environments in different ways at different times. This led to [configuration drift](http://kief.com/configuration-drift.html), inconsistencies across environments.

Thanks to snowflakes and configuration drift, we spent huge amounts of effort to get an application build that worked fine in the development environment to deploy and run in production.

Flash forward 10+ years, infrastructure as code has become commonplace, helping us to manage [all kinds of stuff](https://infrastructure-as-code.com/book/2018/03/28/defining-stacks.html) in addition to, and often instead of, servers. You'd think snowflake infrastructure would be a thing of the past.

But it's actually quite common to see people following practices that lead to differences between environments - _snowflakes as code_.


## Antipattern: Snowflakes as code

Snowflakes as code is an antipattern where a separate instance of infrastructure code is maintained for each environment, although the environments are intended to run the same or similar workloads.


![Multiple environments, each with its own set of code](/images/snowflakes-as-code.png)


Each instance of code may have differences, even if very small differences. A change is made to the code for one environment, and then copied or merged with the code for the others. The process of copying code from one environment to the next is typically manual, and usually involves effort and care to ensure that deliberate differences between environments are maintained, while avoiding unintended differences.


## Motivation

Different environments, even ones intended to be consistent, will always need some variations between them. Resources like clusters and storage may be sized differently for a test environment than for production, for example. If nothing else, resources may need different names, such as _database-test_, _database-staging_, and _database-prod_.

Maintaining a separate copy of infrastructure code for each environment is an obvious way to handle these variations.


## Consequences

The issue with maintaining different versions of infrastructure code for each environment is that it encourages inconsistency - configuration drift. Once you accept editing code when copying or merging it between environments as a way to handle configuration, it becomes easy for larger differences to persist. For example:

* I make a fix to the production infrastructure, but don't have time to copy it back to upstream environments. The fix then clashes with changes you make in upstream environments.
* I'm working on a fairly complex change in the staging environment that drags on for days, or longer. Meanwhile, you need to make a small, quick fix and take it into production. Testing in staging becomes unreliable because it doesn't currently reflect production.
* We need to define security policies differently in production than for non-production environments. We implement this with different code in each environment, and hope nobody accidentally copies the wrong file to the wrong place.

Another consequence is the likelihood of making a mistake when copying or merging changes from one environment to the next. Don't forget to copy/replace every instance of *staging* to *prod*! Don't forget to change the maximum node count for the database cluster from *2* to *6*! Ooops!


## Implementation

The two main ways people implement snowflakes as code are folders and branches.


![Environment folders and environment branches](/images/snowflakes-folders-branches.png)


Teams who use branches to maintain infrastructure code for each of their environments (as described below under Implementation) often do this because they are using GitOps. GitOps uses tools that apply code from git branches to the infrastructure, so encourages maintaining a separate branch for each environment.

It's possible to use branches this way without them becoming snowflakes, as described below in Alternatives. But when your process for promoting code involves merging and tweaking code to maintain environment-specific differences, then you've got snowflakes as code.

Other teams use a folder structure to maintain separate projects for each environment. They copy and edit code between projects to make changes across environments. Again, it's the need to edit files when copying them to a new environment that signals this antipattern.


## Alternatives

The alternative to snowflakes as code is to treat infrastructure code as immutable as it moves from one environment to the next. This is Continuous Delivery 101 - only make changes in the origin (for example, trunk), then copy the code, unmodified, from one environment to the next.

Using an automated process to promote infrastructure code from one environment to the next reduces the opportunity for manual errors. It also removes the opportunity to "tweak" code to maintain differences across environments, forcing better discipline.

If the need for a change is discovered in a downstream environment, the change is first made to the origin, then progressed to the downstream environment without modifications. This ensures that every code change has been put through all of the tests and approvals needed.

As mentioned earlier, there usually is a need for some variations between environments, such as resource sizing and names. These variations should be extracted into per-environment configuration values, and passed to the code when it is applied to the given environment. Chapter 7 of [my book](/book/) covers different patterns for doing this, including configuration files and configuration registries.


![Separating infrastructure code and per-environment configuration](/images/non-snowflake-configuration.png)


Many teams follow the common development pipeline pattern of having a build stage that bundles the infrastructure code into a versioned artifact, storing it in a repository, and using that to ensure consistency of code from one environment to the next. A simple implementation of this pattern can be implemented using tarballs and centralized storage like an S3 bucket.

