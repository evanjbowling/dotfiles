#!/usr/bin/env bash
# Purpose: provide a single place to trigger different types of
#          tests (er. as root, as non-root user)
mkdir ~/.ejb
git clone -b "${DOTFILES_REF:-master}" https://github.com/evanjbowling/dotfiles.git ~/.ejb/dotfiles

~/.ejb/dotfiles/install.sh --skip-setup --name "Test User" --email "test@example.com"

# create a few nested directories and a git repo with uncommitted files
mkdir -p ~/apple/banana/carrot/git_temp
cd ~/apple/banana/carrot/git_temp
git init
echo "hello" > README.md

bash

