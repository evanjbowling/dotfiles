FROM ubuntu:16.04

LABEL maintainer="evan.j.bowling@gmail.com"

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install vim -y
RUN apt-get install curl -y
RUN apt-get install git -y
