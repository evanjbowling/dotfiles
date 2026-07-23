#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKIP_SETUP=0
NAME="${DOTFILES_NAME:-}"
EMAIL="${DOTFILES_EMAIL:-}"

while [ $# -gt 0 ]; do
  case "$1" in
    --skip-setup) SKIP_SETUP=1 ;;
    --name) shift; NAME="$1" ;;
    --email) shift; EMAIL="$1" ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

# 1. Source .bash_ejb from the shell profile, idempotently.
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
fi

# 2. Determine name/email for templating.
if [ -z "$NAME" ]; then
  NAME=$(git config --global user.name 2>/dev/null || true)
fi
if [ -z "$EMAIL" ]; then
  EMAIL=$(git config --global user.email 2>/dev/null || true)
fi
if [ -z "$NAME" ]; then
  read -r -p "Name for .gitconfig: " NAME
fi
if [ -z "$EMAIL" ]; then
  read -r -p "Email for .gitconfig: " EMAIL
fi

_render() {
  sed -e "s/{{NAME}}/$NAME/g" -e "s/{{EMAIL}}/$EMAIL/g" "$1"
}

# 3. Copy/render managed files into $HOME without clobbering local edits.
_install_file() {
  local src="$1" dest="$2" render="$3"
  local rendered
  rendered=$(mktemp)
  if [ "$render" = "render" ]; then
    _render "$src" > "$rendered"
  else
    cat "$src" > "$rendered"
  fi

  if [ ! -e "$dest" ]; then
    cp "$rendered" "$dest"
    echo "Installed $dest"
  elif ! diff -q "$rendered" "$dest" > /dev/null 2>&1; then
    echo "Skipping $dest: differs from repo version (see devbin/diff-installed)"
  fi
  rm -f "$rendered"
}

_install_dir() {
  local src="$1" dest="$2"
  if [ ! -d "$dest" ]; then
    cp -R "$src" "$dest"
    echo "Installed $dest"
  else
    echo "Skipping $dest: already exists (see devbin/diff-installed)"
  fi
}

_install_file "$REPO_DIR/.gitconfig.tmpl" "$HOME/.gitconfig" render
_install_file "$REPO_DIR/.vimrc" "$HOME/.vimrc" plain
_install_dir "$REPO_DIR/.emacs.d" "$HOME/.emacs.d"

# 4. Run machine setup scripts.
if [ "$SKIP_SETUP" -eq 0 ]; then
  for script in "$REPO_DIR"/setup/*; do
    [ -x "$script" ] && "$script"
  done
fi

echo "Open a new terminal for the changes to take effect."
