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
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
echo 'umask 022' >> ~/.bashrc
echo "Finished install"
echo "Make sure to run sudo dpkg-reconfigure locales and source ~/.bashrc and then run ./fetchandbuild.sh"
