#!/bin/bash

title=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|grep -A 1 "title"|grep -v "title"|cut -b 44-|cut -d '"' -f 1|grep -v ^$`

status=` dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'PlaybackStatus' | tail -1 | cut -d "\"" -f2`

artist=`dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata'|grep -A 2 "artist"|grep -v "artist"|grep -v "array"|cut -b 27-|cut -d '"' -f 1|grep -v ^$`
echo "$artist-$title($status)"
