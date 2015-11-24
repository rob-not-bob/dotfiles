#!/bin/sh

. ~/.builds/path_dir/profile
xmodmap ~/.Xmodmap
xbindkeys
# Disable the beeping
xset -b
xrdb ~/.Xresources
sh ~/.fehbg &
sxhkd &
exec bspwm
