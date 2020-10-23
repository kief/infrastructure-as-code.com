---
layout: post
title:  "Infrastructure project shapes"
date:   2099-01-01 16:20:20
categories: book
published: false
---

[Example Link](https://infrastructure-as-code.com)

* It's a mistake to view new infra tools only as a way to write infrastructure code in a "real" programming language.


There are fundamental problems with the way most infrastructure projects are designed and written which won't be solved by swapping out "YAML with loops" with a language designed to be . Turning infrastructure code from configuration into software creates opportunities to shift the way we shape infrastructure projects, drawing on lessons on effective software design that have been learned over the past few decades of software development.



## Project shapes


* Low-level, static infra definition is mostly composed of primitives, and declares a stack of infrastructure that doesn't vary much. It might be a one-off stack, or you might re-use it to make multiple instances. But those instances are pretty much all the same, with some differences you configure with straightforward parameters. No loops, no conditionals. Expansions of things like Terraform subnets are probably OK, as long as the code is straightforward.
** Tests are simplistic. Essentially a smoke test, and potentially end to end tests. (I like to test a networking stack to make sure a connection can get through)
** Probably written by people with strong infrastructure skills, less development-oriented. They are defining the actual environments, as opposed to writing code for someone else.

* High-level infra definition is written at a higher level domain of infra. The server examples above, for instance. Might even be an application descriptor, which declares the infrastructure your application needs, and your libraries use it to either provision resources, or wire your stuff into existing resources. The language you use to write this is probably declarative. You should probably have a pretty static view of what infrastructure you want - a pool of application servers, a database cluster, wired into a pool of webservers. You might want some variation - how big are the app server pool and db clusters? But ideally these aren't configured using logic, just environment configuration values.
** Tests for these are also simplistic. Smoketest. Deploying and testing your application is probably the real test.
** Probably written by application teams, who are defining the actual environments they need.

* Libraries, abstraction layers. Written with dynamic code.
** Test the crap out of these, unit tests on up.
** Probably written by teams that include both development skills and infrastructure domain knowledge.


## Bespoke infra

One benefit of abstraction layers is they can embed good practices and design for security, stability, etc. 
The flip side of this is that they can be too limiting. A team may have requirements that vary from other teams - I've seen this with teams doing heavy ML, for example. So there is a need for application teams to be able to define some parts of their infrastructure themselves. Over time they probably write their own libraries to add into the abstraction layer.


## Pitfalls - PHP for infrastructure
