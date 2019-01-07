.DEFAULT_GOAL := help

preview: bundle ## View unpublished
	bundle exec jekyll serve --watch --unpublished

check: bundle ## View published
	bundle exec jekyll serve --watch

build:
	bundle exec jekyll build

upload: build ## Publish to live
	aws s3 sync \
	  --acl public-read \
	  --exact-timestamps \
	  --profile infrasite \
	  --delete \
	  --region eu-west-1 \
	  ./_site/ \
	  s3://infrastructure-as-code.com/

bundle:
	bundle install

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
