#!/bin/sh

. ~/.builds/path_dir/profile
xmodmap ~/.Xmodmap
xbindkeys
# Caps lock as esc and as ctrl
setxkbmap -option 'caps:ctrl_modifier'
xcape -e 'Caps_Lock=Escape'
# Disable the beeping
xset -b
xrdb ~/.Xresources
sh ~/.fehbg &

if [ -f ~/.local_machine ]; then
	eval ~/.local_machine
fi

sxhkd &
exec bspwm
