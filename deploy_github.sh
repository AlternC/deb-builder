#!/bin/bash -x

REPO_TO_BUILD=${1}
BRANCH_TO_BUILD=${2:-main}

if [ ! -d "$REPO_TO_BUILD" ]; then
    exit 1;
fi

cd "$REPO_TO_BUILD" || exit 1


DISTRIBUTIONS=$(dpkg-parsechangelog --show-field Distribution)
VERSION=$(dpkg-parsechangelog --show-field Version)
TITLE="Release ${VERSION}"
OPTIONS="--latest"

gh config set prompt disabled;

if [[ ${DISTRIBUTIONS} == "experimental" ]]; then
    VERSION="nightly"
    OPTIONS="--prerelease"
    TITLE="Automatic nightly build by Travis on $(date +'%F %T %Z')"

    gh release delete "${VERSION}" -R "${REPO_TO_BUILD}" --cleanup-tag -y
fi;

gh release create \
    "${VERSION}" \
    "${OPTIONS}" \
    --title "${TITLE}" \
    --target "${BRANCH_TO_BUILD}" \
    --repo "${REPO_TO_BUILD}" \
    ../*.deb