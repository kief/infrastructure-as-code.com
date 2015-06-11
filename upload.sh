#!/bin/sh

jekyll build

aws s3 sync \
  --acl public-read \
  --exact-timestamps \
  --delete \
  ./_site/ \
  s3://infrastructure-as-code.com/
