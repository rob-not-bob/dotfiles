#!/bin/sh

. /home/ace/.builds/path_dir/profile
xmodmap ~/.Xmodmap
xbindkeys
xrdb ~/.Xresources
sh ~/.fehbg &
sxhkd &
exec bspwm
