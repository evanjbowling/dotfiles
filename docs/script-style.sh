#!/usr/bin/env bash
# Purpose: This script is made to help with X
#   Usage: $0 ARG1 ARG2 [OPTIONAL_ARG]



# Concatenate two string args together
# 
# $1 - first string
# $2 - second string
function concat_strings() {
  local a=$1
  local b=$2
  echo "$a $b"
}

function main() {
  concat_strings "hello" "george"
}

main
