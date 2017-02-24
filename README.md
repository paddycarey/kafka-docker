kafka-docker
============

[![Docker Automated Build](https://img.shields.io/docker/automated/paddycarey/kafka.svg)](https://hub.docker.com/r/paddycarey/kafka/)

This repository provides a Dockerised Kafka instance (based on Confluent Platform 3.0.1/Scala 2.11) for development and testing use.

**NOTE:** This image is _NOT_ intended for use in production. Horrible things will probably happen if you attempt to do so.

## Why?

Running Zookeeper and Kafka and configuring them to work together is a pain. This image runs both Zookeeper and Kafka together in a single container (managed by supervisord), pre-configured to work together out of the box.

## Running Kafka

By default Kafka will be accessible on `localhost:9092`, `localhost:9093` and `localhost:9193` so long as the port is exposed at runtime:

```bash
$ docker run -ti -p 9092:9092 -p 9093:9093 -p 9193:9193 paddycarey/kafka
```

Kafka comes with a command line client that will take input from a file or from standard input and send it out as messages to the Kafka cluster. By default, each line will be sent as a separate message. You can use this client to test that Kafka is working. Run the producer and then type a few messages into the console to send to the server:

```bash
$ kafka-console-producer.sh --broker-list localhost:9092 --topic "test"
This is a message
This is another message
```

Kafka also has a command line consumer that will dump out messages to standard output.

```bash
$ kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic "test" --from-beginning
This is a message
This is another message
```

If you have each of the above commands running in a different terminal then you should now be able to type messages into the producer terminal and see them appear in the consumer terminal.

### Accessing kafka on something other than localhost

This image is configured so that it can be accessed on `localhost:9092` for a PLAIN connection or `localhost:9093` for a SSL connection or `localhost:9193` for SSL + SASL. If you need to access Kafka using a different hostname you can set the `KAFKA_ADVERTISED_HOST` environment variable.

```bash
$ docker run -ti -e "KAFKA_ADVERTISED_HOST=somehostname" -p 9092:9092 -p 9093:9093 -p 9193:9193 paddycarey/kafka
```

Or if using Docker compose, your `docker-compose.yml` might look something like:

```yaml
kafka:
    image: paddycarey/kafka # or whatever your built
    ports:
        - "9092:9092"
        - "9093:9093"
        - "9193:9193"
    environment:
      KAFKA_ADVERTISED_HOST: kafka

consumer:
    build: .
    links:
      - kafka
    command: "python -u consumer.py"
```

## Persistence

This image stores log data in `/var/lib/kafka`. You can use a Docker volume to persist this directory beyond the lifetime of a single container.

```bash
$ docker run -ti -v `pwd`/.data/:/var/lib/kafka -p 9092:9092 -p 9093:9093 -p 9193:9193 paddycarey/kafka
```

## Building the image

To build the Docker image:

```bash
$ docker build -t paddycarey/kafka .
```

Note: Advanced users can modify the configuration files in `config/kafka/` if necessary to change the behaviour of Kafka or Zookeeper.
