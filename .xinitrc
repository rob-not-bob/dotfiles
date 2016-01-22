#!/bin/sh

. ~/.builds/path_dir/profile
xmodmap ~/.Xmodmap
xbindkeys
# Disable the beeping
xset -b
xrdb ~/.Xresources
sh ~/.fehbg &

if [ -f ~/.local_machine ]
	source ~/.local_machine;
fi

sxhkd &
exec bspwm
