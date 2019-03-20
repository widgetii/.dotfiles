#!/usr/bin/env bash

N=$(xprop -id `xdotool getactivewindow` |awk '/WM_CLASS/{print $4}')

if [ $N = '"kitty"' ]; then
    xdotool key Return
else
    # Emulate right arrow and Return at least for Chrome
    xdotool key Right Return
fi

