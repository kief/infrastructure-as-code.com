---
layout: post
title:  "Infrastructure as Data"
date:   2023-08-12 08:09:00
categories: book
published: true
---

_Infrastructure as Data_ integrates declarative infrastructure management into a Kubernetes cluster, so you can write infrastructure code and use it with the Kubernetes ecosystem of tools and services.

[ACK](https://aws-controllers-k8s.github.io/community/) (AWS Controllers for Kubernetes) is a framework you can use to implementat Infrastructure as Data. It exposes AWS resources as Custom Resources (CRs) in a Kubernetes cluster. This makes them available to standard services and tools in the cluster, such as the `kubetcl` command-line tool, to provision and manage resources on the IaaS platform.

[Crossplane](https://www.crossplane.io/) is another Infrastructure as Data system. In addition to the ability to provision individual IaaS platform resources, Crossplane adds the capability to define and provision Compositions, which are collections of resources managed as a unit. In other words, an [infrastructure stack](https://infrastructure-as-code.com/book/2018/03/28/defining-stacks.html).

Although some people describe Infrastructure as Data to be an alternative to Infrastructure as Code, I'd characterize it as simply another implementation. A Kubernetes cluster with infrastructure resource CRDs leverages the Kubernetes ecosystem for infrastructure management and creates options to integrate infrastructure management with application management workflows.

One example of leveraging Kubernetes is using operators to implement [control loops](https://kubernetes.io/docs/concepts/architecture/controller/). Once you define infrastructure resources in your cluster and provision them on your IaaS platform, a controller ensures the provisioned resources remain synchronized with the definition.

A particularly interesting opportunity is aligning the configuration and provisioning of infrastructure resources very closely with the applications that use them. The descriptors and tools that you use to configure and deploy an application, like a Helm chart, can reference Custom Resources (CR) for infrastructure. This way, infrastructure is provisioned, and de-provisioned, on demand along with the applications that use it.

This application-driven infrastructure provisioning model is a favorite theme of mine. Infrastructure as Data supports this by creating a separation of concerns between defining and configuring the infrastructure needed for an application and its implementation and execution. You can create a standard implementation of, for example, a secure database instance, and expose it in the cluster as a CR. Someone configuring an application deployment can specify that the application needs one of these instances and set its parameters.

Permissions needed to provision the database instance are given to the operator that is triggered by the application deployment process but not given to the application deployer. This creates a much stronger separation of permissions than would be needed for the application deployment script to implement the database provisioning. And it removes the dependency that would be needed if a separate team needed to provision the database instance.

This is an example of an empowering approach to platforms. The application team has the control to configure the database instance they need, rather than relying on someone in a separate platform or infrastructure team who doesn't know the application's needs as well. A central team may ensure that the database CR is implemented well and in line with governance and compliance requirements, without needing to personally implement and configure every instance used in their organization.

See [I do declare! Infrastructure automation with Configuration as Data](https://cloud.google.com/blog/products/containers-kubernetes/understanding-configuration-as-data-in-kubernetes), by Kelsey Hightower and Mark Balch.

Thanks to Mohamed Abbas, Thien-An Mac, and Reinaldo de Souza for an informative conversation on the internal Thoughtworks infrastructure community chat group.


