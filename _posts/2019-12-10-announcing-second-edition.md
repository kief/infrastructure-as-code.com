---
layout: post
title:  "Announcing, the second edition of Infrastructure as Code"
date:   2019-12-10 14:35:01
categories: book
published: true
---

TL;DR: Go read the early release of the [second edition of Infrastructure as Code](http://shop.oreilly.com/product/0636920294382.do) on O'Reilly! This is the first eight chapters of what will probably be eighteen or so.

![Cover of Infrastructure as Code 2nd edition](/images/iac_2nd_edition_tiny.gif)


Four years ago I was close to finishing my book _Infrastructure as Code_. I felt like I was racing against the industry's ability to innovate and improve infrastructure technology. At the time, the action was in server configuration - the book's subtitle was _Managing Servers in the Cloud_. Docker, Kubernetes, and AWS Lambda were still new, few people were using them in production.

Since we published the book, I'm often asked whether infrastructure as code is relevant in the cloud-native world of serverless and service mesh. You might not be shocked to hear me say, "yes." Even if you're no longer worried about configuring packages and file permissions on virtual servers, you're still better off using code to build your clusters and environments than building them by hand.

Looking over the first edition of the book takes me back to a different time. Most clients I worked with were building infrastructure on the cloud for the first time, and my [ThoughtWorks colleagues](https://www.thoughtworks.com/about-us) and I were introducing them to automation as code. There is a lot of text in the first edition to help you explain to your skittish management why they shouldn't fear public cloud.

The world now is different. The technical ecosystem is still in flux. But even the most risk adverse organizations - financial institutions, governments, healthcare organizations - are using public cloud to one degree or another. The question isn't whether to use cloud and infrastructure as code, but how.

My typical client today already has an existing infrastructure codebase. Their challenge is that their system has sprawled into a complex morass of code. Tools have come a long way, but reusing, sharing, and organizing code is still not easy. People write complicated build scripts that are actually more fragile and confusing than the infrastructure code they apply. And automated testing for infrastructure is still a challenge.

Enter the [second edition of Infrastructure as Code](http://shop.oreilly.com/product/0636920294382.do). What I first thought would be a gentle refresh has turned into an aggressive rewrite. Things are different, as I described above. But I've also spent a huge amount of time with many teams and people who are working with infrastructure projects. I've learned a lot since I wrote the first edition. I've learned about challenges, practices, and ideas for dealing with dynamic infrastructure. And I've learned better ways to communicate these.

So check out the early release, and please let me know what you think!

