#!/usr/bin/env

# 1. simple curl request
curl http://localhost:42/

# 2. curl IPv6 localhost request
curl -g -6 --noproxy "*" "http://[::1]:42/"


