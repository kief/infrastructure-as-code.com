---
layout: full
title: Book
permalink: /book/
---

## Second edition out now!

<p>
The <a href="http://shop.oreilly.com/product/0636920294382.do">second edition of Infrastructure as Code</a> is out! Mostly. E-Books are available now 
  ([<a class="promolink"
    onclick="captureOutboundLink('amazon.com kindle');"
    href="https://www.amazon.com/Infrastructure-Code-Dynamic-Systems-Cloud-ebook/dp/B08Q35FM4B/?tag=kiefcom07-20"
    >Amazon.com</a>]
  [<a class="promolink"
    onclick="captureOutboundLink('amazon.co.uk kindle');"
    href="https://www.amazon.co.uk/Infrastructure-Code-Dynamic-Systems-Cloud-ebook/dp/B08Q35FM4B?tag=kiefcom07-20"
    >Amazon.co.uk</a>]
  [<a class="promolink"
    onclick="captureOutboundLink('amazon.in print');"
    href="https://www.amazon.in/Infrastructure-Code-Dynamic-Systems-Cloud-ebook/dp/B08Q35FM4B/?tag=kiefcom07-20"
    >Amazon.in</a>]
  [<a class="promolink"
    onclick="captureOutboundLink('safari');"
    href="https://www.oreilly.com/library/view/infrastructure-as-code/9781098114664/"
    >O'Reilly</a>]), while the dead-tree version is trundling across rails, roads, and sea lanes towards your local bookshop. I'm told to expect it out in January 2021.
</p>

<a href="http://shop.oreilly.com/product/0636920294382.do"><img
  class="showcase"
  title="Infrastructure as Code 2nd edition book cover"
  src="/images/infrastructure_as_code_2ed_small.png"
  alt="Book cover" width="320" height="420"
  /></a>

<p>
The benefits of infrastructure as code don't come from the tools themselves. They come from how you use them. The trick is to leverage the technology to embed quality, reliability, and compliance into the process of making changes.
</p>

<p>
I wrote the first edition of this book because I didn't see a cohesive collection of guidance on how to manage infrastructure as code. There was plenty of advice scattered across blog posts, conference talks, and documentation for products and projects. But you needed to sift through everything and piece a strategy together for yourself, and most people didn't have the time.
</p>

<p>
Things have moved along since the first edition came out in June 2016. That edition was subtitled "managing servers in the cloud," which reflected that most infrastructure automation until that point focused on configuring servers. Since then, containers and clusters have become a much bigger deal, and the infrastructure action has moved to managing collections of infrastructure resources provisioned from cloud platforms, what I (and many others) call _stacks_.
</p>

<p>
So the new edition talks a lot more about building stacks, the remit of tools like CloudFormation, Terraform, and Pulumi.
</p>

<p>
I've changed quite a bit based on what I've learned about the evolving challenges and needs of teams building infrastructure. As I've already touched on, I see making it safe and easy to change infrastructure as the key benefit of infrastructure as code. I believe people underestimate the importance of this, thinking that infrastructure is something you build and forget.
</p>

<p>
But too many teams I meet struggle to meet the needs of their organizations, not able to expand and scale quickly enough, support the pace of software delivery, or provide the reliability and security expected. And when we dig into the details of their challenges, it's that they are overwhelmed by the need to update, fix, and improve their systems. So I've doubled down on optimizing for change as the core theme of the second edition.
</p>

<p>
The new edition introduces three core practices for using Infrastructure as Code to make changes safely and easily. _Define everything as code_ is obvious from the name, and creates repeatability and consistency. _Continuously integrating, testing, and delivering_ each change enhances safety. It also makes it possible to move faster and with confidence. _Small, independent pieces_ are easier and safer to change than larger pieces.
</p>

<p>
These three practices are mutually reinforcing. Code is easy to track, version, deliver across stages of a change management process. It's easier to continuously test smaller pieces. Continuously testing each piece on its own forces you to keep a loosely coupled design.
</p>

<p>
These practices and the details of how to do them are familiar from the world of software development. I drew on agile software engineering and delivery practices for the first edition of the book. For the new edition I've also drawn on rules and practices for effective design.
</p>

<p>
In the past few years I've seen teams struggle with larger and more complicated infrastructure systems, and seen the benefits of applying lessons learned in software design patterns and principles. So I've included several chapters on how to do this.
</p>

<p>
I've also seen that organizing and working with infrastructure code is difficult for many teams, so I've addressed various pain points I've seen. How to keep codebases well organized, provide development and test instances for infrastructure, and manage collaboration of multiple people, including those responsible for governance.
</p>

