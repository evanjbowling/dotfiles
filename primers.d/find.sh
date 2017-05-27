#!/usr/bin/env bash

# 1. find and delete python compiled files
find . -type f -name "*.pyc" -exec rm -f {} \;
