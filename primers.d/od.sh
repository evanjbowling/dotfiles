#!/usr/bin/env bash

# 0. good goto
od -A x -t x1z -v <FILE>

# 1. select octal bytes
od -b <FILE>

# 2. select printable chars
od -c <FILE>

# 3. accept from stdin
echo "hello" | od -c -

# 4. restrict width of output line in bytes (default is 32)
echo "㑀" | od -w1 -c -Ad -

# 5. output in hex with 4 bytes / line
od -x -w4 <FILE>
