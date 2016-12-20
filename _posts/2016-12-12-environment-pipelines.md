---
layout: post
title:  "Pipelines for Environments with Infrastructure as Code"
date:   2012-12-12 08:44:00
categories: book
published: false
---

Tools like Terraform, CloudFormation, and Heat are a great way to define server infrastructure for environments for deploying software. The configuration to provision, modify, and rebuild an environment is captured in a way that is transparent, reproducible, and testable. Used right, these tools give us confidence to tweak, change, and refactor our infrastructure easily and comfortably.

But as most of us discover after using the tools for a while, there are pitfalls. Any automation tool that makes it easy to roll a fix out across a sprawling infrastructure also makes it easy to roll a cock-up out across a sprawling infrastructure. Have you ever corrupted the /etc/hosts files on every server in your non-production estate, making it impossible to ssh into any of them - or to run the tool needed to fix the error? I have.

What we need is a way to make and test changes safely, before applying them to environments that you care about[1]. This is software delivery 101 - test new builds in a staging environment before deploying to live. But the best way to structure your infrastructure code to do this isn't necessarily obvious.

I'm going to describe a few different ways people do this:

- Put all of the environments into a single stack
- Define each environment in a separate stack
- Create a single stack definition and promote it through a pipeline

The nutshell on these is, the first way is bad. The second way work well for fairly simple setups (two or three environments, not many people working on them), and the third has more moving parts, but works well for larger and more complex groups.

Before diving in, here are a couple of definitions: I use the term "stack" (or "stack instance") to refer to a set of infrastructure that is defined and managed as a unit. This maps directly to an AWS CloudFormation stack, and also to the set of infrastructure corresponding to a Terraform state file. I also talk about a "stack definition" as a file, or set of files, used by a tool to create a stack. This may be a folder with a bunch of *.tf files for Terraform or CloudFormation template files.

I'll show some code examples using Terraform and AWS, but the concepts apply to pretty much any declarative, "Infrastructure as Code" tool, and any automated, dynamic infrastructure platform.

I'll also assume two environments - staging and production, for the sake of simplicity. Many teams end up with more environments - development, QA, UAT, performance testing, etc. - but again, the concepts are the same.


## One stack with all the environments

This is the most straightforward approach, and the one that most people start out using. All of the environments, from development to production, are defined in a single stack definition, and created an managed as a single stack instance.

The code example below shows a single Terraform configuration for both staging and production environments:


    # STAGING ENVIRONMENT

    resource "aws_vpc" "staging_vpc" {
      cidr_block = "10.0.0.0/16"
    }

    resource "aws_subnet" "staging_subnet" {
      vpc_id                  = "${aws_vpc.staging_vpc.id}"
      cidr_block              = "10.0.1.0/24"
    }

    resource "aws_security_group" "staging_access" {
      name        = "staging_access"
      vpc_id      = "${aws_vpc.staging_vpc.id}"
    }

    resource "aws_instance" "staging_server" {
      instance_type = "t2.micro"
      ami = "ami-ac772edf"
      vpc_security_group_ids = ["${aws_security_group.staging_access.id}"]
      subnet_id = "${aws_subnet.staging_subnet.id}"
    }


    # PRODUCTION ENVIRONMENT

    resource "aws_vpc" "production_vpc" {
      cidr_block = "10.0.0.0/16"
    }

    resource "aws_subnet" "production_subnet" {
      vpc_id                  = "${aws_vpc.production_vpc.id}"
      cidr_block              = "10.0.1.0/24"
    }

    resource "aws_security_group" "production_access" {
      name        = "production_access"
      vpc_id      = "${aws_vpc.production_vpc.id}"
    }

    resource "aws_instance" "production_server" {
      instance_type = "t2.micro"
      ami = "ami-ac772edf"
      vpc_security_group_ids = ["${aws_security_group.production_access.id}"]
      subnet_id = "${aws_subnet.production_subnet.id}"
    }


This is a simple approach that makes everything visible in one place, but it doesn't isolate the environments from one another. Making a change to the staging environment risks breaking production. And resources may leak or become confused across environments, making it even easier to accidentally affect an environment you don't mean to.


![Depiction of a single file defining multiple environments](/images/multiple-environments-multi-env-per-stack.png)


