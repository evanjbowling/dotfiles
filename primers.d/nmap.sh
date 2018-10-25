#!/usr/bin/env bash

# 0. TARGET can be:
#     * IPv4 address    eg. 192.168.1.0
#     * IPv4 subnet     eg. 192.168.1.0/24

# 1. basic scan of device liveness on network (no port scanning)
nmap -sn <TARGET>

# 2. scan for devices with port 80 open
nmap -p80 <TARGET>

# more
# see https://highon.coffee/blog/nmap-cheat-sheet/
