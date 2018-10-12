#!/usr/bin/env bash

# 1. filtering piped output
cat file.txt | grep name

# 2. search within a file
grep word file.txt

# 3. search for more complex string
grep "2018-10-11" file.txt
