#!/bin/bash -x

REPO_TO_BUILD=${1}
BRANCH_TO_BUILD=${2:-main}
FORCE_BUILD=${3:-false}

VERSION_DEFAULT="0.0.0"
DISTRIBUTION="stable"
VERSION_PACKAGE=""
export DEBFULLNAME="Travis Bot"
export DEBEMAIL="travis-ci@alternc.net"


if [ ! -d "$REPO_TO_BUILD" ]; then
    exit 1;
fi

cd "$REPO_TO_BUILD" || exit 1

#Move to branch and clear any local change
git reset --hard HEAD
git fetch --all
git checkout "${BRANCH_TO_BUILD}"

#Get current version package
VERSION_PACKAGE=$(dpkg-parsechangelog --show-field Version)

#Get current tag (only published version)
#If any tag set use a defautlt tag status
if [[ ${FORCE_BUILD} == false ]];then
    TAG_STATUS=$(git describe --tags || echo "${VERSION_DEFAULT}-0-g$(git rev-list --max-parents=0 HEAD)")
else
    TAG_STATUS=$(git describe --tags --exclude nightly || echo "${VERSION_DEFAULT}-0-g$(git rev-list --max-parents=0 HEAD)")
fi

#If tag status is TAG or TAG-COMMIT_COUNT-SHA1. Then if - is present, current checkout is not a tagged
if [[ "${TAG_STATUS}" =~ "-" ]]; then
    VERSION_PACKAGE="${VERSION_PACKAGE}+$(date +'%y%m%d%H%M%S')"
    DISTRIBUTION="experimental"
    (git rev-parse --git-dir > /dev/null 2>&1 && git checkout debian/changelog) || true
    (git rev-parse --git-dir > /dev/null 2>&1 && echo|dch --distribution "${DISTRIBUTION}" --force-bad-version --newversion "${VERSION_PACKAGE}" autobuild) || true
fi

#Force compression mode
mkdir -p debian/source/
printf "3.0 (native)" > debian/source/format
printf "compression = \"bzip2\"\ncompression-level = 9\n" >> debian/source/options

#Nightly packages are yet done, we must stop here
if [[ "${TAG_STATUS}" == "nightly" ]]; then
    exit 1
fi