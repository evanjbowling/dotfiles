#!/usr/bin/env bash

# 0. check what containers are running
docker ps -a

# 1. run simple container
docker run --rm -it python:2 /bin/bash

# 2. stop & remove all exited containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a q)

# 3. remove container
docker rm <CONTAINER_ID>

# 4. remove image
docker rmi <IMAGE_ID>
