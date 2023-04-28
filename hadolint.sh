#!/bin/bash

docker pull hadolint/hadolint
docker run --rm -i hadolint/hadolint < Dockerfile