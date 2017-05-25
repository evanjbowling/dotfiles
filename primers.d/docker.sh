#!/usr/bin/env bash

# 1. run simple container
docker run --rm -it python:2 /bin/bash

# 2. stop & remove all exited containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a q)
