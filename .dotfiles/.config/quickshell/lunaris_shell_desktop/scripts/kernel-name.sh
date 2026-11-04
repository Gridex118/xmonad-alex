#!/usr/bin/env bash

OS_TYPE="$(uname -o)"
KERNEL_RELEASE="$(uname -r)"
COMPILE_DATE_POSIX=$(uname -v| awk '{print $4 " " $5 " " $6}')
if [ -n "$COMPILE_DATE_POSIX" ]; then
    COMPILE_DATE=$(date --utc --date=${COMPILE_DATE_POSIX} +'%b %d')
fi

echo "$OS_TYPE $KERNEL_RELEASE ($COMPILE_DATE)"
