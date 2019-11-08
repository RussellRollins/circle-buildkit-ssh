# circle-buildkit-ssh

This project illustrates how to use the new [experimental Docker BuildKit APIs](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/experimental.md) to build a project in CircleCI that relies on a private Go module.

This process allows you to more easily share a Dockerfile between local and CI configuration. It also lets you easily make use of the Docker build cache, if you have the `docker_layer_cache` feature enabled in CircleCI (this project does not).

## .circleci

Contains the CircleCI config and a modified `ssh_config` file used to utilize the private key in the build.

## hack

Contains some small scripts that make working with this Dockerfile a bit simpler. Namely: `run.sh`.

## circle-buildkit-private-dep

A mostly useless import. It just runs `fmt.Println("awesome")`. The import part is that it is private.

A Deploy Key was added to that repo, with the private key added to CircleCI configuration for this project.
