#!/usr/bin/env bash

APP_NAME="brightness_control"

case "$1" in
    up)
        brightnessctl --device="kbd_backlight" set +10%
        ;;
    down)
        brightnessctl --device="kbd_backlight" set 10%-
        ;;
    *)
        echo "Usage: $0 {up|down}"
        exit 1
        ;;
esac

BRIGHTNESS_INFO=$(brightnessctl -m --device="kbd_backlight")

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
         -h string:x-dunst-stack-tag:keyboard_brightness \
         -h int:value:"$brightness_percent" \
         -u low \
         -i "$ICON" \
         "Keyboard_Brightness" \
         ""
