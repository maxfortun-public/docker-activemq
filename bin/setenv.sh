REPO=local
NAME=activemq
VERSION=0.0.1

DOCKER_PORT_PREFIX=40

DOCKER_BUILD_ARGS=( --build-arg HOME=$HOME )
DOCKER_BUILD_ARGS+=( --build-arg REPO=$REPO )
DOCKER_BUILD_ARGS+=( --build-arg NAME=$NAME )
DOCKER_BUILD_ARGS+=( --build-arg VERSION=$VERSION )

DOCKER_BUILD_ARGS+=( --build-arg ACTIVEMQ_VERSION=5.16.1 )

PROXY_PORT=43128
if netstat -an|grep -q \.$PROXY_PORT.*LISTEN; then
	proxy_ip=$(ifconfig -a|grep inet.*192.168.|awk '{ print $2}')
	DOCKER_BUILD_ARGS+=( --build-arg http_proxy=http://$proxy_ip:$PROXY_PORT --build-arg https_proxy=http://$proxy_ip:$PROXY_PORT )
fi

