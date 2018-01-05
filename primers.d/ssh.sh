#!/usr/bin/env bash

KEY=".ssh/..."

# 0. generate ssh key
# 1. copy ssh pub key to remote machine
# 2. start ssh-agent (if not already running, check ps)
# 3. add the key to ssh-agent
ssh-add $KEY

