#!/bin/bash -ex

pushd "$(dirname $0)"
SWD=$(pwd)
BWD=$(dirname "$SWD")
popd

. $SWD/setenv.sh

docker build ${DOCKER_BUILD_ARGS[*]} --rm -t "$DOCKER_REPO/$NAME:$VERSION" -t "$DOCKER_REPO/$NAME:latest" $BWD/docker

dockerImages=$(docker images "$NAME" -f "before=$DOCKER_REPO/$NAME:$VERSION" -q)
[ -n "$dockerImages" ] && docker rmi -f $dockerImages || true
