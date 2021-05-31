FROM ubuntu:18.04
RUN apt-get -y update && \
    apt-get -y install vim curl git
COPY src/docker/entry-point.sh /entry-point.sh
ENTRYPOINT ["/entry-point.sh"]

