# docker-activemq

## Docker build
```
ACTIVEMQ_VERSION=5.16.1
docker build --rm -t "local/activemq:$ACTIVEMQ_VERSION" --build-arg ACTIVEMQ_VERSION=5.16.1 .
```

## Docker run
```
HOST_ROOT="/path/to/docker/host/root/with/cfg/files"
ACTIVEMQ_VERSION=5.16.1
imageName=local/activemq:$ACTIVEMQ_VERSION
DOCKER_RUN_ARGS=( )
imageId=$(docker images --format="{{.Repository}} {{.ID}}"|grep "^$imageName "|awk '{ print $2 }')
while read port; do
    portOnly=${port%/*}
    DOCKER_RUN_ARGS+=( -p $portOnly:$port )
done < <(docker image inspect -f '{{json .Config.ExposedPorts}}' $imageId|jq -r 'keys[]')

DOCKER_RUN_ARGS+=( -v $HOST_ROOT/etc/activemq/activemq.xml:/opt/activemq/conf/activemq.xml )
DOCKER_RUN_ARGS+=( -v $HOST_ROOT/etc/activemq/users.properties:/opt/activemq/conf/users.properties )
DOCKER_RUN_ARGS+=( -v $HOST_ROOT/etc/activemq/credentials.properties:/opt/activemq/conf/credentials.properties )
DOCKER_RUN_ARGS+=( -v $HOST_ROOT/etc/activemq/jetty-realm.properties:/opt/activemq/conf/jetty-realm.properties )
DOCKER_RUN_ARGS+=( -v $HOST_ROOT/etc/activemq/jetty.xml:/opt/activemq/conf/jetty.xml )
DOCKER_RUN_ARGS+=( -v $HOST_ROOT/var/lib/activemq/data:/opt/activemq/data )
```

