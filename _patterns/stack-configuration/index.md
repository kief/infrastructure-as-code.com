---
layout: pattern
title:  "Parameterized Stack"
date:   2019-01-01 16:20:00
categories: patterns
group_name: Stack configuration patterns
group_folder: stack-configuration
published: false
---

Defining an infrastructure stack as code enables the creation of multiple instances of the stack. This might be used as an [environment template](environment-template.adoc), to replicate a stack instance in multiple environments, or else as a [library stack](library-stack.adoc) that can be re-used for different things.

In the environment template scenario, each instance of the stack represents the same infrastructure, but is replicated in different environments. For example, you may have a product database stack with instances for the QA environment, Staging environment, and Production environment. Or you may have instances of the product database stack in different regions. The code is re-used for the same use case in each instance.

The library stack is different in that instances of the stack may be used for different purposes. A Postgres cluster stack definition may be used to create a stack instance for a product database, and another for a user database. In this case, the intention is to share code that is essentially similar, across different use cases.

Variations between instances of the stack are enabled by declaring parameters in the stack definition, and providing different values for these parameters as needed for each stack instance.

Environment template stacks have less variation, because inconsistency across environments creates risk. Testing that is carried out on a QA stack instance is more likely to fail to catch production issues if that instance is configured significantly differently from the production stack instance. The most common parameters for environment stacks are strings involved in naming (such as environment and location names), and sizing (such as minimum and maximum cluster sizes, and server instance sizes).

Library stacks may vary more, as systems and their infrastructure are configured and tuned for different purposes and use cases.

Parameterized stacks are related to [extensible stacks](extensible-stack.adoc). Instances of a parameterized stack can only be customized with simple variables, such as strings, numbers, and perhaps lists or hashes. An extensible stack, on the other hand, can be customized by adding further code. For example, an extensible stack definition for a postgres database cluster may include the code for a basic servers and storage, but need further code to define networking configuration to connect the database to application infrastructure for more specific use cases. (Better example??)

A parameterized stack is different from a [stack module](stack-module.adoc), which is code that can be imported into a stack definition, but which is not a complete stack in itself.

In order to create instances of a parameterized stack, a mechanism is needed to provide parameter values. Some options include [Environment Parameter Files](environment-parameter-files.adoc), [Pipeline-defined environment parameters](pipeline-defined-environment-parameters.adoc), and [Environment Parameter Registry](environment-parameter-registry.adoc).

Another approach is to define the stack as a module, and then use an [Environment Parameter Project](environment-parameter-project.adoc) to define parameter values for each instance.

