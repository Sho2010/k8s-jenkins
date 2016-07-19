#!/bin/bash

if [ -z ${GCP_PROJECT} ];then
  basename="jenkins-slave-ruby"
else
  basename="gcr.io/${GCP_PROJECT:-PLEASE_INPUT_YOUR_PROJECT}/jenkins-slave-ruby"
fi

version=${1:-2.3.1}

echo "Starting build ${basename}:${version}"
docker build --build-arg RUBY_VERSION="${version}" -t "${basename}:${version}" .
