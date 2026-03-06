#!/bin/bash

grim -g "$(slurp -c '#00000000')" - | satty --filename - --fullscreen --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png
