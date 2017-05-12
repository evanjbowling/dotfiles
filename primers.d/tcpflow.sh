#!/usr/bin/env tcpflow
#
# Purpose: Gives a simpler output than tcpdump for certain requests. Can be installed by
#          homebrew or other package managers.
#

# listen to all traffic on port 8000
sudo tcpflow -i any -c port 8000
