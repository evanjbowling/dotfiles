FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install vim \
                       curl \
                       git \
                       openjdk-8-jdk                      

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

COPY src/docker/entry-point.sh /entry-point.sh

ENTRYPOINT ["/entry-point.sh"]
