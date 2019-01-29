---
layout: pattern-group
title:  "Single Service Stack Pattern"
date:   2019-01-01 16:20:00
category: Stack Structural Patterns
order: 13
published: true
---

A Single Service Stack defines the infrastructure specific to a single application in its own
[infrastructure stack](/patterns/core-stack/).

Aligning the stack directly to the infrastructure for the one application or service means updates and other changes can be applied to it without directly affecting the infrastructure for other services. This is in contrast with a [multi-service stack](multi-service-stack.html), where the scope for a change may include infrastructure for other applications.

Limiting the scope for a change to one application reduces the scope of release coordination needed across applications and/or teams, which enables simplifying change management processes. These boundaries also help to keep code ownership clear, define the scope of testing, and make it easier to manage dependencies, keeping code decoupled.


## Related patterns

A single service stack might be a consumer stack, depending on infrastructure managed by a provider stack, as [will be] described in the [shared infrastructure stack pattern]. But nothing in the shared infrastructure is specific to the single service stack, so the provider stack should not need to be changed in order to change the consumer stack.

On the other side, a single service stack could be a provider, creating infrastructure used by one or more consumer stacks. In these cases, the contracts between provider and consumer should be clearly defined. This ensures that people working on the provider stack know which parts of the stack they can change independently, and which parts need more care and communication.

A [shared nothing stack] avoids this completely, by ensuring that the service stack has no inbound or outbound dependencies, giving it maximum latitude for independent changes.

