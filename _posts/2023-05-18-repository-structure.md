---
layout: post
title:  "Structuring code repositories"
date:   2023-05-18 10:10:10
categories: book
published: true
---

Given that you have multiple code projects, should you put them all in a single repository in your source control system, or spread them among more than one? If you use more than one repository, should every project have its own repository, or should you group some projects together into shared repositories? If you arrange multiple projects into repositories, how should you decide which ones to group and which ones to separate?

There are some trade-off factors to consider:

* Separating projects into different repositories makes it easier to maintain boundaries at the code level.
* Having multiple teams working on code in a single repository can add overhead and create conflicts.
* Spreading code across multiple repositories can complicate working on changes that cross them.
* Code kept in the same repository is versioned and can be branched together, which simplifies some project integration and delivery strategies.
* Different source code management systems (such as Git, Perforce, and Mercurial) have different performance and scalability characteristics and features to support complex scenarios.

Let's look at the main options for organizing projects across repositories in light of these factors.


## One Repository for Everything

Some teams, and even some larger organizations, maintain a single repository with all of their code. This requires source control system software that can scale to your usage level. Some software struggles to handle a codebase as it grows in size, history, number of users, and activity level. So splitting repositories becomes a matter of managing performance.

Facebook, Google, and Microsoft all use very large repositories. All three have either made custom changes to their version control software or built their own. See [Scaling version control software](https://oreil.ly/2KBk8) for more. Also see ["Scaled trunk-based development"](https://oreil.ly/Dc21t) by Paul Hammant for insight on the history of Google's approach.

A single repository can be easier to use. People can check out all of the projects they need to work on, guaranteeing they have a consistent version of everything. Some version control software offers features, like sparse-checkout, which let a user work with a subset of the repository.


### Monorepo: One Repository, One Build

A single repository works well to integrate dependencies across projects at build-time. So the monorepo strategy uses build-time integration for projects maintained in a single repository. A simplistic version of monorepo builds all of the projects in the repository:


![Building all projects in a repository](/images/repos-monorepo-builds.png)


Although the projects are built together, they may produce multiple artifacts, such as application packages, infrastructure stacks, and server images.


### One repository, multiple builds

Most organizations that keep all of their projects in a single repository don't necessarily run a single build across them all. They often have a few different builds to build different subsets of their system:


![Building different combinations of projects from one repository](/images/repos-one-repo-multiple-builds.png)


Often, these builds will share some projects. For instance, two different builds may use the same shared library:


![Sharing a component across builds in a single repository](/images/repos-shared-library.png)


One pitfall of managing multiple projects this way is that it can blur the boundaries between projects. People may write code for one project that refers directly to files in another project in the repository. Doing this leads to tighter coupling and less visibility of dependencies. Over time, projects become tangled and hard to maintain, because a change to a file in one project can have unexpected conflicts with other projects.


## A Separate Repository for Each Project (Microrepo)

Having a separate repository for each project is the other extreme:


![Each project in a separate repository](/images/repos-microrepos.png)


This strategy ensures a clean separation between projects, especially when you have a pipeline that builds and tests each project separately before integrating them. If someone checks out two projects and makes a change to files across projects, the pipeline will fail, exposing the problem.

Technically, you could use build-time integration across projects managed in separate repositories, by first checking out all of the builds:


![A single build across multiple repositories](/images/repos-one-build-multiple-repos.png)


But it's more practical to build across multiple projects in a single repository because then their code is versioned together. Pushing changes for a single build to multiple repositories complicates the delivery process. The delivery stage would need some way to know which versions of all of the involved repositories to check out to create a consistent build.

Single-project repositories work best when supporting delivery-time and apply-time integration. A change to any one repository triggers the delivery process for its project, bringing it together with other projects later in the flow.


## Multiple Repositories with Multiple Projects

While some organizations push toward one extreme or the other — single repository for everything, or a separate repository for each project — most maintain multiple repositories with more than one project:


![Multiple repositories with multiple projects](/images/repos-mult-repos-multi-projects.png)


Often, the grouping of projects into repositories happens organically, rather than being driven by a strategy like monorepo or microrepo. However, there are a few factors that influence how smoothly things work.

One factor, as seen in the discussions of the other repository strategies, is the alignment of a project grouping with its build and delivery strategy. Keep projects in a single repository when they are closely related, especially when you integrate the projects at build time. Consider separating projects into separate repositories when their delivery paths aren't tightly integrated.

Another factor is team ownership. Although multiple people and teams can work on different projects in the same repository, it can be distracting. Changelogs intermingle commit history from different teams with unrelated workstreams. Some [.keep-together]#organizations# restrict access to code. Access control for source control systems is often managed by the repository, which is another driver for deciding which projects go where.

As mentioned for single repositories, projects within a repository more easily become tangled together with file dependencies. So teams might divide projects between repositories based on where they need stronger boundaries from an architectural and design perspective.
