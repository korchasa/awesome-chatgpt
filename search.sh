#!/usr/bin/env bash
date=$(date -v -3m '+%Y-%m-%d')
resp=$(http https://api.github.com/search/repositories\?q\=chatgpt+archived:false+pushed:\>$date\&sort\=stars\&order\=desc\&per_page\=100 | jq -r '.items[] | select(.stargazers_count > 30) | "- [" + .full_name + "](" + .html_url + ") - " + .description')
while read -r item; do
    id=$(echo ${item} | LC_ALL=C sed 's/.*\[\([^)]*\)\].*/\1/')
    if ! grep -q "${id}" ./README.md; then
        if ! grep -q "${id}" ./ignore; then
            echo ${item}
        fi
    fi
done <<< "${resp}"%