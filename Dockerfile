FROM ubuntu:16.04
MAINTAINER Paddy Carey <paddy@wackwack.co.uk>

# install build and runtime dependencies
RUN apt-get update && apt-get install -y software-properties-common \
                                         supervisor wget zookeeper

# install kafka using .deb packages provided by Confluent
RUN wget -qO - http://packages.confluent.io/deb/3.0/archive.key | apt-key add -
RUN add-apt-repository "deb [arch=amd64] http://packages.confluent.io/deb/3.0 stable main"
RUN apt-get update && apt-get install -y confluent-platform-2.11

# copy custom configuration files and scripts into place
COPY config/supervisord.conf /etc/supervisord.conf
COPY config/kafka/server.properties /etc/kafka/server.properties
COPY config/kafka/zookeeper.properties /etc/kafka/zookeeper.properties
COPY scripts/start_kafka.sh /usr/local/bin/start_kafka

EXPOSE 9092
CMD ["start_kafka"]
