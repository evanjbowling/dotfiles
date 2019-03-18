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
    echo "" >> "${HOME}/.bashrc"
    echo "# added by evanjbowling/dotfiles" >> "${HOME}/.bashrc"
    echo "if [ -f ${HOME}/.bash_ejb ]; then" >> "${HOME}/.bashrc"
    echo "  . ${HOME}/.bash_ejb" >> "${HOME}/.bashrc"
    echo "fi" >> "${HOME}/.bashrc"
    echo "" >> "${HOME}/.bashrc"
  else
    echo -e "${GREEN}${HOME}/.bashrc has ref to ${HOME}/.bash_ejb${NC}"
  fi
fi

# check if ~/.vimrc is installed
if [ ! -f "${HOME}/.vimrc" ]; then
  echo -e "${YELLOW}${HOME}/.vimrc is not installed${NC} - Installing"
  cp ".vimrc" "${HOME}"
else
  echo -e "${GREEN}${HOME}/.vimrc is installed${NC}"
fi

# check if ~/.gitconfig is installed
if [ ! -f "${HOME}/.gitconfig" ]; then
  echo -e "${YELLOW}${HOME}/.gitconfig is not installed${NC} - Installing"
  cp ".gitconfig" "${HOME}"
else
  echo -e "${GREEN}${HOME}/.gitconfig is installed${NC}"
fi

# check if ~/.emacs.d is installed
if [ ! -d "${HOME}/.emacs.d" ]; then
  echo -e "${YELLOW}${HOME}/.emacs.d does not exist${NC} - Installing symlink"
  ln -s "${PWD}/.emacs.d" "${HOME}/.emacs.d"
  echo -e "${YELLOW}Running cask install"
  pushd "${HOME}/.emacs.d" && cask install && popd
else
  if [ ! -L "${HOME}/.emacs.d" ]; then
    echo -e "${RED}${HOME}/.emacs.d exists but is not a symbolic link${NC} - No Action Taken"
  else
    if [ ! `readlink "${HOME}/.emacs.d"` = "${PWD}/.emacs.d" ]; then
      echo -e "${YELLOW}${HOME}/.emacs.d does not point to dotfiles source - Installing symlink"
      unlink "${HOME}/.emacs.d"
      ln -s "${PWD}/.emacs.d" "${HOME}/.emacs.d"
      echo -e "${YELLOW}Running cask install"
      pushd "${HOME}/.emacs.d" && cask install && popd
    else
      echo -e "${GREEN}/.emacs.d is installed and symlinked${NC}"
    fi
  fi
fi
