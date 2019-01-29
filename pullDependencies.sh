#!/bin/sh
set -e

docker build build/ -t po-jsonnet

docker run \
	--rm \
	-v `pwd`:`pwd` \
	--workdir `pwd` \
	po-jsonnet jb install github.com/coreos/prometheus-operator/contrib/kube-prometheus/jsonnet/kube-prometheus
