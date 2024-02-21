# Building of Debian packages for AlternC

This repository contains a Travis script building Debian packages on AlternC and upload them to the [debian.alternc.org official repository](https://debian.alternc.org), either on [different Debian releases](https://www.debian.org/releases/), or on experimental (for nightly build)


## How to use

### User

As user, you can stop reading here and directly go to https://debian.alternc.org/
All explanations how to do download package to your server are provided at this place.

You can also download packages directly on GitHub release page on each subproject.

Of course, you're welcome to continue reading.


### Developer

This service provided an automatic Debian packages building. Purpose is to simplify process to diffuse up-to-date ecosystem package.
All git repositories present in AlternC organization with "alternc-" prefix are managed by this service.

All packages are pushed to [debian.alternc.org official repository](https://debian.alternc.org)
We consider two use case :
* nightly version
* stable version

### Experimental

We use **experimental** code-name suite as we don't follow Debian release process. It could be considered a mix between sid and unstable Debian release concept.

Packages build are pushed on this version follow last commit push on default branch (main or master).
These packages are available in ```deb https://debian.alternc.org/ experimental main```` repository.

Package versioning follow last git tag with date increment suffix.

In this repository you can find :
* package to test before to move to any existent (old*)stable release
* package to test to follow future stable Debian release

Use this repository is at your risk.

### Stable code-name

As we try to support at least two Debian releases, we don't use any more short code-name as **stable**, **oldstabe**.
We use only explicit code-name as defined at [Debian release page](https://wiki.debian.org/DebianReleases#Production_Releases) as **buster**, **bullseye**, **bookworm**, ...

To publish a stable package we need :
* update debian/changelog with a new version
* set all explicit compatible distributions (full code-name)
* tag commit with same version used on changelog file

Deb-builder will build a generic package and push this package on all related distribution repository set in change log.

## In depth

* A generic webhook catch all push on any git repository set in AlternC organization.
* This webhook verifies some elements as :
 * if event is asked from GitHub service
 * if repository is set in AlternC organization
 * if repository is an AlternC plugin, repository is prefixed by ```alternc-```
 * if data provided by GitHub are valid
 * if commit is related to default branch or is a tag
* If all check are ok, Travis is running
* Travis build package
 * git project is downloaded
 * if it's commit on default branch some changes are provided
   * changelog is set to be push in experimental
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