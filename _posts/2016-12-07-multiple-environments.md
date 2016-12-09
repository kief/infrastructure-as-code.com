---
layout: post
title:  "Managing multiple environments as code - Part 1"
date:   2016-12-05 14:21:00
published: false
---

How do you structure code to define multiple environments in a path to production? For example, if you have development, staging, and production environments:

- Should all of the environments be defined in a single Terraform file (or Cloud Formation template, or Heat template, or whatever)?
- Should each environment be defined in its own file?
- Or should a single file be used to create all of the environments in the path?

The Continuous Delivery (CD) approach to managing infrastructure, which is what I tend to advocate, uses a single template for multiple environments. But this isn't an obvious approach even for many experienced people.

I'll explain how the Continuous Delivery approach to managing infrastructure works in Part 2 of this article. But first I'll run through the first two options to help frame the problem.


> #### Terminology - "Infrastructure Stack"
>
> The question really isn't about files. With Terraform, CloudFormation, and similar tools, you can organize infrastructure definitions across multiple files, but work on it as a single unit. CloudFormation calls this a "stack", which is a convenient term, so I'll use it even when I'm talking about Terraform examples.
>
> Although I haven't seen Terraform use a consistent term for this kind of grouping, it's easily defined as the stuff that goes into a single [state file](https://www.terraform.io/docs/state/). If you run terraform in a directory with multiple configuration files, everything in those files is managed as a single unit, as is a CloudFormation stack.


### Antipattern: Multi-Environment Stack

With this pattern, multiple environments in a path to production are defined in a single stack. The code example below shows a single Terraform configuration for both staging and production environments:


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


Charity Majors shared [problems she ran into with this approach](https://charity.wtf/2016/03/30/terraform-vpc-and-why-you-want-a-tfstate-file-per-env/) using Terraform. The _blast radius_ (great term!) of a change is everything included in a stack. And note that this is still true even without Terraform state files, for example with a Cloud Formation template that defines multiple environments in the same way.


### Pattern: Stack Definition Per Environment

Charity (and others) suggests splitting your environments into separate stack definitions. Each environment would have its own directory with its own Terraform configuration:

    ./our-project/staging/main.tf
    ./our-project/production/main.tf

These two different configurations might look nearly identical. By running your infrastructure tool against each of these separately, you isolate the environments from one another (at least when it comes to using the tool, although obviously they may or may not be isolated in terms of networking, cloud account permissions, etc.) And because each environment has its own set of definition files, the intended state of each environment is very clear.


![Depiction of two files defining two environments](/images/multiple-environments-separate-stacks.png)


When you need to make a change, you make it in the staging environment first, and then apply and test it. Once you're happy it's OK, you make the same change in the production environment.

A drawback with this pattern is that it's easy for differences to creep into environments. Someone might be in a rush, and make a change to the production environment without trying it in staging first. They may or may not back-port their changes to staging. The differences should be visible in the files, but as the size and complexity of environments grows, along with the differences between them, reconciling the differences can become more difficult. If the differences become bad enough, you can't rely on systems to behave consistently in one environment to the next. It may be difficult to even understand how a given change should be made to both environments.

So this pattern requires vigilance to keep the codebase consistent. This can be managed by using modules, sharing code across environments. But this adds versioning complexity. If someone makes a change to a module to test in staging, people must be careful to avoid the change being applied to production before it's ready. Modules can be extracted from the project codebase, and imported using versioning. But this adds more moving parts.


### Next: Stack Instance Per Environment

[Part 2 of this article](/2016/12/06/cd-for-infrastructure.html) will describe the *Environment Pipeline* pattern. This uses a single definition file, which is versioned and promoted through a Continuous Delivery-style pipeline.


