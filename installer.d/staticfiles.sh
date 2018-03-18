#!/usr/bin/env bash

NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

# check if ~/.bash_ejb is installed
if [ ! -f "~/.bash_ejb" ]; then
  echo -e "${YELLOW}~/.bash_ejb is not installed${NC} - Installing"
  cp ../.bash_ejb ~/
else
  echo -e "${GREEN}~/.bash_ejb is installed${NC}"
fi

