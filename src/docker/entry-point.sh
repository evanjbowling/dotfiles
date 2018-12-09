#!/usr/bin/env bash
# Purpose: provide a single place to trigger different types of
#          tests (er. as root, as non-root user)
curl https://raw.githubusercontent.com/evanjbowling/dotfiles/master/installer > installer && chmod +x installer && ./installer && rm ./installer && bash
