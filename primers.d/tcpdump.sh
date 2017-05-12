#!/usr/bin/env bash

# 0.root is typically required for access to interfaces
# 1.list interfaces
sudo tcpdump -D

# 2. listen to a particular interface
sudo tcpdump -i 8
