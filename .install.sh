#!/bin/sh

# Root user setup
if [[ $EUID -eq 0 ]]; then
	echo "Setting the time to America/Denver..."
	ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime
	hwclock --systohc

	echo "Creating locales..."
	sed -i "s/#  en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/" /etc/locale.gen	
	locale-gen
	echo "LANG=en_US.UTF-8" > /etc/locale.conf

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

	mv ~/.install.sh ~ace
	chown ace:ace ~ace/.install.sh

	echo "DONE! Login as ace and run ~/.install.sh to finish installation."

	exit 0
fi

echo "Installing dotfiles..."
git clone https://github.com/th3ac3/dotfiles.git ~/dotfiles
mv ~/dotfiles/.* ~
mv ~/dotfiles/* ~
rm -rf ~/dotfiles


# Get pacaur installed
echo "Installing pacaur..."

git clone https://aur.archlinux.org/cower.git ~/cower
git clone https://aur.archlinux.org/pacaur.git ~/pacaur

cd ~/cower
makepkg -sri

cd ~/pacaur
makepkg -sri

rm -rf ~/pacaur ~/cower

echo "Installing packages..."
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
ttf-anonymice-powerline-git \
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

echo "Vim setup..."
mkdir -p ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall


# Monitor setup

echo "Setting up monitor..."
echo "Enter monitor width: "
read WIDTH
echo "Enter monitor height: "
read HEIGHT
echo "Enter monitor refreshrate: "
read HZ

modeline=$(cvt $WIDTH $HEIGHT $HZ | tail -n 1)
modeline_name=$(echo $modeline | awk '{print $2}')
echo "$modeline"
identifier=$(xrandr | grep "primary" | awk '{print $1}')
echo "Identifier: $identifier"

CONF_PATH="/etc/X11/xorg.conf.d/10-monitor.conf"
echo 'Section "Monitor"' >> $CONF_PATH
echo "	Identifier \"$identifier\"" >> $CONF_PATH
echo "	$modeline" >> $CONF_PATH
echo "	Option \"PreferredMode\" $modeline_name" >> $CONF_PATH
echo "EndSection" >> $CONF_PATH


# Slim login manager setup

echo "Slim setup..."
SLIM_CONF="/etc/slim.conf"

sudo sed -i "s/#focus_password.*/focus_password	yes/" $SLIM_CONF
sudo sed -i "s/#default_user.*/default_user	ace/" $SLIM_CONF
sudo sed -i "s/welcome_msg/#welcome_msg/" $SLIM_CONF
sudo cp ~/pictures/6qZqX.jpg /usr/share/slim/themes/default/background.jpg
sudo systemctl enable slim

# Virtual Machine guest setup

if [[ "$1" -eq "vmware" ]]; then
	echo "VMWare Setup..."
	pacaur -S xf86-input-vmmouse xf86-video-vmware open-vm-tools open-vm-tools-dkms xf86-video-vesa xf86-video-fbdev
	sudo systemctl enable vmware-vmblock-fuse
	sudo systemctl enable vmtoolsd
	sudo systemctl start vmtoolsd
	touch ~/.local_machine
	chmod +x ~/.local_machine
	echo "vmware-user-suid-wrapper" >> ~/.local_machine
fi

if [[ "$1" -eq "vbox" ]]; then
	echo "Virtualbox setup..."
fi

# Setup dropbox

echo "Dropbox Setup..."
dropbox & # Will prompt the user for login info for dropbox

