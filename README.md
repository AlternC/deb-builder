# Building of Debian packages for AlternC

This repository contains a Travis script building Debian packages on AlternC and upload them to the [debian.alternc.org official repository](https://debian.alternc.org), either on [different Debian releases](https://www.debian.org/releases/), or on experimental (for nightly build)


## How to use

### User

As a user, you can stop reading here and directly go to https://debian.alternc.org/
All explanations on how to do download the package for your server are provided there.

You can also download packages directly on the GitHub release page of each subproject.

### Developer

This service provides an automatic Debian packages building system. It's purpose is to simplify the process to produce up-to-date packages for the entire AlternC ecosystem.
All git repositories present in AlternC organization with "alternc-" prefix are managed by this service.

All packages are pushed to [debian.alternc.org official repository](https://debian.alternc.org)
We consider two use cases:
* nightly version
* stable version

### Experimental

We use **experimental** codename suite as we don't follow Debian release process. It could be considered a mix between sid and unstable Debian release concept.

The built packages pushed on this codename follows the last commit pushed on the default branch (main or master).
These packages are available in the repository ```deb https://debian.alternc.org/ experimental main````

The package version number follows the last git tag with a date increment suffix.

In this repository you can find :
* packages to test before to move to any existent (old*)stable release
* packages to test, to follow future stable Debian release

Use this repository at your own risk.

### Stable codename

As we try to support at least two Debian releases, we don't use any more short codenames such as **stable** or **oldstabe**.
We only use explicit codenames as defined in [the Debian release page](https://wiki.debian.org/DebianReleases#Production_Releases) such as **buster**, **bullseye**, **bookworm**, ...

To publish a stable package we need to:
* update debian/changelog with a new version
* set all explicitly compatible distributions (full codename)
* tag commit with same version used on changelog file

Deb-builder will build a generic package and push this package into all related distribution repository set in the changelog.

## In depth

(most of the code of this repository is in .travis.yml)

* A generic webhook catch all push on any git repository set in AlternC organization.
* This webhook verifies some elements such as:
 * if event is asked from GitHub service
 * if repository is set in AlternC organization
 * if repository is an AlternC plugin, repository is prefixed by ```alternc-```
 * if data provided by GitHub are valid
 * if commit is related to default branch or is a tag
* If all check are ok, Travis is running
* Travis build package
 * git project is downloaded
 * if its commit is on default branch some changes are added:
   * changelog is set to be pushed to experimental
   * version is generated from the latest tag and current time
 * package compression mode is forced to be compliant with all Debian distribution
 * package is build
 * package is signed
 * package is pushed on different compatible distribution set in changelog
 * package is pushed on GitHub release page
 * nightly tag is updated to be compliant with GitHub release page

 ## Travis behavior in each repository

With this process, each repository can have their own Travis rules. In this case rules must be related to check and quality code.
Any code relative to building and deployment must be absent. This part is integrally managed by this script.

