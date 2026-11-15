#!/usr/bin/env bash
# Purpose: This script manually copies a skill from this repo into the
#          user-level Claude Code skills directory (~/.claude/skills), making
#          the skill available in every project.
#   Usage: $0 SKILL_NAME [--force]



SKILLS_DEST="$HOME/.claude/skills"

# Print usage, list the skills available in this repo, then exit
#
# $1 - exit code
function usage() {
  local code=$1
  echo "Usage: $(basename "$0") SKILL_NAME [--force]"
  echo
  echo "Copies .claude/skills/SKILL_NAME from this repo into $SKILLS_DEST."
  echo "Pass --force to replace a skill that is already installed."
  echo
  echo "Available skills:"
  list_skills
  exit "$code"
}

# Echo the directory holding this repo's skills
function skills_src_dir() {
  local script_dir=$(cd "$(dirname "$0")" && pwd)
  echo "$(dirname "$script_dir")/.claude/skills"
}

# Echo the name of each skill in this repo, one per line
function list_skills() {
  local src=$(skills_src_dir)
  local path
  for path in "$src"/*/; do
    if [ -f "${path}SKILL.md" ]; then
      echo "  $(basename "$path")"
    fi
  done
}

# Check that a skill name is a single safe path segment
#
# $1 - skill name
function is_valid_name() {
  local name=$1
  case "$name" in
    "" | . | .. | *[/\\]*) return 1 ;;
    -*) return 1 ;;
    *) return 0 ;;
  esac
}

# Copy one skill into the destination directory
#
# $1 - skill name
# $2 - "force" to replace an existing install, "" otherwise
function install_skill() {
  local name=$1
  local force=$2
  local src="$(skills_src_dir)/$name"
  local dest="$SKILLS_DEST/$name"

  if [ ! -f "$src/SKILL.md" ]; then
    echo "error: no skill named '$name' in $(skills_src_dir)" >&2
    return 1
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ "$force" != "force" ]; then
      echo "error: $dest already exists; pass --force to replace it" >&2
      return 1
    fi
    echo "Removing existing $dest"
    rm -rf "$dest" || return 1
  fi

  mkdir -p "$SKILLS_DEST" || return 1
  cp -R "$src" "$dest" || return 1
  echo "Installed $name -> $dest"
}

function main() {
  local name=$1
  local flag=$2
  local force=""

  if [ "$name" = "-h" ] || [ "$name" = "--help" ]; then
    usage 0
  fi

  if ! is_valid_name "$name"; then
    echo "error: missing or invalid SKILL_NAME" >&2
    usage 1
  fi

  if [ -n "$flag" ]; then
    if [ "$flag" != "--force" ]; then
      echo "error: unknown argument '$flag'" >&2
      usage 1
    fi
    force="force"
  fi

  install_skill "$name" "$force"
}

main "$@"
