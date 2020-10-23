---
layout: post
title:  ""
date:   2099-01-01 16:20:20
categories: book
published: false
---

Atlantis, Terraform Cloud, [Spacelift](https://spacelift.io)

Most infra-only build servers, like terraform cloud and Atlantis, have several things I disagree with:

1) Doesn't support testing. Most only do"terraform plan". tf cloud also runs their own policy as code tool.

2) Siloed from application pipelines (can't use it to create ephemeral test env to test an application change, can't trigger application testing when infra code changes)

3) Doesn't promote project code across multiple environments. Supports the view of one project per environment instance (copy/paste environments).

