#!/bin/bash

if eww active-windows | grep --quiet "popup-panel"; then
    eww --no-daemonize close popup-panel
else
    eww --no-daemonize open popup-panel
fi
