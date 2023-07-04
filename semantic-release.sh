#!/bin/bash

# Get the name of the directory that was changed
dirs=$(git diff-tree --no-commit-id --name-only -r ${{ github.sha }} | awk -F/ 'BEGIN{OFS=FS} NF--')
echo "::set-output name=dirs::$dirs"

# Check if there are any tags available
if [[ -z $(git tag -l) ]]; then
  echo "::set-output name=has_tags::false"
else
  echo "::set-output name=has_tags::true"
fi

# Update the tag format to include the name of the directory
app_name=$(echo "$dirs" | awk '{print tolower($0)}')
echo "::set-output name=tag_format::${app_name}-v\${version}"

# Determine the path to the CHANGELOG.md file dynamically
app_dirs="$dirs"
path=""
while IFS= read -r dir; do
  if [[ -f "${dir}/CHANGELOG.md" ]]; then
    path="${dir}/CHANGELOG.md"
    break
  fi
done <<< "$app_dirs"

if [[ -n "$path" ]]; then
  echo "::set-output name=path::$path"
fi
