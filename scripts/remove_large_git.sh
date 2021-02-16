#!/bin/bash

set -e
readarray -t res <<< $(git rev-list --objects --all | git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' | awk '/^blob/ {print substr($0,6)}' | sort --numeric-sort --key=2 | cut --complement --characters=13-40 | numfmt --field=2 --to=iec-i --suffix=B --padding=7 --round=nearest | tac | awk '{print $3}' | egrep .bash_history)

echo $res

remove_file () {
    git filter-branch --force --index-filter \
      'git rm --cached --ignore-unmatch -- ' $1 \
      '--prune-empty --tag-name-filter cat -- --all'
}

for i in "${res[@]}"; do
    echo Removing $i
    remove_file $i
done
