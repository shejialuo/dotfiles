#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# When switching the workspace, we need to dim the previous workspace
# and highlight the current workspace.
update_workspace_appearance() {
    local sid=$1
    local is_focused=$2

    if [ "$is_focused" = "true" ]; then
        sketchybar --set space.$sid background.drawing=on \
            background.color=$ACCENT_COLOR \
            label.color=$ITEM_COLOR \
            icon.color=$ITEM_COLOR
    else
        sketchybar --set space.$sid background.drawing=off \
            label.color=$ACCENT_COLOR \
            icon.color=$ACCENT_COLOR
    fi
}

# Get the app icons of workspace of a monitor.
update_icons() {
    m=$1
    sid=$2

    apps=$(aerospace list-windows --monitor "$m" --workspace "$sid" \
    | awk -F '|' '{gsub(/^ *| *$/, "", $2); if (!seen[$2]++) print $2}' \
    | sort)

    icon_strip=""
    if [ "${apps}" != "" ]; then
        while read -r app; do
            icon_strip+=" $($CONFIG_DIR/plugins/icons.sh "$app")"
        done <<<"${apps}"
    else
        icon_strip=" —"
    fi

    sketchybar --animate sin 10 --set space.$sid label="$icon_strip"
}

if [ ! -z "$PREV_WORKSPACE" ]; then
    update_workspace_appearance "$PREV_WORKSPACE" "false"
fi
if [ ! -z "$FOCUSED_WORKSPACE" ]; then
    update_workspace_appearance "$FOCUSED_WORKSPACE" "true"
fi

for m in $(aerospace list-monitors | awk '{print $1}'); do
    for sid in $(aerospace list-workspaces --monitor $m --visible); do
        if [ -z "$sid" ]; then
            continue
        fi

        sketchybar --set space.$sid display=$m
        update_icons "$m" "$sid"
        if [ ! -z "$PREV_WORKSPACE" ]; then
            update_icons "$m" "$PREV_WORKSPACE"
        fi
        apps=$(aerospace list-windows --monitor "$m" --workspace "$sid" | wc -l)
        if [ "${apps}" -eq 0 ]; then
            sketchybar --set space.$sid display=0
        fi
    done
done
