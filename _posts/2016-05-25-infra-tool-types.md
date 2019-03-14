---
layout: post
title:  "Parts of an Infrastructure as Code platform"
date:   2016-05-25 08:45:00
categories: book
published: false
---

In order to build and run infrastructure as code, there are a number of pieces that need to be assembled into what could be called a platform for Infrastructure as Code. This means having services and tools in place that allow your team to specify your infrastructure in definition files, and push those files out to provision and update environments, after a bit of automated testing.


### Choosing capabilities for your platform

![Someone using the wrong tool](/images/lego-wrong-tool.jpg){: align="right" hspace="5" width="50%"}

It's best to think of these as a set of capabilities. Each of these capabilities may be provided in different ways: a service hosted by a vendor, a single tool, a set of tools assembled and configured by the team, or even an in-house tool or scripts.

Although it's tempting to look for the absolute best tool or service for each of these capabilities, this can lead to analysis paralysis. Teams spend weeks and months debating which tool to use, and never actually get started.

You can't possibly be certain whether a tool will work best for your team and situation until you start using it in anger. One thing you can be certain of: you will want to replace at least one tool sooner or later. So it's best to approach things with this reality in mind. Choose the tools which offer the simplest way to get moving. Then pay attention to what's working well and not working well as you go along, and be ready to test and swap replacements.


### Key platform capabilities for Infrastructure as Code

The following are capabilities that most teams will need when adopting Infrastructure as Code. This is by no means a comprehensive list. Teams will need the usual infrastructure services such as monitoring, backups, and package management (RPMs, .deb files, etc.). These are capabilities which may need to be added for teams moving to this way of working. In many cases, infrastructure teams may be able to leverage tools already being used by development teams.

- Version Control System
- Dynamic infrastructure platform
- Infrastructure definition
- Server configuration (if using configuration synchronization)
- CI or CD service
- Automated testing
- Server template building
- Configuration registry

Each of these is described in a bit more detail below.


#### Version Control System (VCS)

A VCS is a standard capability in most IT organizations, and many infrastructure teams probably already use one. Infrastructure as Code puts the VCS at the center, using it to drive provisioning and changes. The VCS provides traceability for changes, the ability to roll back changes that go wrong, correlation between changes to different parts of the infrastructure, visibility of what's been changed to everyone in the team, and the actionability to trigger automated tests and pipelines.


#### Dynamic infrastructure platform

