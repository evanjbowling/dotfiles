#!/usr/bin/env bash

# see https://tools.ietf.org/html/rfc8270
# Trivia: The output while the command is running
#         to generate keys/dhparams means the fo-
#         llowing:
# . : A potential prime number was generated.
# + : Number is being tested for primality.
# * : A prime number was found.

# 0. generate diffie-hellman params
openssl dhparam 2048 # 4096/8192
