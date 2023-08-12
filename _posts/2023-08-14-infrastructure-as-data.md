---
layout: post
title:  "Infrastructure as Data"
date:   2023-08-14 08:09:00
image:  
image_alt:  
categories: book
published: false
---

[Example Link](https://infrastructure-as-code.com)

_Infrastructure as Data_ is a subgenre of declarative infrastructure that leverages Kubernetes as a platform for orchestrating processes.footnote:[See https://cloud.google.com/blog/products/containers-kubernetes/understanding-configuration-as-data-in-kubernetes[I do declare! Infrastructure automation with Configuration as Data], by Kelsey Hightower and Mark Balch.] For example, https://aws-controllers-k8s.github.io/community/[ACK] (AWS Controllers for Kubernetes) exposes AWS resources as Custom Resources (CRs) in a Kubernetes cluster. This makes them available to standard services and tools in the cluster, such as the +kubetcl+ command-line tool, to provision and manage resources on the IaaS platform.

In addition to convenience, a benefit of integrating IaaS resource provisioning into the Kubernetes ecosystem is the ability to use capabilities like the control loop of the operator modelfootnote:[See https://kubernetes.io/docs/concepts/architecture/controller/]. Once infrastructure resources are defined in the cluster and provisioned on the IaaS platform, a controller loop ensures the provisioned resources remain synchronized with the definition.

Although some people consider infrastructure as data to be an alternative to Infrastructure as Code, in practice it's simply another implementation. A Kubernetes cluster with infrastructure resource CRDs embeds the functionality of an infrastructure tool like Terraform or AWS CDK. Infrastructure code is written and applied by loading it with +kubectl+ or another tool.

https://www.crossplane.io/[Crossplane] is an infrastructure as data product that adds the capability to define and provision Compositions, which are collections of resources managed as a unit: in other words, a stack.

Using Kubernetes to manage the process of applying infrastructure code can make the process less visible. Be sure to implement effective monitoring and logging so you can troubleshoot effectively.







Infrastructure as Data intergrates functionality to a Kubernetes cluster so that infrastructure code can be written and used within the Kubernetes ecosystem.
Thoughtworkers have successfully used ACK (AWS Controllers for Kubernetes), which presents AWS resources as custom resources in a Kubernetes cluster. Crossplane (previously blipped) adds the ability to define collections of infrastructure and present them as custom resources.
What's useful
Use Kubernetes tools like kubectl and Helm charts
Integrate infrastructure provisioning with application deployment workflows, so it can be provisioned and deprovisioned on demand
Use k8s built-in support for control loops, to ensure infrastructure is kept consistent with its definition.
Separate concerns of defining what infrastructure is needed from actually provisioning it
Limit permissions needed
Include logic in the provisioniong process for things like testing and governance
Caveats:
You need good observability to be able to troubleshoot it, because the infrastructure provisioning process is managed by Kubernetes
You should have mechanisms for stopping and troubleshooting the control loop.
Is it just GitOps for infrastructure?
No, unlike GitOps you don't point it at a code repository and synchronize from that. Although presumably you could combine the implementations, using a GitOps tool like ArgoCD plus ACK.
Is Terraform Cloud Operator an example of this?
No, Terraform Cloud Operator | Technology Radar | Thoughtworks integrates the capability to call out to Terraform cloud into a Kubernetes cluster. But Terraform cloud is an external service (hosted by Hashicorp) which manages and applies the Terraform code to your infrastructure. Infrastructure as Data embeds the capability to manage infrastructure resources into the k8s cluster itself.
Useful reference: Understanding Configuration as Data in Kubernetes, Kelsey Hightower and Mark Balch
(Mohamed Abbas, Thien-An Mac, and Reinaldo de Souza helped me to understand this stuff, especially the caveats)


