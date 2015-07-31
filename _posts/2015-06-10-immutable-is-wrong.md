---
layout: post
title:  "Immutable infrastructure ain't immutable"
date:   2015-06-10 16:20:00
categories: book
published: false
---

The term immutable infrastructure is a bit controversial. There are two issues. One is semantics - infrastructure, especially servers, can't really be immutable. So the name of the thing is just plain wrong. What's more interesting, and what came out of a debate on twitter a few weeks back, is that people don't really understand what the concept is.

Mark Burgess, the creator of CFEngine and the godfather of infrastructure as code, particularly dislikes the term. He kicked off a debate when he tweeted:

> Let's rename "immutable infrastructure" to "prefab/disposable" infrastructure, to decouple it from the false association with functionalprog"[https://twitter.com/markburgess_osl/status/600936792821477376]

I concede the point, infrastructure is not immutable. You can decide not to allow configuration changes on a server after it's built, but like it or not, stuff will change. Processes will start and stop, log files and data will be written, and various other things will happen which mean any given server instance is not the same thing it was when it was created. So that's a fact, call it an "immutable server", but it ain't really immutable.

But so far, the alternative names that have been suggested miss the point. This isn't just Mark, a number of people jumped onto the thread to suggest better names, and none of them really get the point of (not-really-)immutable infrastructure.

Let's start with "disposable". To me, disposability is a core factor with cloud infrastructure. This goes to the idea of servers as "cattle not pets". Any server, or any part of your infrastructure, may disappear at any time, whether it's because you or your tools have decided to, or just because of a failure in the underlying hardware or systems. So you need to design your infrastructure to assume that all of its components will come and go, and treat this as routine, not a disaster or incident.

So that's disposability. If you're not treating your infrastructure as disposable, you're doing cloud wrong. "Dynamic" infrastructure is pretty much the same point. Your systems and tooling - monitoring, for example - needs to handle infrastructure components being added and removed routinely. If you need to edit a configuration file and restart your monitoring server every time you add a new server, then you need to replace your monitoring server with something that understands that cloud means dynamic.

(Not-really-)immutable infrastructure _is_ disposable and dynamic. But it builds on the idea of disposability to do something a bit different. The core point of (not-true)immutability is that it's a way of making a change to infrastructure. The way to make a configuration change is to build a new server. This isn't required for disposable or dynamic infrastructure. In fact, the mainstream approach is to use an automated configuration tool like CFEngine, Ansible, Chef, Puppet, etc. to push changes out to existing servers. I tend to call this more common approach "continuous synchronization", because it brings servers into alignment by continuously applying the desired state.

So (not-actually-)immutable infrastructure is an option for managing dynamic, disposable infrastructure, but not the only way.

"Pre-fabricated" feels a little closer to the point, but still doesn't get it right. (So-called-)immutable infrastructure is built from cookie-cutter templates. "Pre-fabricated" captures the mechanics of this, but it misses the motivation. The reason for something being "pre-fabricated" is that it makes it easy and cheap to mass-produce. But (badly-named-)immutable infrastructure isn't a requirement to mass produce infrastructure. You can automatically build servers, and configure and update them using continuous synchronization, and get the same benefit.

"Immutable", as incorrect as it is, does capture the intent that people have when they decide to manage their infrastructure this way. Let me summarize what I believe this is:

> The strategy of making changes to an infrastructure element by rebuilding it, rather than by modifying it

The inaccuracy of "immutable" is that it implies that the infrastructure element's state is never modified. But what we're really talking about is only the server's configuration. With immutable infrastructure, a existing server's configuration is never changed, instead a new instance of the server is created with the new configuration.

I get that this use of immutable rubs some people the wrong way. And I'm unhappy that Mark, whose work has been the basis of my professional career, finds the term so objectionable. But the genie is out of the bottle. The term is becoming widely used, and I doubt a campaign to rebrand it will stamp it out. 

So I've resigned myself to having to explain what (the-confusingly-named)immutable infrastructure means in the context of infrastructure configuration.

Some references:

http://chadfowler.com/blog/2013/06/23/immutable-deployments/[Trash your servers and burn your code], by Chad Fowler
http://martinfowler.com/bliki/ImmutableServer.html[Immutable Servers], by me
https://highops.com/insights/immutable-infrastructure-6-questions-6-experts/[Immutable Infrastructure: 6 questions to 6 experts], a discussion organized and moderated by Marco Abis.




