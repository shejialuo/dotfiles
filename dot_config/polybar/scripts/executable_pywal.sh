#!/usr/bin/env bash

ALPHA="d9"
PFILE="$HOME/.config/polybar/colors.ini"
WFILE="$HOME/.cache/wal/colors.sh"

pywal_get() {
    wal -i "$1" -q -t
}

change_color() {
    sed -i -e "s/background = #.*/background = $BG/g" $PFILE
    sed -i -e "s/foreground = #.*/foreground = $FG/g" $PFILE
    sed -i -e "s/foreground-alt = #.*/foreground-alt = $FGA/g" $PFILE
    sed -i -e "s/shade1 = #.*/shade1 = $SH1/g" $PFILE
    sed -i -e "s/shade2 = #.*/shade2 = $SH2/g" $PFILE
    sed -i -e "s/shade3 = #.*/shade3 = $SH3/g" $PFILE
    sed -i -e "s/shade4 = #.*/shade4 = $SH4/g" $PFILE
    sed -i -e "s/shade5 = #.*/shade5 = $SH5/g" $PFILE
    sed -i -e "s/shade6 = #.*/shade6 = $SH6/g" $PFILE
    sed -i -e "s/shade7 = #.*/shade7 = $SH7/g" $PFILE
    sed -i -e "s/shade8 = #.*/shade8 = $SH8/g" $PFILE

    polybar-msg cmd restart
}

if [[ -x "`which wal`" ]]; then
    if [[ "$1" ]]; then
        pywal_get "$1"

        # Source the pywal color file
        if [[ -e "$WFILE" ]]; then
            . "$WFILE"
        else
            echo 'Color file does not exist, exiting...'
            exit 1
        fi

        BG=`printf "#%s%s\n" "$ALPHA" "${background#\#}"`
        FG=`printf "%s\n" "$foreground"`
        FGA=`printf "%s\n" "$color8"`
        SH1=`printf "#%s%s\n" "$ALPHA" "${color1#\#}"`
        SH2=`printf "#%s%s\n" "$ALPHA" "${color2#\#}"`
        SH3=`printf "#%s%s\n" "$ALPHA" "${color3#\#}"`
        SH4=`printf "#%s%s\n" "$ALPHA" "${color4#\#}"`
        SH5=`printf "#%s%s\n" "$ALPHA" "${color5#\#}"`
        SH6=`printf "#%s%s\n" "$ALPHA" "${color6#\#}"`
        SH7=`printf "#%s%s\n" "$ALPHA" "${color7#\#}"`
        SH8=`printf "#%s%s\n" "$ALPHA" "${color8#\#}"`

        change_color
    else
        echo -e "[!] Please enter the path to wallpaper. \n"
        echo "Usage : ./pywal.sh path/to/image"
    fi
else
    echo "[!] 'pywal' is not installed."
fi
