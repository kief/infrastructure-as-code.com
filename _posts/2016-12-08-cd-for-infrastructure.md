---
layout: post
title:  "Managing multiple environments as code - Part 2"
date:   2016-12-06 16:20:00
published: false
---

In the [first part of this two-part article](/2016/12/05/multiple-environments.html) I raised the question, "How do you structure code to define multiple environments in a path to production?" This is in the context of defining and managing "stacks" using a tool like Terraform or CloudFormation.

I discussed two common patterns. One is the *Multi-Environment Stack* anti-pattern, where the environments are all managed in a single stack. The other is the *Stack Per Environment* pattern, where each environment is defined separately as its own stack.

In this post I'll describe the *Environment Pipeline* pattern. This uses a single stack definition to create multiple instances, one per environment. The definition - file or set of files - is versioned, and a Continuous Delivery pipeline is used to apply it to each environment through to production.


## Benefits

The environment pipeline pattern is used for the same reasons pipelines are used for application code. It ensures that environments are defined and created consistently. Changes are always tested and progressed through the path, creating confidence and avoiding configuration drift.

With the Stack Per Environment pattern, each environment instance needs its own set of definition files. But the pipeline pattern is more flexible. Environments can be spun up on demand, which has a number of benefits:

- Developers can create their own sandbox instances, so they can deploy and test cloud-based applications, or work on changes to the environment definitions, without conflicting with other team members.
- Changes and deployments can be handled using a blue-green approach - create a new instance of the stack, test it, then swap traffic over and destroy the old instance.
- Testers, reviewers, and others can create environments as needed, tearing them down when they're not being used.


## How it works

The basic idea is that a single definition (file or set of files) is used to create or update one environment, then copied to create the next environment, and so on to production.


![Depiction of a file being copied to provision multiple environments](/images/single-definition-multiple-environments.png)


The moving parts for implementing this are: a source repository, such as a git repository; an artefact repository; and a CI or CD server such as GoCD, Jenkins, etc.

A simple example workflow is:

1. Someone commits a change to the source repository.
2. The CD server detects the change and puts a copy of the definition files into the artefact repository, with a version number.
3. The CD server applies the definition version to the first environment, then runs automated tests to check it.
4. Someone triggers the CD server to apply the definition version to production.

![Depiction of a definition going through the basic workflow](/images/basic-pipeline-flow.png)


### Artefact repository, promotion, and versioning

The key to the pipeline is treating a stack definition as a versioned artefact, and promoting it from one stage to the next. As per Continuous Delivery, an artefact is never changed. This is why a separate artefact repository is recommended, in addition to the version control repository. The version control is used to manage changes to the definition, the artefact repository is used to preserve versioned artefacts.

For stack definitions, I like using S3 bucket (or an equivalent) as a repository. I have a CD stage that "publishes" the definitions by creating a folder in the bucket with a version number in the name, and copying the files into it:


    aws s3 sync ./our-project/ s3://our-project-repository/1.0.123/


Promoting a version of a stack definition can be done in different ways. With the S3 bucket, I'll sometimes have a folder named for the environment, and copy the files for the relevant version into that folder:


    aws s3 sync --delete s3://our-project-repository/1.0.123/ s3://our-project-repository/staging/


The pipeline stage for any environment simply runs Terraform (or CloudFormation), grabbing the definitions from the relevant folder.


### Running the tool

The commands are pretty much all run by the CI or CD server. This does a few good things. First, it ensures that the command is fully automated. There's no relying on "just one" manual step or tweak, which expands with "just one more, for now". You don't end up with different people doing things in their own way. You don't end up with undocumented steps. And you don't have to worry, in an emergency situation, that someone will forget that crucial step and bork the environment. If there's a step that can't easily be automated, then find a way.

Another good thing is that you don't worry about different people applying changes to the same environment. Nobody applies changes to a common environment by running the tool from their own machine. No need to worry about locking and unlocking. No need to worry about locally edited changes. The only changes made to an environment you care about are the ones that have been fed into the pipeline.

This also helps with consistency. Nobody can make a change that requires a special plugin or utility they've installed on their own laptop. There is no tweak that someone made when applying a change to staging, that might be forgotten for production. The tool is always run from a CD agent, which is built and configured consistently, always using the same script, no matter which environment it runs from.


### Developer workflow

People working on the infrastructure probably need to make and test changes to stack definitions rapidly, before committing into the pipeline. This is the one place you may want to run the tool locally. But when you do, you're doing it with your own instance of the environment stack. Pull the latest copy of the definitions from the source repo, run the tool to create the environment, then start making changes. (Write some automated tests, of course, which should also be in the source repo and automatically run in relevant environments in the pipeline.)

When you're happy, make sure you've pulled the latest updates from master, and that your tests pass. Then commit the changes and destroy your environment.

No need to worry about breaking a common environment like staging. If someone else is working on changes that might conflict with yours, you should see them when you pull from master. If the changes merge OK, but cause issues, they should be caught in the first test environment in the pipeline. The build goes red, everyone stops and looks to see what needs to be done to fix it.


### When is this appropriate?

I've been using the pipeline approach for environments for years. When I started talking about it at conferences, I was surprised to discover that it's not a familiar pattern even for many people with plenty of experience with infrastructure as code. I realize that the reason it's second nature to me is because ThoughtWorks teams use this approach by default for delivering software. It just seemed like the obvious thing to do it with infrastructure, too.

Other approaches work well for other people. The pipeline approach has more moving parts than simply having a stack definition for each environment. For smaller teams, with a straightforward release process, a pipeline may be overkill. But as you have more people working on a system, and especially multiple teams and roles, a pipeline is useful for ensuring a consistent process for rolling out infrastructure changes. It may make sense even for smaller teams which are already using a pipeline to deliver software changes.

There are some caveats. It takes time to get used to making infrastructure changes through a pipeline. You may not get as much value without at least some degree of automated testing, which is another discipline to build. Running infrastructure management tools automatically from a CD server agent requires a secure approach to managing secrets, to avoid your automation system from becoming an easy attack vector.

I hope this piece helps people to understand how pipelines can be useful for infrastructure management.

