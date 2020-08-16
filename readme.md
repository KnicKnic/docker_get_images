# Goal

Periodically pull my dockerhub images (Linux & Windows) so that they do not expire.

## Usage

Fork this branch, then add 2 secrets to your fork.

* DOCKER_HUB_PASSWORD
* DOCKER_HUB_USER


## Limitations

* first 100 repositories in your organization
* first 100 tags of each repository
* Only works for specific OS
    * Windows 2019
    * Linux
* Only works for certain architectures
    * amd64