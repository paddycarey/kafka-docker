#!/bin/bash
set -e

# Set the advertised host value (if set)
if [ ! -z "$KAFKA_ADVERTISED_HOST" ]; then
    echo "Setting advertised.listeners value to: PLAINTEXT://$KAFKA_ADVERTISED_HOST:9092 or SASL_SSL://$KAFKA_ADVERTISED_HOST:9193"
    sed -i.bak "s/advertised.listeners=PLAINTEXT:\/\/localhost:9092/advertised.listeners=PLAINTEXT:\/\/$KAFKA_ADVERTISED_HOST:9092/g" /etc/kafka/server.properties
    sed -i.bak "s/advertised.listeners=SASL_SSL:\/\/localhost:9193/advertised.listeners=SASL_SSL:\/\/$KAFKA_ADVERTISED_HOST:9193/g" /etc/kafka/server.properties
    echo "127.0.0.1 $KAFKA_ADVERTISED_HOST" >> /etc/hosts
fi

supervisord -c /etc/supervisord.conf
