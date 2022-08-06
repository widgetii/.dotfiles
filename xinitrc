export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# some Chineese
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
# Launch Fcitx Config GUI from contrl center, add Google Pinyin.
fcitx --disable fcitx-xkb

xkbcomp -I$HOME/.config/xkb ~/.config/xkb/keymap/my_layout $DISPLAY

HHKB_ID=$(
    xinput list |
    sed -n 's/.*HHKB Professional.*id=\([0-9]*\).*keyboard.*/\1/p'
)
[ $HHKB_ID ] && xkbcomp -I$HOME/.config/xkb -i $HHKB_ID ~/.config/xkb/keymap/my_hhkb $DISPLAY

# some custom keys modifications
xmodmap ~/.Xmodmap

# однократное нажатие у нас будет для Enter->Return, для Caps->Escape
xcape -t 500 -e "Control_R=Return;Control_L=Escape"
xcape -t 500 -e "Super_L=ISO_First_Group;Super_R=ISO_Last_Group"
#$HOME/xcape3 -t 150 -e "Hyper_L=space"
# Shift and parenthesis
xcape -t 250 -e 'Shift_L=parenleft;ISO_Level3_Shift=parenright'
# {} on Alts
xcape -e 'Alt_L=Shift_L|braceleft;Alt_R=Shift_L|braceright'

# Ctrl-M -> Return
xbindkeys

# beeping off
xset b off
# mouse speed
xset m 4/1 4

export TERMINAL=/usr/bin/kitty
#sxhkd &
#exec bspwm
compton -b -i 0.8
flameshot &
clipit &
/usr/lib/notify-osd/notify-osd &
exec i3
