#!/bin/bash

STATUS_FILE="/sys/class/drm/card0-eDP-1/status"

if [ -f "$STATUS_FILE" ]; then
    STATUS=$(cat "$STATUS_FILE")
    if [ "$STATUS" = "connected" ]; then
        echo "Current status: 'connected', will try to close eDP-1 device"
        echo "off" | sudo tee /sys/class/drm/card0-eDP-1/status
    else
        echo "Current status: not connected（$STATUS）, will try to connect eDP-1 device"
        echo "on" | sudo tee /sys/class/drm/card0-eDP-1/status
    fi
else
    echo "Can't found $STATUS_FILE, can't get eDP-1 status"
    exit 1
fi
