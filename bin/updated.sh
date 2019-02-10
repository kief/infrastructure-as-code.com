#!/bin/sh

set -eu

UPDATED_MARKDOWN_FILES=$(git diff --cached --name-status | perl -ne 'if ( /^[MA]\s*(\S+\.md)$/ ) { print "$1 " }')

for filename in ${UPDATED_MARKDOWN_FILES} ; do
  changetime=$(git log -1 --format="%ad" --date=iso -- ${filename})
  echo "${filename}: ${changetime}"
  perl -pi -e "s/^date:.*$/date: ${changetime}/" ${filename}
done
