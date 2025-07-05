#!/bin/bash

# Define device paths
EDP_STATUS="/sys/class/drm/card0-eDP-1/status"
HDMI_STATUS="/sys/class/drm/card0-HDMI-A-1/status"

# Check if HDMI is connected and toggle eDP accordingly
if [ -f "$HDMI_STATUS" ] && grep -q "connected" "$HDMI_STATUS"; then
    echo "HDMI is connected. Disabling internal display (eDP-1)."
    echo 0 > /sys/class/drm/card0-eDP-1/enabled
else
    echo "HDMI is not connected. Enabling internal display (eDP-1)."
    echo 1 > /sys/class/drm/card0-eDP-1/enabled
fi
