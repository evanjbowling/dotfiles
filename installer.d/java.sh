#!/usr/bin/env bash

NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

# check if JAVA_HOME is set
if [ -z "$JAVA_HOME" ]; then
  echo -e "${YELLOW}JAVA_HOME is not set${NC}"
  JDK8_LINK="http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html"
  echo "Download JDK8 from: ${JDK8_LINK}"
  exit 1
else
  echo -e "${GREEN}JAVA_HOME is set${NC}"
fi

