#!/usr/bin/env bash

# 1. stop & remove all exited containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a q)
