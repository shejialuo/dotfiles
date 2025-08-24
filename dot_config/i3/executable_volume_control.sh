#!/usr/bin/env bash

APP_NAME="i3_volume_control"

case "$1" in
    up)
        pamixer -i 5
        ;;
    down)
        pamixer -d 5
        ;;
    toggle)
        pamixer -t
        ;;
    *)
        echo "Usage: $0 {up|down|mute}"
        exit 1
        ;;
esac

volume=$(pamixer --get-volume)
is_muted=$(pamixer --get-mute)

if [ "$is_muted" = "true" ]; then
    dunstify -a $APP_NAME -h string:x-dunst-stack-tag:audio -h int:value:$volume -u low -i audio-volume-muted "Volume" "Muted"
else
    if [ "$volume" -le 33 ]; then
        icon=audio-volume-low
    elif [ "$volume" -le 66 ]; then
        icon=audio-volume-medium
    else
        icon=audio-volume-high
    fi
    dunstify -a $APP_NAME -h string:x-dunst-stack-tag:audio -h int:value:$volume -u low -i $icon "Volume" ""
fi
