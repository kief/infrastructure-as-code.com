---
layout: post
title:  "Term: Infrastructure Stack"
date:   2018-03-28 09:01:01
categories: book
published: true
---

The term _Infrastructure Stack_ is something I've found useful to explain different patterns for organizing infrastructure code. An infrastructure stack is a collection of infrastructure elements defined and changed as a unit. Stacks are typically managed by tools such as [Hashicorp Terraform](https://www.terraform.io/), [AWS CloudFormation](https://aws.amazon.com/cloudformation/), [Azure Resource Manager Templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview), [Google Cloud Deployment Manager Templates](https://cloud.google.com/deployment-manager/) and [OpenStack Heat](https://wiki.openstack.org/wiki/Heat).

![An infrastructure stack is a collection of infrastructure elements managed as a unit](/images/infrastructure-stack.png)

AWS CloudFormation uses the term "[stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/stacks.html)" formally, but it maps to other tools as well. When using Terraform, which I tend to use for code examples, a stack correlates to a Terraform project, and a statefile.


## Stack definitions

A stack definition is the code that declares what a stack should be. It is a Terraform project, CloudFormation template, and so on. A stack definition may use shared infrastructure code - for example, [CloudFormation nested stacks](https://aws.amazon.com/blogs/devops/use-nested-stacks-to-create-reusable-templates-and-support-role-specialization/) or [Terraform modules](https://www.terraform.io/docs/modules/index.html).

![A stack definition is code used to provision stack instances](/images/stack-definition.png)

Below is an example stack definition, a Terraform project:


~~~ console
stack-definition/
   ├── src/
   │   ├── backend.tf
   │   ├── bastion.tf
   │   ├── dns.tf
   │   ├── load_balancers.tf
   │   ├── networking.tf
   │   ├── outputs.tf
   │   ├── provider.tf
   │   ├── variables.tf
   │   └── webserver.tf
   └── test/
~~~


This stack is part of my [standalone service stack template](https://github.com/kief/spin-template-standalone-service) project in github.


## Stack instances

A stack definition can be used to provision, and update, one or more stack instances. This is an important point, because many people tend to use a separate stack definition for each of their stack instances - what I called __Separate stack definition for each environment__ in my post on [environment pipelines](http://infrastructure-as-code.com/book/2017/08/02/environment-pipeline.html).

But as I explained in that post, this approach gets messy when you grow beyond very simple setups, particularly for teams. I prefer to use a single, parameterized stack definition template, to provision multiple environment instances.


![Multiple stack instances can be provisioned from a single stack definition](/images/stack-instances.png)


A properly implemented stack definition can be used to create multiple stack instances. This helps to keep multiple environments configured consistently, without having to copy code between projects, with potential for mistakes and mess. [Nicki Watt](https://twitter.com/techiewatt) has a great talk on [Evolving Your Infrastructure with Terraform](https://www.youtube.com/watch?v=wgzgVm7Sqlk) which very clearly explains these concepts (and more).

Another benefit of parameterized stacks is that you can very easily create ad-hoc environments. Developers working on infrastructure code locally can spin up their own stack instances by running Terraform with appropriate parameters. Environments can be spun up on demand for testing, demos, showcases, etc., without creating bottlenecks or "freezing" environments. I never want to hear, "nobody touch QA for the next 3 days, we're getting ready for a big presentation!"


## A note on state

One of the pain points of using Terraform is dealing with [statefiles](https://www.terraform.io/docs/state/). All stack management tools, including CloudFormation, etc., maintain data structures that reflect which infrastructure elements belong to a given stack instance. 


![Stack state](/images/stack-state.png)


CloudFormation and similar tools provided by cloud platform vendors have the advantage of being able to manage instance state transparently - they keep these data structures on their servers. Terraform and other third party tools need to do this themselves.

Arguably, the explicit state management of Terraform gives you more control and transparency. When your CloudFormation stack gets wedged, you can't examine the state data structures to see what's happening. And you (and third parties) have the option of writing tools that use the state data for various purposes. But it does require you to put a bit more work into keeping track of statefiles and making sure they're available when running the stack management tool.


## Example of parameterized infrastructure

I have an example of a [parameterized infrastructure stack project](https://github.com/kief/spin-template-standalone-service) on github, using Terraform and AWS. Below is a (trimmed) snippet of code for a webserver. 


~~~
resource "aws_instance" "webserver" {
  ...
  tags {
    Name                  = "webserver-${var.service}-${var.component}-${var.deployment_id}"
    DeploymentIdentifier  = "${var.deployment_id}"
    Service               = "${var.service}"
    Component             = "${var.component}"
  }
}
~~~

This shows how it a number of variables are used to set tags, including a Name tag, to distinguish this server instance from other instances of the same server in other stack instances.

These variables are passed to the terraform command by a Makefile:


~~~
TERRAFORM_VARS=\
  -var "deployment_id=$(DEPLOYMENT_ID)" \
  -var "component=$(COMPONENT)" \
  -var "service=$(SERVICE)"

up: init ## Create or update the stack
  terraform apply $(TERRAFORM_VARS) -auto-approve
~~~


The `SERVICE` and `COMPONENT` variables are set by a file in the stack definition project, and are always the same. The `DEPLOYMENT_ID` variable is passed to the Makefile when make is run. The pipeline stage configuration sets this, so for example, the production stage configuration (using AWS CodeBuild in this case) includes the following:


~~~
resource "aws_codebuild_project" "prodapply-project" {
  name = "${var.service}-${var.component}-${var.estate_id}-ApplyToProdEnvironment"
  ...

  environment {
    environment_variable {
      "name"  = "DEPLOYMENT_ID"
      "value" = "prod"
    }
  }
~~~

The codebuild project simply runs `make up`, and our stack definition creates our webserver instance accordingly.


## There's more

The examples I've given imply each environment is a single stack. In practice, as environments grow, it's useful to split them into multiple, independently managed stacks. I'll elaborate on this in future posts.

