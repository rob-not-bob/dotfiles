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

	pacman -S grub git zsh --noconfirm
	echo "Enter the disk to install grub to: "
	read DISK
	grub-install --target=i386-pc $DISK
	sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/" /etc/default/grub
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

# Dotfiles
if ! [ -d "/home/ace/bin" ]; then
	echo "Installing dotfiles..."
	git clone https://github.com/th3ac3/dotfiles.git ~/dotfiles
	mv ~/dotfiles/.* ~
	mv ~/dotfiles/* ~
	rm -rf ~/dotfiles
fi

# Pacaur
if ! type "pacaur" &> /dev/null; then
	echo "Installing pacaur..."

	git clone https://aur.archlinux.org/cower.git ~/cower
	git clone https://aur.archlinux.org/pacaur.git ~/pacaur

	cd ~/cower
	makepkg -sri --noconfirm

	cd ~/pacaur
	makepkg -sri --noconfirm

	rm -rf ~/pacaur ~/cower
fi

if ! type "bspwm" > /dev/null; then
	echo "Installing packages..."
	pacaur -S --noedit --noconfirm \
	vim \
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
	compton \
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
fi

# Vim 
if ! [ -d "/home/ace/.vim/bundle/Vundle.vim" ]; then
	echo "Vim setup..."
	mkdir -p ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git /home/ace/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
fi

# Slim login manager setup
if ! systemctl is-enabled slim &> /dev/null; then
	echo "Slim setup..."
	SLIM_CONF="/etc/slim.conf"

	sudo sed -i "s/#focus_password.*/focus_password	yes/" $SLIM_CONF
	sudo sed -i "s/#default_user.*/default_user	ace/" $SLIM_CONF
	sudo sed -i "s/welcome_msg/#welcome_msg/" $SLIM_CONF
	sudo cp ~/pictures/6qZqX.jpg /usr/share/slim/themes/default/background.jpg
	sudo systemctl enable slim
fi

# Virtual Machine guest setup
if [[ "$1" = "vmware" ]]; then
	echo "VMWare Setup..."
	pacaur -S --noconfirm xf86-input-vmmouse xf86-video-vmware open-vm-tools open-vm-tools-dkms xf86-video-vesa xf86-video-fbdev
	sudo systemctl enable vmware-vmblock-fuse
	sudo systemctl enable vmtoolsd
	sudo systemctl start vmtoolsd
	touch ~/.local_machine
	chmod +x ~/.local_machine
	echo "vmware-user-suid-wrapper" >> ~/.local_machine
fi

if [[ "$1" = "vbox" ]]; then
	echo "Virtualbox setup..."
	pacaur -S --noconfirm virtualbox-guest-modules-arch
	pacaur -S --noconfirm virtualbox-guest-utils
	sudo systemctl enable vboxservice
	touch ~/.local_machine
	chmod +x ~/.local_machine
	echo "VBoxClient-all" >> ~/.local_machine
fi

if ! xrandr &> /dev/null; then
	echo "DONE! Simply run the script one more time after rebooting and logging in graphically"
	exit 0
fi

# Monitor setup
CONF_PATH="/etc/X11/xorg.conf.d/10-monitor.conf"
if [ xrandr ] && ! [ -f "$CONF_PATH" ]; then
	echo "Setting up monitor..."
	echo "Enter monitor width: "
	read WIDTH
	echo "Enter monitor height: "
	read HEIGHT
	echo "Enter monitor refreshrate: "
	read HZ

	# Create modeline and get monitor identifier
	modeline=$(cvt $WIDTH $HEIGHT $HZ | tail -n 1)
	modeline_value=$(echo $modeline | sed "s/Modeline //")
	modeline_name=$(echo $modeline | awk '{print $2}')
	identifier=$(xrandr | grep "primary" | awk '{print $1}')

	echo "$modeline"
	echo "Identifier: $identifier"

	# Set a conf file to permanently store the changes
	echo 'Section "Monitor"' | sudo tee -a $CONF_PATH
	echo "	Identifier \"$identifier\"" | sudo tee -a $CONF_PATH
	echo "	$modeline" | sudo tee -a $CONF_PATH
	echo "	Option \"PreferredMode\" $modeline_name" | sudo tee -a $CONF_PATH
	echo "EndSection" | sudo tee -a $CONF_PATH

	# Apply the changes
	echo "xrandr --newmode $modeline_value" | bash -
	echo "xrandr --addmode $identifier $modeline_name" | bash -
	echo "xrandr --output $identifier --mode $modeline_name" | bash -
	~/.fehbg

	firefox "about:accounts?action=signin&entrypoint=menupanel" &
	pkill dropbox
	echo "Linking to dropbox... You can exit this once you've signed in"
	dropbox
	echo "Finished!"
fi

