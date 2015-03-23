---
layout: post
title:  "Mechanical Sympathy and the Cloud"
date:   2015-03-23 14:20:00
categories: book
---

My former colleague Martin Thompson borrowed the term [Mechanical Sympathy](http://mechanical-sympathy.blogspot.co.uk/2011/07/why-mechanical-sympathy.html) from Formula One driver Jackie Stewart and brought it to IT. A successful driver like Stewart has an innate understanding of how his car works, so he can get the most out of it and avoid failures. For an IT professional, the deeper and stronger an understanding we have of how the system works down the stack and into the hardware, the more proficient we'll be at getting the most from it.

The history of computing has been a continuing process of adding new layers of abstraction. Operating systems, programming languages, and now virtualization have each helped us to be more productive by simplifying the way we interact with computer systems. We don't need to worry about which CPU register to store a particular value in, we don't need to think about how to allocate heap to different objects to avoid overlapping them, and we don't care which hardware server a particular virtual machine is running on.

Except when we do.

Hardware still lurks beneath our abstractions, and understanding what happens behind the facade of APIs and virtual CPU units is useful. It can help us to build systems that gracefully handle hardware failures, avoid hidden performance bottlenecks, and exploit potential sympathies - tweaks that make the software align with the underlying systems to work more reliably and effectively than naively written software would.


<img src="/images/virtualization-abstraction.png" alt="Hardware like CPUs and hard drives appear local to the VM, but may not be what they seem." title="A simplistic representation of abstractions in a VM"/>

For example, the Netflix team knew that a percentage of AWS instances, when provisioned, will perform much worse than the average instance, whether because of hardware issues or simply because they happen to be sharing hardware with someone else's poorly behaving systems. So they wrote their provisioning scripts to immediately test the performance of each new instance. If it doesn't meet their standards, the script destroys the instance and tries again with a new instance.

Understanding the typical memory and CPU capacity of the hardware servers used by your platform can help to size your VMs to get the most out of them. Some teams choose their AWS instance size to maximize their chances of getting a hardware server entirely to themselves, even when they don't need the full capacity.

Understanding storage options and networking is useful to ensure that disk reads and writes don't become a bottleneck. It's not a simple matter of choosing the fastest type of storage option available - selecting high performance local SSD drives may have implications for portability, cost, and even availability of resources.

This extends up and down the stack. Software and infrastructure should be architected, designed, and implemented with an understanding of the true architecture of the hardware, networking, storage, and the infrastructure management platform.

An infrastructure team should seek out and read through every whitepaper, article, conference talk and blog post they can find about the platform they're using. Bring in experts from your vendor to review your systems, from high level architecture down to implementation details. Be sure to ask questions about how your designs and implementation will work with their physical infrastructure.

If you're using virtualization infrastructure managed by your own organization then there's no excuse not to collaborate. Make sure your software and infrastructure are designed holistically, and continuously measured and modified to get the best performance and reliability possible.