Charity Majors shared [problems she ran into with this approach](https://charity.wtf/2016/03/30/terraform-vpc-and-why-you-want-a-tfstate-file-per-env/) using Terraform. The _blast radius_ (great term!) of a change is everything included in the stack. And note that this is still true even without Terraform state files. Defining multiple environments in a single CloudFormation stack is asking for trouble.


## A Separate stack definition for each environment

Charity (and others) suggests splitting your environments into separate stack definitions. Each environment would have its own directory with its own Terraform configuration:

    ./our-project/staging/main.tf
    ./our-project/production/main.tf

These two different configurations should be identical, or nearly so. By running your infrastructure tool against each of these separately, you isolate the environments from one another (at least when it comes to using the tool, although obviously they may or may not be isolated in terms of networking, cloud account permissions, etc.) And because each environment has its own set of definition files, the intended state of each environment is very clear.


![Depiction of two files defining two environments](/images/multiple-environments-separate-stacks.png)


When you need to make a change, you edit the files for the staging environment stack, apply them, and test them. Iterate until it works like you want. Then make the same changes to the files for the production environment and apply them to the production stack instance.

A drawback with this approach is that it's easy for differences to creep into environments. Someone might be in a rush, and make a change to the production environment without testing it in staging first. Even if it works OK, they might forget to back-port their changes to the staging environment files. These differences have a way of accumulating to the point where people no longer trust that staging really looks like production. It should be possible to wipe out staging and copy the current production files to refresh staging, but this can get messy with larger teams and codebases.

So this pattern requires vigilance to keep the codebase consistent. This can be managed by using modules, sharing code across environments. But this adds versioning complexity. If someone makes a change to a module to test in staging, people must be careful to avoid the change being applied to production before it's ready. Modules can be extracted from the project codebase, and imported using versioning. But this adds more moving parts.


## One stack definition, promoted to create multiple instances in a pipeline

An alternative is to use a continuous delivery pipeline to promote a stack definition file across environments. Each environment has its own stack instance, so the blast radius for a change is contained to the environment. But a single stack definition is re-used to create and update each environment. The definition file is versioned, so we have visibility of what code was used for any environment, at any point in time.


![Depiction of a file being copied to provision multiple environments](/images/single-definition-multiple-environments.png)


The moving parts for implementing this are: a source repository, such as a git repository; an artefact repository; and a CI or CD server such as GoCD, Jenkins, etc.

A simple example workflow is:

1. Someone commits a change to the source repository.
2. The CD server detects the change and puts a copy of the definition files into the artefact repository, with a version number.
3. The CD server applies the definition version to the first environment, then runs automated tests to check it.
4. Someone triggers the CD server to apply the definition version to production.

![Depiction of a definition going through the basic workflow](/images/basic-pipeline-flow.png)


### Benefits

Teams I work with use pipelines for infrastructure for the same reasons that development teams use pipelines for their application code. It guarantees that every change has been applied to each environment, and that automated tests have passed. We know that all the environments are defined and created consistently.

With the previous "one stack definition per environment" approach, creating a new environment requires creating a new folder with its own copy of the files. These files then need to be maintained and kept up to date with changes made to other environments.

But the the pipeline approach is more flexible. New environment instances can be spun up on demand, which has a number of benefits:

- Developers can create their own sandbox instances, so they can deploy and test cloud-based applications, or work on changes to the environment definitions, without conflicting with other team members.
- Changes and deployments can be handled using a blue-green approach - create a new instance of the stack, test it, then swap traffic over and destroy the old instance.
- Testers, reviewers, and others can create environments as needed, tearing them down when they're not being used.


### Artefact repository, promotion, and versioning

The pipeline treats a stack definition as a versioned artefact, promoting it from one stage to the next. As per Continuous Delivery, an artefact is never changed. This is why a separate artefact repository is recommended, in addition to the version control repository. The version control is used to manage changes to the definition, the artefact repository is used to preserve immutable, versioned artefacts.

For stack definitions, I like using S3 bucket (or an equivalent) as a repository. I have a pipeline stage that "publishes" the definitions by creating a folder in the bucket with a version number in the name, and copying the files into it. This code is executed by a CI/CD server agent:


    aws s3 sync ./our-project/ s3://our-project-repository/1.0.123/


Promoting a version of a stack definition can be done in different ways. With the S3 bucket, I'll sometimes have a folder named for the environment, and copy the files for the relevant version into that folder. Again, this code runs from a CI/CD agent:


    aws s3 sync --delete s3://our-project-repository/1.0.123/ s3://our-project-repository/staging/


The pipeline stage for any environment simply runs Terraform (or CloudFormation), grabbing the definitions from the relevant folder.


### Running the tool

The commands are pretty much all run by the CI or CD server on an agent. This does a few good things. First, it ensures that the command is fully automated. There's no relying on "just one" manual step or tweak, which expands with "just one more, for now". You don't end up with different people doing things in their own way. You don't end up with undocumented steps. And you don't have to worry, in an emergency situation, that someone will forget that crucial step and bork the environment. If there's a step that can't easily be automated, then find a way.

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



[1](Note that production may not be the only environment you care about, especially if you're working with a team, or multiple teams. Killing a test environment may stop people from integrating and testing their code, which can make you unpopular.)



