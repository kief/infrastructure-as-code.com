#!/bin/sh

set -eu

CHANGED_FILES=$(git status --porcelain _patterns/**/*.md | sed 's/...//')
DATESTAMP=$(date '+%Y-%m-%d %H:%M')
echo "DATE-TIME: ${DATESTAMP}"
echo "CHANGED FILES: ${CHANGED_FILES}"

perl -pi -e "s/^date:.*$/date: ${DATESTAMP}/" ${CHANGED_FILES}
