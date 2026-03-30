#!/usr/bin/env bash

APP_NAME="brightness_control"

case "$1" in
    up)
        brightnessctl set +5%
        ;;
    down)
        brightnessctl set 5%-
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

BRIGHTNESS_INFO=$(brightnessctl -m)

brightness_percent=$(echo "$BRIGHTNESS_INFO" | awk -F ',' '{print $4}' | tr -d %)

brightness_percent=${brightness_percent:-0}

if [ "$brightness_percent" -le 0 ]; then
    ICON="display-brightness-off-symbolic"
elif [ "$brightness_percent" -le 33 ]; then
    ICON="display-brightness-low-symbolic"
elif [ "$brightness_percent" -le 66 ]; then
    ICON="display-brightness-medium-symbolic"
else
    ICON="display-brightness-high-symbolic"
fi

dunstify -a "$APP_NAME" \
         -h string:x-dunst-stack-tag:brightness \
         -h int:value:"$brightness_percent" \
         -u low \
         -i "$ICON" \
         "Brightness" \
         ""
