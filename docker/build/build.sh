#!/bin/ash -ex

cd $(dirname $0)

cd /opt
curl -vOL https://www.apache.org/dist/activemq/$ACTIVEMQ_VERSION/apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz
tar xvzf apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz
mv apache-activemq-$ACTIVEMQ_VERSION activemq
rm apache-activemq-$ACTIVEMQ_VERSION-bin.tar.gz

