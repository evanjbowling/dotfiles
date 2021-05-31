#!/usr/bin/env bash
# Purpose: provide a single place to trigger different types of
#          tests (er. as root, as non-root user)
mkdir ~/.ejb
git clone https://github.com/evanjbowling/dotfiles.git ~/.ejb/dotfiles

echo 'if [ -f "$HOME/.ejb/dotfiles/.bash_ejb" ]; then' >> ~/.bashrc
echo '  . "$HOME/.ejb/dotfiles/.bash_ejb"' >> ~/.bashrc
echo 'fi' >> ~/.bashrc

bash

