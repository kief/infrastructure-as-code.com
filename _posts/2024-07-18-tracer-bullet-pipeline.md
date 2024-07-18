---
layout: post
title:  "Tracer Bullet Pipeline"
date:   2024-07-18 0:56:00
categories: book
published: true
---

(Originally posted 26 November, 2012)


On my current project we're developing an essentially green field application, albeit one that integrates a fair bit of data managed in existing systems, in conjunction with the implementation of a new hosting infrastructure which will be used for other applications once it is established. We want to have a solid Continuous Delivery Pipeline to support the team developing the application, as well as to support the development and maintenance of the infrastructure platform.

In order to get the team moving quickly, we've kicked this all off using what we've called a "tracer bullet" (or "trail marker", for a less violent image). The idea is to get the simplest implementation of a pipeline in place, priortizing a fully working skeleton that stretches across the full path to production over a fully featured, final-design functionality for each stage of the pipeline.

![People hiking in the woods, with an orange blaze visible on a tree in the foreground](images/trail_marker.jpg)

Our goal is to get a "Hello World" application using our initial technology stack into a source code repository, and be able to push changes to it through the core stages of a pipeline into a placeholder production environment. This sets the stage for the design and implementation of the pipeline, infrastructure, and application itself to evolve in conjunction.

# Use cases

This tracer bullet approach is clearly useful in our situation, where the application and infrastructure are both new. But it's also very useful when starting a new application with an existing IT organization and infrastructure, since it forces everyone to come together at the start of the project to work out the process and tooling for the path to production, rather than leaving it until the end.

The tracer bullet is more difficult when creating a pipeline from scratch for an existing application and infrastructure. In these situations, both application and infrastructure may need considerable work in order to automate deployment, configuration, and testing. Even here, though, it's probably best to take each change made and apply it to the full length of the path to production, rather than wait until the end-all be-all system has been completely implemented.

# Goals

When planning and implementing the tracer bullet, we tried to keep three goals in mind as the priority for the exercise.

1. Get the team productive. We want the team to be routinely getting properly tested functionality into the application and in front of stakeholders for review as quickly as possible.
2. Prove the path to production. We want to understand the requirements, constraints, and challenges for getting our application live as early as possible. This means getting everyone involved in going live involved, and, using the same infrastructure, processes, and people that will be used for going live, so that issues are surfaced and addressed.
3. Put the skeleton in place. We want to have the bare bones of the application, infrastructure, and the delivery pipeline in place, so that we can evolve their design and implementation based on what we learn in actually using them.
4. Things can and should be made simple to start out with. Throughout the software development project changes are continuously pushed into production, multiple times every week, proving the process and identifying what needs to be added and improved. By the time the software is feature complete, there is little or no work needed to go live, other than DNS changes and publicizing the new software.

# "Do's" and "Do Not Do's"

## Do start as simply as you can

Don't implement things that aren't needed to get the simple, end to end pipeline in place. If you find yourself bogged down implementing some part of the tracer bullet pipeline, stop and ask yourself whether there's something simpler you can do, coming back to that harder part once things are running. On my current project we may need a clever unattended provisioning system to frequently rebuild environments according to the PhoenixServer pattern. However, there are a number of issues around managing private keys, IP addresses, and DNS entries which make this a potential yak shave, so for our tracer bullet we're just using the Chef knife-rackspace plugin.

## Don't take expensive shorcuts

The flip side of starting simply is not to take shortcuts which will cost you later. Each time you make a tradeoff in order to get the tracer bullet pipeline in place quickly, make sure it's a positive tradeoff. Keep track of those tasks you're leaving for later.

Examples of false tradeoffs are leaving out testing, basic security (e.g. leaving default vendor passwords in place), and repeatability of configuration and deployment. Often times these are things which actually make your work quicker and more assured - without automated testing, every change you make may introduce problems that will cost you days to track down later on.

It's also often the case that things which feel like they may be a lot of work are actually quite simple for a new project. For my current project, we could have manually created our pipeline environments, but decided to make sure every server can be torn down and rebuilt from scratch using Chef cookbooks. Since our environments are very simple - stock Ubuntu and a JDK install and we're good to go - this was actually more trivial than it would have been later on once we've got a more complicated platform in place.

## Don't worry too much about tool selection

Many organizations are in the habit of turning the selection of tools and technologies into complicated projects in their own right. This comes from a belief that once a tool is chosen, switching to something else will be very expensive. This is pretty clearly a self-fulfilling prophecy. Choose a reasonable set of tools to start with, ones that don't create major barriers to getting the pipeline in place, and be ready to switch them out as you learn about how they work in the context of your project.

## Do expect your design to change

Put your tracer bullet in place fully expecting that the choices you make for its architecture, technology, design, and workflow will all change. This doesn't just apply to the pipeline, but to the infrastructure and application as well. Whatever decisions you make up front will need to be evaluated once you've got working software that you can test and use. Taking the attitude that these early choices will change later lowers the stakes of making those decisions, which in turn makes changing them less fraught. It's a virtuous circle that encourges learning and adaptation.

## Don't relax the go-live constraints

It's tempting to make it easy to get pre-live releases into the production environment, waiting until launch is close to impose the tighter restictions required for "real" use. This is a bad idea. The sooner the real-world constraints are in place, the quicker the issues those constraints cause will become visible. Once these issues are visible, you can implement the systems, processes, and tooling to deal with those issues, ensuring that you can routinely and easily release software that is secure, compliant, and stable.

## Do involve everyone from the start

Another thing often left until the end is bringing in the people who will be involved in releasing and supporting the software. This is a mistake. In siloed organizations where software design and development is done by separate groups, the support people have deep insight into the requirements for making the operation and use of the software reliable and cost effective.

Involving them from the start and throughout the development process is the most effective way to build supportability into the software. When release time comes, handover becomes trivial because the support team have been supporting the application through its development.

Bringing release and support teams in just before release means their requirements are introduced when the project is nearly finished, which forces a choice between delaying the release in order to fix the issues, or else releasing software which is difficult and/or expensive to support.

# Doing what's right for the project and team

The question of what to include in the tracer bullet and what to build in once the project is up and running depends on the needs of the project and the knowledge of the team. On my current project, we found it easy to get a repeatable server build in place with chef configuration. But we did this with a number of shorcuts.

We're using the out of the box server templates from our cloud vendor (Rackspace), even though we'll probably want to roll our own eventually.
We started out using chef-solo (with knife-solo), even though we planned to use chef-server. This is largely due to knowledge - I've done a few smaller projects with knife-solo, and have some scripts and things ready to use, but haven't used chef-server. Now that we're migrating to chef-server I'm thinking it would have been wiser to start with the Opscode hosted chef-server. Moving from the hosted server to our own would have been easier than moving from solo to server.
Starting out with a tracer bullet approach to our pipeline has paid off. A week after starting development we have been able to demonstrate working code to our stakeholders. This in turn has made it easier to consider user testing, and perhaps even a beta release, far sooner than had originally been considered feasible.