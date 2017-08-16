#!/bin/sh

# Get pacaur installed
git clone https://aur.archlinux.org/cower.git ~/cower
git clone https://aur.archlinux.org/pacaur.git ~/pacaur

cd ~/cower
makepkg -sri

cd ~/pacaur
makepkg -sri

rm -rf ~/pacaur ~/cower

pacaur -S 
linux-headers
xorg-server
xorg-xinit
xorg-xmodmap
xorg-setxkbmap
xorg-xset
xorg-xrdb
xcape
bspwm
sxhkd
feh
lemonbar-xft-git
wmname
rxvt-unicode
ttf-font-awesome
ttf-anonymice-powerline
rofi-git
mpd
firefox
dropbox
visual-studio-code

