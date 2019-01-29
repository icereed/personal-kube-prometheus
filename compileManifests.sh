#!/bin/sh
set -e

docker build build/ -t po-jsonnet

docker run \
	--rm \
	-v `pwd`:`pwd` \
	--workdir `pwd` \
	po-jsonnet ./build.sh kube-prometheus.jsonnet

