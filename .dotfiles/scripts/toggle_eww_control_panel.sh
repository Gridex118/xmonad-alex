#!/bin/bash

if eww active-windows | grep --quiet "control-panel"; then
    eww --no-daemonize close control-panel
else
    eww --no-daemonize open control-panel
fi
