#!/usr/bin/env bash
set -euo pipefail

if [ "$(uname -s)" = "Darwin" ]; then
  PROFILE="$HOME/.bash_profile"
else
  PROFILE="$HOME/.bashrc"
fi

if [ ! -f "$PROFILE" ]; then
  touch "$PROFILE"
fi

if grep -q "dotfiles/.bash_ejb" "$PROFILE"; then
  echo "Already installed. Nothing to do."
else
  {
    echo 'if [ -f "$HOME/.ejb/dotfiles/.bash_ejb" ]; then'
    echo '  . "$HOME/.ejb/dotfiles/.bash_ejb"'
    echo 'fi'
  } >> "$PROFILE"
  echo "Added .bash_ejb to $PROFILE"
  echo "Open a new terminal for the changes to take effect."
fi