My blog post [Dynamic Infrastructure Platforms](https://infrastructure-as-code.com/book/2016/05/20/infrastructure-platform.html) describes it as _"a system that provides computing resources, particularly servers, storage, and networking, in a way that they can be programmatically allocated and managed."_ In short, it provides a programmable API to provision and manage infrastructure resources.

The best known examples are public IaaS cloud providers like Amazon's AWS, Microsoft's Azure, Google's GCE, and Rackspace Cloud. But a dynamic, cloud-like platform can be built in a data center using products like OpenStack and vCloud. And in practice, it isn't necessary that the infrastructure platform be virtualized or shared. Many organizations, including DevOps paragons like [Etsy](https://codeascraft.com/2016/02/22/putting-the-dev-in-devops-bringing-software-engineering-to-operations-infrastructure-tooling/) and [Spotify](https://labs.spotify.com/2016/03/25/managing-machines-at-spotify/), implement Infrastructure as Code on bare metal. Tools such as Cobbler or Foreman can be used with ILO (Integrated Lights Out) hardware features to automatically provision physical servers.


#### Infrastructure definition

An infrastructure definition tool, such AWS Cloud Formation, Hashicorp's Terraform, or OpenStack Heat, allows people to specify what infrastructure resources they want to allocate and how they should be configured. They tend to wrap closely around the dynamic infrastructure platform's API, giving teams the ability to specify servers and networking constructs like firewall rules and load balancer VIPs in definition files. 

The tool takes these definition files as input, calling the platform's API to provision or modify the resources to match what's in the file.

This capability is core to Infrastructure as Code. A definition file can be used to ensure multiple environments are built consistently. It can be used to create a test environment, so that automated tests can validate whether it meets functional and non-functional requirements before applying it to production infrastructure. It also acts as a self-documenting specification, which is guaranteed to be up to date.


#### Server configuration

When using configuration synchronization rather than the immutable infrastructure model (as described in my blog post [Different models for updating servers](https://infrastructure-as-code.com/book/2016/05/24/models-for-server-updates.html)), your team will need a tool for configuring servers. The infrastructure definition tool described above specifies what servers to create, but the server configuration tool manages what goes inside the server.

User accounts, software packages, configuration files, etc. are defined and applied using a tool like Ansible, Chef, Puppet, or Saltstack. The infrastructure definition tool may pass parameters for these tools to use, such as the server's role and environment-specific information.

The server configuration tool will use configuration definitions to specify what goes on the server, for example Playbooks, Cookbooks, or Manifests. These should be stored in a VCS, but may be delivered to an agent for the server configuration tool running on the server. The definitions may be delivered through a tool-specific repository, such as Chef Server, PuppetDB, or Ansible Tower. Or they may be hosted on more general purpose services such as a file sharing service, like S3, a web server, or even packaged in a system package format like RPM or .deb.


![Assembly line](/images/toyota-assembly-line.jpg){: hspace="5"}


#### CI or CD service

One of the reasons to store configuration definitions for infrastructure and servers in a VCS is that it enables actions to be triggered every time a change is made. A Continuous Integration (CI) server like Jenkins or TeamCity or a Continuous Delivery server like GoCD can be configured to handle these changes.

These servers run automated tests to validate that the configuration is valid, correct, and compliant. Changes that pass the tests can be promoted to downstream environments, ultimately to production. This not only helps to prevent errors in production, it also provides transparency and can be used to enforce governance processes.


#### Automated testing

Getting into the habit of writing tests for infrastructure is a big change for most teams. I've devoted a full chapter of [my book](http://shop.oreilly.com/product/0636920039297.do) to testing because of its importance to Infrastructure as Code. Automated tests, done right, create the confidence needed to make changes and improvements to your infrastructure quickly and frequently. They make the difference between a change being a risky, high-pressure event, and being a routine activity.

Teams will typically use more than one testing tool, to handle multiple types and levels of testing. For example, a unit testing tool like [rspec-puppet](http://rspec-puppet.com/) or [ChefSpec](https://docs.chef.io/chefspec.html) can be used to test individual server definition files. A higher level tool like [Serverspec](http://serverspec.org/) can be used to test server roles and groups of infrastructure. Teams may use different tools to test security, performance, and stability.

It's critical that the infrastructure team is able to write its own tests. Having a separate testing team for software development creates bottlenecks, and also tends to result in a brittle test-suite that is overly focused on the front-end. Most dedicated testing teams will struggle to understand how to write tests for infrastructure.

Tests must be managed as code that can be checked into VCS, rather than kept inside a black-box, UI-driven test tool. The tool that executes tests needs to run in a headless, unattended mode so it can be automatically run from the CI/CD service.


#### Server template building

Many teams are able to use off-the-shelf server templates, such as AMIs from the AMI marketplace for AWS. But quite often teams want to create their own, customized server images to provision new servers from. They may want to add standard configuration, tools, and agents, such as monitoring agents.

They may also find that adding core elements, such as language runtimes and application servers, into the template rather than when building a server speeds up the time to provision new servers. This is particularly helpful when using auto-scaling and automated recovery of failed server instances.

Server template building capability is an essential enabler for immutable infrastructure for teams which use that model.

Netflix pioneered approaches for building server templates, open sourcing their [Aminator](https://github.com/Netflix/aminator) tool. They described their approach to using AMI templates in their blog post [AMI Creation with Aminator](http://techblog.netflix.com/2013/03/ami-creation-with-aminator.html). Aminator is fairly specific to Netflix's needs, limited to building CentOS/Redhat servers for the AWS cloud.

Hashicorp's [Packer](http://packer.io) tool has become the standard for building server templates across many cloud and virtualization platforms. Packer defines server templates using a file format that is designed following the principles of infrastructure as code. These files can be checked into VCS, and then automatically trigger stages to build and test templates, and even automatically roll them out to environments.


#### Configuration registry

A configuration registry is a directory of information about the elements of an infrastructure. It provides a way for scripts, tools, applications, and services to find the information they need in order to manage and integrate with infrastructure. This is especially useful with dynamic infrastructure because this information changes continuously as elements are added and removed.

For example, the registry could hold a list of the application servers in a load balanced pool. The infrastructure definition tool would add new servers to the registry when it creates them and remove them when the servers are destroyed. One tool might use this information to ensure the VIP configuration in the load balancer is up to date. Another might keep the monitoring server configuration up to date with the list of these servers.

There are different ways to implement a configuration registry. For simpler infrastructures, the configuration definition files used by the definition tool may be enough. When the tool is run, it has all of the information it needs within the configuration definitions. However, this doesn't scale very well. As the number of things managed by the definition files grows, having to apply them all at once can become a bottleneck for making changes.

There are many configuration registry products that can work with Infrastructure as Code, including [Zookeeper](https://zookeeper.apache.org/), [Consul](https://www.consul.io/), and [etcd](https://github.com/coreos/etcd). Many server configuration tool vendors provide their own configuration registry, for example, Chef Server, PuppetDB, and Ansible Tower. These products are designed to integrate easily with the configuration tool itself, and often with other elements such as a dashboard.


### The book

All of these topics are of course discussed in much greater detail in my book [Infrastructure as Code](http://shop.oreilly.com/product/0636920039297.do).

