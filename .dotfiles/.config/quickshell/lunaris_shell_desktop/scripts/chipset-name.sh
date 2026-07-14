#!/usr/bin/env bash

cat /proc/cpuinfo| awk -F':' '/model name/{print $2}'| head -n1| sed 's/(.*)//g'
