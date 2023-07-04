#!/bin/bash

# Get the name of the directory that was changed
dirs=$(git diff-tree --no-commit-id --name-only -r ${{ github.sha }} | awk -F/ 'BEGIN{OFS=FS} NF--')

# Check if there are any tags available
if [[ -z $(git tag -l) ]]; then
  has_tags=false
else
  has_tags=true
fi

# Update the tag format to include the name of the directory
APP_NAME=$(echo "$dirs" | awk '{print tolower($0)}')
tag_format="${APP_NAME}-v\${version}"

# Determine the path to the CHANGELOG.md file dynamically
changelog_path=""
while IFS= read -r dir; do
  if [[ -f "${dir}/CHANGELOG.md" ]]; then
    changelog_path="${dir}/CHANGELOG.md"
    break
  fi
done <<< "$dirs"

# Output variables
echo "::set-output name=dirs::$dirs"
echo "::set-output name=has_tags::$has_tags"
echo "::set-output name=tag_format::$tag_format"
echo "::set-output name=changelog_path::$changelog_path"
