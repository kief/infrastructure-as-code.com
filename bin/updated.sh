#!/bin/sh

set -eu

# MARKDOWN_FILES=$(git diff --cached --name-status | perl -ne 'if ( /^[MA]\s*(\S+\.md)$/ ) { print "$1 " }')
MARKDOWN_FILES=$(find _patterns -type f -name '*.md')

for filename in ${MARKDOWN_FILES} ; do
  changetime=$(git log -1 --format="%ad" --date=iso -- ${filename})
  echo "${filename}: ${changetime}"
  perl -pi -e "s/^date:.*$/date: ${changetime}/" ${filename}
done
