FROM openjdk:16-jdk-alpine

ARG ACTIVEMQ_VERSION

RUN apk --update add curl \
	&& rm -rf /var/cache/apk/*

WORKDIR /opt
RUN curl -vOL https://www.apache.org/dist/activemq/$ACTIVEMQ_VERSION/apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz && \
	tar xvzf apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz && \
	mv apache-activemq-$ACTIVEMQ_VERSION activemq  && \
	rm apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz

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

WORKDIR /opt/activemq
CMD [ "bin/activemq", "console" ]
