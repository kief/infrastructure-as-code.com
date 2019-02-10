#!/bin/sh

set -eux

UPDATED_MARKDOWN_FILES=$(git diff --cached --name-status | perl -ne 'if ( /^[MA]\s*(\S+\.md)$/ ) { print "$1 " }' )
echo "UPDATED_MARKDOWN_FILES: ${UPDATED_MARKDOWN_FILES}"
NOW=$(date -u "+%Y-%m-%d %T %Z")
perl -pie 's/^updated:.*$/updated: ${NOW}/' ${UPDATED_MARKDOWN_FILES}
# sed -i "/---.*/,/---.*/s/^updated:.*$/updated: $(date -u "+%Y-%m-%d %T %Z")/" ${UPDATED_MARKDOWN_FILES}
# git add ${UPDATED_MARKDOWN_FILES}
