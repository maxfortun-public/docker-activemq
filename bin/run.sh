#!/bin/bash -ex

pushd "$(dirname $0)"
SWD=$(pwd)
PATH="$PATH:$SWD"
BWD=$(dirname "$SWD")
HOST_MNT=${HOST_MNT:-$BWD/mnt}
GUEST_MNT=${GUEST_MNT:-$BWD/mnt}

# Let's make sure jq is available
! which jq >/dev/null && curl -o $SWD/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-osx-amd64 && chmod a+x $SWD/jq

. $SWD/setenv.sh

RUN_IMAGE="$DOCKER_REPO/$NAME"

DOCKER_RUN_ARGS=( -e container=docker )
DOCKER_RUN_ARGS+=( -v /etc/resolv.conf:/etc/resolv.conf:ro )
DOCKER_RUN_ARGS+=( --add-host host.docker.internal:host-gateway )

# Publish exposed ports
imageId=$(docker images --format="{{.Repository}} {{.ID}}"|grep "^$RUN_IMAGE "|awk '{ print $2 }')
while read port; do
	proto=${port##*/}
	portOnly=${port%/*}
	pad=$(( 5 - ${#portOnly} ))
	hostPort=${DOCKER_PORT_PREFIX:0:$pad}${port%%/*}
	[ ${#hostPort} -gt 5 ] && hostPort=${hostPort:${#hostPort}-5}
	DOCKER_RUN_ARGS+=( -p $hostPort:$port )
done < <(docker image inspect -f '{{json .Config.ExposedPorts}}' $imageId|jq -r 'keys[]')

DOCKER_RUN_ARGS+=( -v $GUEST_MNT/etc/activemq/activemq.xml:/opt/activemq/conf/activemq.xml )
DOCKER_RUN_ARGS+=( -v $GUEST_MNT/etc/activemq/users.properties:/opt/activemq/conf/users.properties )
DOCKER_RUN_ARGS+=( -v $GUEST_MNT/etc/activemq/credentials.properties:/opt/activemq/conf/credentials.properties )
DOCKER_RUN_ARGS+=( -v $GUEST_MNT/etc/activemq/jetty-realm.properties:/opt/activemq/conf/jetty-realm.properties )
DOCKER_RUN_ARGS+=( -v $GUEST_MNT/etc/activemq/jetty.xml:/opt/activemq/conf/jetty.xml )
DOCKER_RUN_ARGS+=( -v $GUEST_MNT/var/lib/activemq/data:/opt/activemq/data )

docker update --restart=no $NAME || true
docker stop $NAME || true
docker system prune -f
docker run -d -it --rm --restart=always "${DOCKER_RUN_ARGS[@]}" --name $NAME $RUN_IMAGE:$VERSION "$@"

echo "To attach to container run 'docker attach $NAME'. To detach CTRL-P CTRL-Q."
[ "$DOCKER_ATTACH" != "true" ] || docker attach $NAME


