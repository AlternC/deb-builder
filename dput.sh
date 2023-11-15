#!/bin/bash -x

REPO_TO_BUILD=${1}

if [ ! -d "$REPO_TO_BUILD" ]; then
    return 1;
fi

cd "$REPO_TO_BUILD" || return 1

DISTRIBUTIONS=$(dpkg-parsechangelog --show-field Distribution)

for distribution in $DISTRIBUTIONS; do 
    dput "$distribution" ../*.changes
done