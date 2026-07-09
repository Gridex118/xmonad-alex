#!/usr/bin/env bash

OS_TYPE="$(uname -o)"
KERNEL_RELEASE="$(uname -r)"
COMPILE_DATE=$(uname -v| awk '{print $4 " " $5 " " $6}')

echo "$OS_TYPE $KERNEL_RELEASE $COMPILE_DATE"
