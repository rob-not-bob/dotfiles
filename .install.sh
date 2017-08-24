#!/bin/sh

# Root user setup
if [[ $EUID -eq 0 ]]; then
	echo "Setting the time to America/Denver..."
	ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
	hwclock --systohc

	echo "Creating locales..."
	sed -i "s/#  en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/" /etc/locale.gen	
	locale-gen
	echo "LANG=en_US.UTF-8\n" > /etc/locale.conf

	echo "Starting the network..."
	systemctl start dhcpcd
	systemctl enable dhcpcd

	pacman -S grub git zsh
	echo "Enter the disk to install grub to: "
	read DISK
	grub-install --target=i386-pc $DISK
	grub-mkconfig -o /boot/grub/grub.cfg

	echo "Creating user ace..."
	useradd -m -G wheel -s /bin/zsh ace

	echo "Adding wheel group to sudoers file..."
	sed -i "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers

	echo "Set root password"
	passwd
	echo "Set user ace password"
	passwd ace

	git clone https://github.com/th3ac3/dotfiles.git ~ace

	echo "DONE! Login as ace and run ~/.install.sh to finish installation."

	exit 0
fi

# Get pacaur installed
echo "INSTALLING PACAUR..."

git clone https://aur.archlinux.org/cower.git ~/cower
git clone https://aur.archlinux.org/pacaur.git ~/pacaur

cd ~/cower
makepkg -sri

cd ~/pacaur
makepkg -sri

rm -rf ~/pacaur ~/cower

echo "INSTALLING PACKAGES"
pacaur -S \
vim \
linux-headers \
xorg-server \
xorg-xinit \
xorg-xmodmap \
xorg-setxkbmap \
xorg-xset \
xorg-xrdb \
xorg-xrandr \
xcape \
xdotool \
bspwm \
sxhkd \
feh \
lemonbar-xft-git \
wmname \
rxvt-unicode \
ttf-font-awesome \
ttf-anonymice-powerline \
ttf-dejavu \
rofi-git \
nautilus \
evince \
spotify \
alsa-utils \
mpd \
firefox \
slim \
dropbox \
visual-studio-code

# Vim setup

echo "VIM SETUP..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


# Slim login manager setup

echo "Slim setup..."
SLIM_CONF="/etc/slim.conf"

sudo sed -i "s/#focus_password.*/focus_password	yes/" $SLIM_CONF
sudo sed -i "s/#default_user.*/default_user	ace/" $SLIM_CONF
sudo sed -i "s/welcome_msg/#welcome_msg/" $SLIM_CONF
sudo cp ~/pictures/6qZqX.jpg /usr/share/slim/themes/default/background.jpg


# Setup dropbox

echo "Dropbox Setup..."
dropbox & # Will prompt the user for login info for dropbox

