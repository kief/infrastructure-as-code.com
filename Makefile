.DEFAULT_GOAL := help

preview: bundle ## View unpublished
	bundle exec jekyll serve --watch --unpublished

ready: bundle ## View ready to publish
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

linkcheck: ## Check links in the pattern catalogue
	mkdir -p tmp
	rm -f tmp/linkcheck.log
	wget --spider --accept-regex '\/patterns' -r -nv -l 3 -w 2 -p -P tmp/ --delete-after -nd -o tmp/linkcheck.log http://localhost:4000/patterns.html

full-linkcheck: ## Check links in the whole (local) site
	mkdir -p tmp
	rm -f tmp/linkcheck.log
	wget --spider -r -nv -l 5 -w 2 -p -P tmp/ --delete-after -nd -o tmp/linkcheck.log http://localhost:4000/

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
