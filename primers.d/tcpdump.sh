#!/usr/bin/env bash

# 0.root is typically required for access to interfaces
# 1.list interfaces
sudo tcpdump -D

# 2. list to all interfaces and be less verbose (quiet flag)
sudo tcpdump -i any -q

# 3. listen to a particular interface
sudo tcpdump -i 8 #/en0/eth0

# 4. listen to all tcp traffic
sudo tcpdump -i any -q tcp

# 5. ssh traffic
sudo tcpdump "src port 22"

# 6. https traffic
sudo tcpdump "src port 443"
