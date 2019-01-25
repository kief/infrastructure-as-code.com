---
layout: pattern
title:  "Stack Orchestration Tools"
date:   2019-01-01 16:20:00
category: Stack Tools
order: 0
published: false
---

A stack orchestration tool is a tool, usually written by a team, that is used to run a stack management tool such as Terraform, CloudFormation, etc. These are usually written in order to manage configuration and parameters, and in some cases to marshal stack definition code.

Some typical scenarios:

- Manage multiple stacks as a group, e.g. spin up a database stack, and application server stack, and perhaps a separate networking stack. Manage the order each stack definition is applied.
- Configuration of stack instances. The orchestrator may read configuration files and use them to pass variables, or even read variables from a configuration registry. Dependency injection.
- Runtime / integration variables, eg. from other stacks.
- Grab library stack code and incorporate it.
- May also help with managing versioning of stack code.
- Run tests, smoke tests, etc.
- Orchestrate different tools. For example, apply terraform, then run ansible. May run command line tools to carry out actions that the stack tool can't do very nicely.

Pitfalls, this can become seriously complicated. Barrier for new people on a team. Very common for this stuff to be the most complicated and buggy part of an infrastructure codebase.

Typical implementations:
- Shell scripts
- Makefiles
- Ruby / rakefiles
- Python scripts

Also, third party orchestration tools. Terragrunt. Many CloudFormation tools.

