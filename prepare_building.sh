#!/bin/bash -x

REPO_TO_BUILD=${1}
BRANCH_TO_BUILD=${2:-main}

VERSION_DEFAULT="0.0.0"
export DISTRIBUTION="stable"
export DEBFULLNAME="Travis Bot"
export DEBEMAIL="travis-ci@alternc.net"
export VERSION_PACKAGE=""


if [ ! -d "$REPO_TO_BUILD" ]; then
    exit 1;
fi

cd "$REPO_TO_BUILD" || exit 1

#Move to branch
git checkout "${BRANCH_TO_BUILD}"

#Get current version package
VERSION_PACKAGE=$(dpkg-parsechangelog --show-field Version)

#Get current tag (only published version)
TAG_STATUS=$(git describe --tags)

#If tag status is TAG or TAG-COMMIT_COUNT-SHA1. Then if - is present, current checkout is not a tagged
if [[ "${TAG_STATUS}" =~ "-" ]]; then
    VERSION_PACKAGE="${VERSION_PACKAGE}+$(date +'%y%m%d%H%M%S')"
    DISTRIBUTION="experimental"
    (git rev-parse --git-dir > /dev/null 2>&1 && git checkout debian/changelog) || true
    (git rev-parse --git-dir > /dev/null 2>&1 && echo|dch --distribution "${DISTRIBUTION}" --force-bad-version --newversion "${VERSION_PACKAGE}" autobuild) || true
fi

#Nightly packages are yet done, we must stop here
if [[ "${TAG_STATUS}" =~ "nightly" ]]; then
    exit 1
fi