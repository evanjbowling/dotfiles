#!/usr/bin/env bash

NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

# check if lein is installed
type lein &> /dev/null
if [ $? -ne 0 ]; then
  echo -e "${YELLOW}lein is not installed${NC}"
  LEIN_LINK="https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein"
  curl -s "${LEIN_LINK}" -o ~/tools/lein && chmod +x ~/tools/lein
else
  echo -e "${GREEN}lein is installed${NC}"
fi

