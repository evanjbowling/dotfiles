#!/usr/bin/env bash
# meant to be executed from top dir of git repo
# paths currently depend on this

NC='\033[0m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'

# check if ~/.bash_ejb is installed
if [ ! -f "${HOME}/.bash_ejb" ]; then
  echo -e "${YELLOW}${HOME}/.bash_ejb is not installed${NC} - Installing"
  cp ".bash_ejb" "${HOME}"
else
  echo -e "${GREEN}${HOME}/.bash_ejb is installed${NC}"
  # TODO: cksum of files to ensure they are equal
fi

# check if ~/.bash_ejb is called from .bashrc
if [ ! -f "${HOME}/.bashrc" ]; then
  echo -e "${RED}${HOME}/.bashrc not found ${NC} - Not adding ref"
else
  REF_TO_BASH_EJB=`cat "${HOME}/.bashrc" | grep "bash_ejb"`
  if [ -z "${REF_TO_BASH_EJB}" ]; then
    echo -e "${YELLOW}${HOME}/.bashrc does not contain ref to ${HOME}/.bash_ejb${NC} - Installing"
    echo "if [ -f ${HOME}/.bash_ejb ]; then" >> "${HOME}/.bashrc"
    echo "  . ${HOME}/.bash_ejb" >> "${HOME}/.bashrc"
    echo "fi" >> "${HOME}/.bashrc"
    echo "" >> "${HOME}/.bashrc"
  else
    echo -e "${GREEN}${HOME}/.bashrc has ref to ${HOME}/.bash_ejb${NC}"
  fi
fi

