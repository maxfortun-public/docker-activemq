FROM openjdk:16-jdk-alpine

ARG ACTIVEMQ_VERSION

ENV ACTIVEMQ_VERSION=$ACTIVEMQ_VERSION

RUN apk --update add curl \
	&& rm -rf /var/cache/apk/*

COPY build /build
RUN /build/build.sh \
	&& rm -rf /build

EXPOSE \
# Console
	8161 \
# CORE,MQTT,AMQP,HORNETQ,STOMP,OPENWIRE
    61616 \
# AMQP
    5672 \
# MQTT
    1883 \
# STOMP
    61613 \
# WebSocket
    61614

CMD [ "/opt/activemq/bin/activemq", "console" ]
