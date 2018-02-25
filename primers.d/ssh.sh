#!/usr/bin/env bash

KEY=".ssh/..."

# largely adapated from github's instructions
# generate 4096-bit rsa keys
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# inspect md5 fingerprint of key (default displayed on github)
ssh-keygen -l -E md5 -f <KEYFILE>

# Start ssh-agent in background
eval "$(ssh-agent -s)"             # Agent pid XXXXX

# add SSH private key to ssh-agent
ssh-add -K <KEYFILE>
