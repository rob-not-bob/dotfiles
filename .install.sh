#
#!/usr/bin/bash

# Partion and format disks as well as install linux
if [ $EUID -eq 0 ] && [ "$1" = "new" ]; then
	echo "Partitioning disk..."
	echo "Enter the disk to partion: "
	read DISK
	echo "Enter the size of the boot partition (ex 1G): "
	read BOOT_SIZE
	echo "Enter the size of the swap partition (ex 4G): "
	read SWAP_SIZE
	echo "The rest of the space will be used for /"

	(
		echo o # New partition table
		echo n # New partion
		echo p # primary
		echo 1 # partition number 1
		echo # default - start at begginning of disk
		echo +$BOOT_SIZE # allocate space for boot partition
		echo n
		echo p
		echo 2
		echo # default, start immediately after boot
		echo +$SWAP_SIZE # allocate space for swap
		echo n
		echo p
		echo 3
		echo # default, start after swap
		echo # default, extend to end of disk
		echo a # make a partition bootable
		echo 1 # set partition one with boot flag
		echo w # write the partion table
		echo q # finish
	) | fdisk $DISK

	mkfs.ext4 "$DISK""1" # Make boot ext4
	mkfs.ext4 "$DISK""3" # Make root ext4
	mkswap "$DISK""2" # Make swap swap

	swapon "$DISK""2"
	mount "$DISK""3" /mnt
	mkdir /mnt/boot
	mount "$DISK""1" /mnt/boot

	pacstrap /mnt base base-devel # Install linux

	genfstab -U /mnt >> /mnt/etc/fstab # Create the fstab file

	cp ./.install.sh /mnt/root # Copy and run the script on newly created system
	arch-chroot /mnt /root/.install.sh

	reboot
	exit 0
fi

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

	echo "DONE! After reboot login as ace and run ~/.install.sh to finish installation"
	echo "Rebooting in 5s..."
	sleep 5s

	exit 0
fi

# Dotfiles
if ! [ -d "/home/ace/bin" ] || [ "$1" = "dotfiles" ]; then
	echo "Installing dotfiles..."
	git clone https://github.com/th3ac3/dotfiles.git ~/dotfiles

	# Move dotfiles to home dir
	shopt -s dotglob nullglob
	mv ~/dotfiles/* ~
	rm -rf ~/dotfiles
	git remote set-url origin git@github.com:th3ac3/dotfiles.git
fi

# Pacaur
if ! [ type "pacaur" &> /dev/null ] || [ "$1" = "pacaur" ]; then
	echo "Installing pacaur..."

	git clone https://aur.archlinux.org/cower.git ~/cower
	git clone https://aur.archlinux.org/pacaur.git ~/pacaur

	cd ~/cower
	makepkg -sri --noconfirm --skippgpcheck

	cd ~/pacaur
	makepkg -sri --noconfirm --skippgpcheck

	rm -rf ~/pacaur ~/cower
fi

if ! [ type "bspwm" > /dev/null ] || [ "$1" = "packages" ]; then
	echo "Installing packages..."

	pacaur -S --noedit --noconfirm archlinux-keyring
	pacaur -S --noedit --noconfirm \
	vim \
	openssh \
	xorg-server \
	xorg-xinit \
	xorg-xmodmap \
	xorg-setxkbmap \
	xorg-xset \
	xorg-xrdb \
	xorg-xrandr \
	xclip \
	xcape \
	xdotool \
	bspwm \
	sxhkd \
	feh \
	lemonbar-xft-git \
	compton \
	wmname \
	freeglut \
	glu \
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
	dropbox-cli \
	visual-studio-code

	ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa # Create ssh key for github
fi

# Vim 
if ! [ -d "/home/ace/.vim/bundle/Vundle.vim" ] || [ "$1" = "vim" ]; then
	echo "Vim setup..."
	mkdir -p ~/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git /home/ace/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall
fi

# Slim login manager setup
if ! [ systemctl is-enabled slim &> /dev/null ] || [ "$1" = "slim" ]; then
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

	pacaur -S --noedit --noconfirm \
		xf86-input-vmmouse \
		xf86-video-vmware \
		open-vm-tools \
		open-vm-tools-dkms \
		xf86-video-vesa \
		xf86-video-fbdev

	sudo systemctl enable vmware-vmblock-fuse
	sudo systemctl enable vmtoolsd
	sudo systemctl start vmware-vmblock-fuse
	sudo systemctl start vmtoolsd

	touch ~/.local_machine
	chmod +x ~/.local_machine
	echo "vmware-user-suid-wrapper" >> ~/.local_machine
fi

if [[ "$1" = "vbox" ]]; then
	echo "Virtualbox setup..."

	pacaur -S --noedit --noconfirm virtualbox-guest-modules-arch
	pacaur -S --noedit --noconfirm virtualbox-guest-utils

	sudo systemctl enable vboxservice
	sudo systemctl start vboxservice

	touch ~/.local_machine
	chmod +x ~/.local_machine
	echo "VBoxClient-all" >> ~/.local_machine
fi

if ! [ xrandr &> /dev/null ]; then
	# Add line to bspwmrc to start our install script once rebooted grahpically
	echo "urxvt -e zsh -c \"~/.install.sh; zsh\"" >> ~/.config/bspwm/bspwmrc

	# Start the xserver
	startx
	exit 0
fi

# Graphical setup
CONF_PATH="/etc/X11/xorg.conf.d/10-monitor.conf"
if [ xrandr ] && ! [ -f "$CONF_PATH" ] || [ "$1" = "graphical" ]; then
	LAST_LINE=$(tail -n 1 ~/.config/bspwm/bspwmrc)
	if [[ "$LAST_LINE" == urxvt* ]]; then # If line begins with urxvt
		head -n -1 ~/.config/bspwm/bspwmrc > ~/.config/bspwm/bspwmrc # Remove added line from bspwmrc
	fi

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

	# Set a conf file to permanently store the monitor dimensions
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

	xclip -sel clip < ~/.ssh/id_rsa.pub # Copy our public rsakey to clipboard to add to github
	# Open sign in for accounts
	firefox "about:accounts?action=signin&entrypoint=menupanel" https://gmail.com https://github.com/settings/keys &
	echo "Linking to dropbox... You can exit this once you've signed in"
	dropbox
	echo "Finished!"
	exit 0
fi

