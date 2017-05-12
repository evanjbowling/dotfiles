#! /usr/bin/env bash

# No man page, just run w/out args to bring up help menu
VBoxManage

# List the vms
VBoxManage list vms     # help w/ list command:   VBoxManage list

# set the guest to use the same dns resolver as the host
VBoxManage modifyvm "VM NAME" --natndshostresolver1 on
