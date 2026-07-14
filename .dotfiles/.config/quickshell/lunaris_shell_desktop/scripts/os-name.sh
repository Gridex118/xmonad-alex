#!/usr/bin/env bash

cat /etc/os-release| awk -F'=' '/PRETTY_NAME/{print $2}'| sed 's/\"//g'
