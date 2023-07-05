#!/bin/bash

# Get the name of the directory that was changed
dirs=$(git diff-tree --no-commit-id --name-only -r $GITHUB_SHA | awk -F/ 'BEGIN{OFS=FS} NF--' | cut -d/ -f1 | uniq)
echo "::set-output name=dirs::$dirs"

