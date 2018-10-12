#!/usr/bin/env bash

# 1. simple curl request
curl http://localhost:42/

# 2. curl IPv6 localhost request
curl -g -6 --noproxy "*" "http://[::1]:42/"

# 3. GET request with increased verbosity
curl -vvv -X GET http://server:1234

# 4. POST request with application/json content
curl -X POST -H "Content-Type: application/json" http://server:1234 -d '{"key":[1,2,"val"]}'
