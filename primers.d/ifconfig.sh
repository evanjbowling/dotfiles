#!/usr/bin/env
#
# ifconfig -- configure network interface parameters
#
# Notes:
#   address family:
#     'inet', 'inet6'                    - Internet Layer
#     'link' (aka 'ether', 'lladr')      - Link Layer
#   common interfaces:
#     lo0                                - Local Loopback  (typically 127.0.0.1/8, ::1/128)
#     gif0                               - generic tunnel interface
#     en0                                - 
#     p2p0                               - 
#     stf                                - 6to4 tunnel interface (man stf)
#     awdl0                              - Apple Wireless Direct Link
#     bridge0                            - Bridge Interface

# 1. list network interfaces
ifconfig -l

# 2. list all network details
ifconfig -a

# 3. list verbose details about an interface
ifconfig -v <INTERFACE>
