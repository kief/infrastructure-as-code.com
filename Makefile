.DEFAULT_GOAL := help

preview: ## View unpublished
	jekyll serve --host=0.0.0.0 --watch --unpublished

plan: ## View ready to publish
	jekyll serve --host=0.0.0.0 --watch

apply: build ## Publish to new site
	aws s3 \
		--profile iac_site_uploader \
		--region us-east-1 \
		sync \
		--acl public-read \
		--exact-timestamps \
		--delete \
		./_site/ \
		s3://site.infrastructure-as-code.com/

ready: plan

upload: apply

up: apply

build:
	jekyll build

linkcheck: ## Check links in the pattern catalogue
	mkdir -p tmp
	rm -f tmp/linkcheck.log
	wget --spider --accept-regex '\/patterns' -r -nv -l 3 -w 2 -p -P tmp/ --delete-after -nd -o tmp/linkcheck.log http://localhost:4000/patterns/

full-linkcheck: ## Check links in the whole (local) site
	mkdir -p tmp
	rm -f tmp/linkcheck.log
	wget --spider -r -nv -l 5 -w 2 -p -P tmp/ --delete-after -nd -o tmp/linkcheck.log http://localhost:4000/

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
