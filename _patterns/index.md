---
layout: pattern-group
title:  "Introduction to Infrastructure Patterns"
date: 2019-02-13 09:09:39 +0000
published: true
permalink: /patterns.html
---

## What is this for?

This catalogue describes potentially useful approaches for designing infrastructure which is defined as code, and managed like software. Each pattern in the catalogue describes a recurring and useful solution, giving the context in which it may be useful, and some advice on implementation. The catalogue also includes antipatterns, which are approaches and strategies which seem useful, or which are in popular use, but which have drawbacks that make them less useful.

These solutions are written as [design patterns](https://www.martinfowler.com/articles/writingPatterns.html), each of which should be relevant to any cloud or virtualization platform, and to any toolchain which defines infrastructure as code. The examples tend to use Terraform code and AWS infrastructure, because these are widely understood. But the concepts and techniques should be usable with others.

The goal of naming and documenting these patterns is to have a vocabulary that we can use in teams, and in the industry, to talk about how to do things. Different people may have different opinions about the best way to solve a certain problem in a particular situation, but at least we should have a common frame of reference for a conversation.

This catalogue is a work in progress. There are many topics I'd like to cover here, which will need additional patterns and sections. And I am continuously getting feedback and new ideas which drive me to revisit things I've already written.


## The key parts of an infrastructure as code system

The patterns in this catalogue are based on a particular way of seeing the parts of an infrastructure, as shown in figure 1:


<figure>
  <img src="/patterns/images/stacks-and-servers.png" alt="The key parts of an infrastructure declared as code"/>
  <figcaption>Figure 1: The key parts of an infrastructure declared as code.</figcaption>
</figure>


## Dynamic Infrastructure Platform

The *Infrastructure Platform* is the foundation of the system. It provides a pool of resources including compute, networking, and storage, and makes those resources available to be provisioned to run services. Most platforms also provide higher level services composed of multiple resources. For example Databases as a Service (DBaaS) combine storage, compute, and networking.

Infrastructure as Code requires the infrastructure platform to be both programmatic and dynamic. That is, it should be possible to allocate resources from the platform using an API (programmatic), and on demand (dynamic).


<figure>
  <img src="/patterns/images/infrastructure-platform.png" alt="An infrastructure platform is a pool of resources that can be dynamically provisioned using an API"/>
  <figcaption>Figure 2: An infrastructure platform is a pool of resources that can be dynamically provisioned using an API.</figcaption>
</figure>


The most common platforms for infrastructure as code are IaaS (Infrastructure as a Service) clouds, such as AWS, Azure, GCP, OpenStack, or vCloud. However, virtualization platforms such as VMWare can also be managed as code. It's even possible to include physical hardware in a dynamic infrastructure platform, by using automated provisioning systems, for example with ILO, PXE, and Foreman.

> ### Core stack patterns
>
>{% assign pattern_categories = site.patterns | sort: 'order' | group_by: 'category' %}
>{% for category in pattern_categories %}
>  {% assign pattern_items = category.items | sort: 'order' %}
>  {% for item in pattern_items %}
>    {% if item.layout == "pattern" %}
>       {% if item.category == 'Core Stack Patterns' %}
> [{{ item.title }}]({{item.url}})
>       {% endif %}
>    {% endif %}
>  {% endfor %}
>{% endfor %}


## Infrastructure stacks

An *Infrastructure Stack* is a collection of infrastructure resources which are provisioned as a unit from an infrastructure platform. A stack may include compute resources such as servers, containers, or serverless code; networking structures like subnets and load balancers; and/or storage such as disk volumes and block storage. 


<figure>
  <img src="/patterns/images/stack.png" alt="An Infrastructure Stack is a collection of infrastructure resources which are provisioned as a unit from an infrastructure platform"/>
  <figcaption>Figure 3: An Infrastructure Stack is a collection of infrastructure resources which are provisioned as a unit from an infrastructure platform.</figcaption>
</figure>


With infrastructure as code, a stack is defined in source code. A stack project contains the source code for a single stack, although it may be used to provision multiple instances. A stack management tool is used to read the source code, and then interact with the API of the infrastructure platform to adjust the infrastructure to match what is declared in the source code.

Examples of stack management tools include [Hashicorp Terraform](https://www.terraform.io/), [AWS CloudFormation](https://aws.amazon.com/cloudformation/), [Azure Resource Manager Templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-overview), [Google Cloud Deployment Manager Templates](https://cloud.google.com/deployment-manager/) and [OpenStack Heat](https://wiki.openstack.org/wiki/Heat). Some toolchains designed to configure servers also have capabilities to manage stacks, for example [Ansible Cloud Modules](https://www.ansible.com/integrations/cloud), [Chef Provisioning](https://docs.chef.io/provisioning.html), [Puppet modules](https://forge.puppet.com/puppetlabs/aws/readme), and [Salt Cloud](https://docs.saltstack.com/en/latest/topics/cloud/).

[Infrastructure stacks](/patterns/stack-concept/) are a core concept in the patterns described in this catalogue.


## Server configuration

Configuring servers has traditionally been the main focus of infrastructure as code. This involves writing code that declares various aspects of a server's configuration, such as application packages that should be installed, user accounts that should exist, configuration files and their contents, etc. A server configuration tool is then used to read this code, and manipulate the server so that it matches what's declared in the code.

Examples of server configuration tools include Ansible, Chef, Puppet, and Saltstack.


<figure>
  <img src="/patterns/images/server.png" alt="A server configuration tool is used to read the configuration code and manipulate the server so that it matches what's declared in the code"/>
  <figcaption>Figure 4: A server configuration tool is used to read the configuration code and manipulate the server so that it matches what's declared in the code.</figcaption>
</figure>


Server configuration patterns is a broad topic. The patterns that will be documented here will be fairly high level, including provisioning patterns (push and pull), and patterns for updating servers. Patterns for using server images (e.g. AMIs) will also be covered.


## Applications

The purpose of computing infrastructure is almost always to run application software of some sort. Patterns for integrating applications with infrastructure will be covered in this catalogue as it evolves.

