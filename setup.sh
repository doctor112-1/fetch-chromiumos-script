#!/bin/bash

ubuntuversion=$(lsb_release -r)
ubuntunumber=$(cut -f2 <<< "$ubuntuversion")
pythonnumber=$(python3 --version | sed 's/Python //g')

setup () {
	if [ $pythonnumber -gt 3.8 ]
		sudo apt update && sudo apt upgrade -y
		sudo add-apt-repository universe
		sudo apt-get install git gitk git-gui curl
		cd ~ && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git
		echo 'export PATH=/home/user/depot_tools:$PATH' >> ~/.bashrc
		cd /tmp
		cat > ./sudo_editor <<EOF
		#!/bin/sh
		[ "\$1" == "--" ] && shift                 # visudo might pass '--' arg
		echo Defaults \!tty_tickets > \$1          # Entering your password in one shell affects all shells
		echo Defaults timestamp_timeout=180 >> \$1 # Time between re-requesting your password, in minutes
		EOF
		chmod +x ./sudo_editor
		sudo EDITOR=./sudo_editor visudo -f /etc/sudoers.d/relax_requirements
		sudo apt-get install locales
		sudo echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections
		sudo echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8" | debconf-set-selections
		sudo rm "/etc/locale.gen"
		sudo dpkg-reconfigure --frontend noninteractive locales
		git config --global user.email "you@example.com"
		git config --global user.name "Your Name"
		echo 'umask 022' >> ~/.bashrc
		echo "Finished install"
		echo "Run ./fetchandbuild.sh"
	else
		echo "Error: Python Version too low, please update"
	fi
}

if [ $number -eq 22.04 ]; then
	setup
elif [ $number -eq 24.04 ]; then
	echo "Warning: Version is not Ubuntu 22.04"
	sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
	sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
	setup
fi
