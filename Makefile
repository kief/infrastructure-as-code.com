

preview:
	bundle exec jekyll serve --watch --unpublished

check:
	bundle exec jekyll serve --watch

build:
	bundle exec jekyll build

upload: build
	aws s3 sync \
	  --acl public-read \
	  --exact-timestamps \
	  --profile infrasite \
	  --delete \
	  --region eu-west-1 \
	  ./_site/ \
	  s3://infrastructure-as-code.com/

