---
layout: post
title:  "Update to early access Infrastructure as Code book"
date:   2015-07-31 10:14:00
categories: book
---

O'Reilly has pushed the [latest update](http://shop.oreilly.com/product/0636920039297.do) to the "early access" (i.e. rough draft) of my book-in-progress, _Infrastructure as Code_. You can [buy the book now](http://shop.oreilly.com/product/0636920039297.do), getting access to the early access book, and you'll get the full electronic version of the final release. 

This release has three new chapters, and updates to some of the earlier chapters.

Chapter 8 discusses patterns and practices for making changes to servers. This chapter is closely tied to Chapter 3, server management tools, which I had released previously. The process of writing the new chapter led me to reshape the earlier one, in order to get the right balance of which topics belong in which chapter.

Basically, the chapters in Part I, including chapter 3, are intended to lay out how the different types of tools work. The chapters in Part II, including chapter 8, get more into patterns and practices for using the tools as part of an "infrastructure as code" approach.

Aside from improving the structure of the content, this revision to these two chapters clarified for me the idea of four "models" for server change management: ad-hoc changes, continuous synchronization, immutable servers, and containerization.

The other two new chapters in this release kick off Part III of the book, which gets more into the meat of software development practices that are relevant to infrastructure. Chapter 9 describes software engineering practices, drawing heavily on XP (eXtreme Programming) concepts like CI (Continuous Integration). It also discussed practical topics like effective use of VCS (Version Control Systems), including branching strategies, and maintaining code quality and avoiding technical debt.

Chapter 10 is about quality management. This includes obvious topics like TDD (Test Driven Development), but also goes into change management processes, such as CABs (Change Advisory Boards), and structuring work as stories. This is intended to take a higher level view of quality than simply writing automated tests. Automated tests are only one element of a larger strategy for managing changes to infrastructure in a way that helps teams make frequent, rapid changes, while avoiding errors and downtime.

One of the things I'm learning from the process of writing a full-length book is how interrelated the different parts of the book are. Writing new chapters forces me to re-evaluate what I've written previously, and re-think how it all fits together.

A key part of the process of improving the book as I write it is feedback from readers. I'm interested in hearing what people who are new to the ideas in this book think. Does the stuff the book says make sense? Is it relevant? Helpful? Confusing? I'm also interested in input from people who've already lived infrastructure as code. Do the principles and practices I've laid out resonate with you? Do you have different experiences? Are there topics I've missed out?


