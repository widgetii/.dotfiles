export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

setxkbmap "us,ru,us" "colemak,winkeys,"

# Return&CapsLock -> Ctrl
# Caps -> Escape

# Удаляем с правого Ctrl функцию Ctrl
#xmodmap -e "remove Control = Control_R"
# И присваиваем ему функцию Enter, зачем? Может быть на случай сдохшего xcape?
xmodmap -e "keycode 0x69 = Return"
# Переименовываем Enter в Control_R
xmodmap -e "keycode 0x24 = Control_R"
# Наделяем его полномочиями Ctrl
xmodmap -e "add Control = Control_R"
# Удаляем функцию Control с левого Ctrl и функцию Lock с CapsLock
#xmodmap -e "remove Control = Control_L"
xmodmap -e "remove Lock = Caps_Lock"
# теперь у нас CapsLock - это левый Ctrl
#xmodmap -e "keycode 0x42 = Control_L"
# а левый Ctrl у нас будет пробелом
#xmodmap -e "keycode 37 = space"
# добавляем ему функцию Control
xmodmap -e "add Control = Control_L"

# for HHKB set Escape key as ~, like in normal layout
xmodmap -e "keycode 253 = Escape NoSymbol Escape NoSymbol Escape"
xmodmap -e "keycode 9 = grave asciitilde"

# однократное нажатие у нас будет для Enter->Return, для Caps->Escape
xcape -t 500 -e "Control_R=Return;Control_L=Escape"

# ВРЕМЕННО маппим на ненужные кнопки F9->English, F10->Russian
xmodmap -e "keycode 250 = ISO_First_Group"
xmodmap -e "keycode 251 = ISO_Last_Group"
# как я понял вообще без разницы какие использовать кнопки
xcape -t 500 -e "Super_L=ISO_First_Group;Super_R=ISO_Last_Group"


# Use Spacebar as a Modifier
xmodmap -e "clear mod3"
xmodmap -e "clear mod4"
xmodmap -e "add mod3 = Hyper_L"
xmodmap -e "add mod4 = Super_L Super_R"


spare_modifier="Hyper_L"
xmodmap -e "keycode 65 = $spare_modifier"   
xmodmap -e "add Hyper_L = $spare_modifier"
xmodmap -e "keycode any = space"  
#xcape -t 1000 -e "$spare_modifier=space"
$HOME/xcape3 -e "$spare_modifier=space"

# Shift and parenthesis
xcape -e 'Shift_L=parenleft;Shift_R=parenright'

# space+- -> "space"+"-"
#xbindkeys

# beeping off
xset b off

# welcome to Colemak era
#xmodmap ~/.Xmodmap

# swap ` and Delete
xmodmap -e "keycode 22 = grave asciitilde"
xmodmap -e "keycode 49 = BackSpace BackSpace BackSpace BackSpace"

# some Chineese
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
# Launch Fcitx Config GUI from contrl center, add Google Pinyin.

export TERMINAL=/usr/bin/kitty
exec i3

